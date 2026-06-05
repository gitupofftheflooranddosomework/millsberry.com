#!/usr/bin/env python3
import argparse
import csv
import hashlib
import json
import mimetypes
import re
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.parse import urlparse
from urllib.request import Request, urlopen


INVALID_PATH = re.compile(r'[\\/:*?"<>|]')


def safe_segment(value: str, max_len: int = 140) -> str:
    value = INVALID_PATH.sub("_", value)
    value = value.strip(". ")
    if not value:
        value = "_"
    return value[:max_len]


def extension_for_mimetype(mimetype: str) -> str:
    mimetype = (mimetype or "").lower()
    if "html" in mimetype:
        return ".html"
    if "css" in mimetype:
        return ".css"
    if "javascript" in mimetype:
        return ".js"
    if "gif" in mimetype:
        return ".gif"
    if "jpeg" in mimetype:
        return ".jpg"
    if "png" in mimetype:
        return ".png"
    if "shockwave" in mimetype:
        return ".swf"
    if "pdf" in mimetype:
        return ".pdf"
    if "xml" in mimetype:
        return ".xml"
    if "unity" in mimetype:
        return ".unity3d"
    if "icon" in mimetype:
        return ".ico"
    guessed = mimetypes.guess_extension(mimetype)
    return guessed or ".bin"


def output_path(root: Path, row: dict) -> Path:
    parsed = urlparse(row["original"])
    host = safe_segment(parsed.hostname or "unknown-host")
    parts = [safe_segment(p) for p in parsed.path.strip("/").split("/") if p]
    if not parts:
        parts = ["index"]

    leaf = parts[-1]
    suffix = Path(leaf).suffix
    if not suffix:
        leaf = leaf + extension_for_mimetype(row["mimetype"])

    if parsed.query:
        query_hash = hashlib.sha1(parsed.query.encode("utf-8", "ignore")).hexdigest()[:12]
        p = Path(leaf)
        leaf = f"{p.stem}__q{query_hash}{p.suffix}"

    parts[-1] = leaf
    digest = safe_segment(row["digest"], 80)
    final_name = f'{row["timestamp"]}__{digest}__{parts[-1]}'
    return root / host / Path(*parts[:-1]) / final_name


def read_manifest(path: Path) -> list[dict]:
    data = json.loads(path.read_text(encoding="utf-8"))
    rows = []
    for item in data[1:]:
        if len(item) < 5:
            continue
        rows.append(
            {
                "timestamp": str(item[0]),
                "original": str(item[1]),
                "statuscode": str(item[2]),
                "mimetype": str(item[3]),
                "digest": str(item[4]),
            }
        )
    return rows


def should_keep(row: dict, allow_hosts: set[str], exclude_prefixes: tuple[str, ...]) -> bool:
    parsed = urlparse(row["original"])
    host = parsed.hostname or ""
    if allow_hosts and host not in allow_hosts:
        return False
    path = parsed.path.lower()
    return not any(path.startswith(prefix.lower()) for prefix in exclude_prefixes)


def download_one(row: dict, root: Path, timeout: int, retries: int) -> dict:
    out = output_path(root, row)
    if out.exists() and out.stat().st_size > 0:
        return {**row, "status": "exists", "outfile": str(out), "bytes": out.stat().st_size, "error": ""}

    archive_url = f'https://web.archive.org/web/{row["timestamp"]}id_/{row["original"]}'
    out.parent.mkdir(parents=True, exist_ok=True)
    last_error = ""

    for attempt in range(retries + 1):
        try:
            req = Request(archive_url, headers={"User-Agent": "MillsberryRecovery/1.0"})
            with urlopen(req, timeout=timeout) as response:
                data = response.read()
            out.write_bytes(data)
            return {**row, "status": "downloaded", "outfile": str(out), "bytes": len(data), "error": ""}
        except (HTTPError, URLError, TimeoutError, OSError) as exc:
            last_error = str(exc)
            if attempt < retries:
                time.sleep(0.5 + attempt)

    return {**row, "status": "failed", "outfile": str(out), "bytes": 0, "error": last_error}


def append_log(log_path: Path, results: list[dict]) -> None:
    exists = log_path.exists()
    with log_path.open("a", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=["timestamp", "original", "mimetype", "digest", "status", "outfile", "bytes", "error"],
            extrasaction="ignore",
        )
        if not exists:
            writer.writeheader()
        writer.writerows(results)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--workers", type=int, default=10)
    parser.add_argument("--timeout", type=int, default=18)
    parser.add_argument("--retries", type=int, default=1)
    parser.add_argument("--limit", type=int, default=0)
    parser.add_argument("--skip", type=int, default=0)
    parser.add_argument("--allow-host", action="append", default=[])
    parser.add_argument("--exclude-prefix", action="append", default=[])
    parser.add_argument("--only-failed-from-log")
    args = parser.parse_args()

    root = Path(args.output)
    root.mkdir(parents=True, exist_ok=True)
    log_path = root / "_parallel_download_log.csv"

    rows = read_manifest(Path(args.manifest))
    allow_hosts = set(args.allow_host)
    rows = [r for r in rows if should_keep(r, allow_hosts, tuple(args.exclude_prefix))]

    if args.only_failed_from_log:
        failed = set()
        with Path(args.only_failed_from_log).open(newline="", encoding="utf-8") as handle:
            for row in csv.DictReader(handle):
                if row.get("status") == "failed":
                    failed.add((row.get("timestamp"), row.get("original"), row.get("digest")))
        rows = [r for r in rows if (r["timestamp"], r["original"], r["digest"]) in failed]

    if args.skip:
        rows = rows[args.skip :]
    if args.limit:
        rows = rows[: args.limit]

    print(f"Rows selected: {len(rows)}")
    counts = {"downloaded": 0, "exists": 0, "failed": 0}
    batch = []
    done = 0

    with ThreadPoolExecutor(max_workers=args.workers) as executor:
        futures = [executor.submit(download_one, row, root, args.timeout, args.retries) for row in rows]
        for future in as_completed(futures):
            result = future.result()
            counts[result["status"]] = counts.get(result["status"], 0) + 1
            batch.append(result)
            done += 1
            if len(batch) >= 50:
                append_log(log_path, batch)
                batch = []
                print(f"Done {done}/{len(rows)} downloaded={counts['downloaded']} exists={counts['exists']} failed={counts['failed']}", flush=True)

    if batch:
        append_log(log_path, batch)

    print(f"Complete downloaded={counts['downloaded']} exists={counts['exists']} failed={counts['failed']}")
    print(f"Log: {log_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
