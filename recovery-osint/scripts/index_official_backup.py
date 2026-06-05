#!/usr/bin/env python3
import csv
import hashlib
import json
from collections import Counter, defaultdict
from pathlib import Path


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def main() -> int:
    root = Path("official-full-backup")
    outdir = Path("recovery-osint")
    outdir.mkdir(exist_ok=True)

    files = [p for p in root.rglob("*") if p.is_file() and not p.name.startswith("_")]
    rows = []
    host_counts = Counter()
    ext_counts = Counter()
    byte_counts = Counter()
    for path in files:
        rel = path.relative_to(root)
        host = rel.parts[0] if rel.parts else ""
        ext = path.suffix.lower() or "(none)"
        size = path.stat().st_size
        host_counts[host] += 1
        ext_counts[ext] += 1
        byte_counts[host] += size
        rows.append(
            {
                "relative_path": str(rel).replace("\\", "/"),
                "host": host,
                "extension": ext,
                "bytes": size,
                "sha256": sha256(path),
            }
        )

    with (outdir / "official_full_backup_inventory.csv").open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["relative_path", "host", "extension", "bytes", "sha256"])
        writer.writeheader()
        writer.writerows(rows)

    summary = {
        "file_count": len(files),
        "total_bytes": sum(int(r["bytes"]) for r in rows),
        "by_host": [
            {"host": host, "files": count, "bytes": byte_counts[host]}
            for host, count in host_counts.most_common()
        ],
        "by_extension": [
            {"extension": ext, "files": count}
            for ext, count in ext_counts.most_common()
        ],
    }
    (outdir / "official_full_backup_summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")

    tree_lines = []
    grouped = defaultdict(list)
    for row in rows:
        parts = row["relative_path"].split("/")
        grouped["/".join(parts[: min(len(parts), 3)])].append(row)
    for key in sorted(grouped):
        tree_lines.append(f"{key} ({len(grouped[key])})")
    (outdir / "official_full_backup_tree.txt").write_text("\n".join(tree_lines) + "\n", encoding="utf-8")

    print(f"indexed files={summary['file_count']} bytes={summary['total_bytes']}")
    print(outdir / "official_full_backup_inventory.csv")
    print(outdir / "official_full_backup_summary.json")
    print(outdir / "official_full_backup_tree.txt")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
