const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

class SwfInventoryBuilder {
  constructor(repoRoot, appRoot) {
    this.repoRoot = repoRoot;
    this.appRoot = appRoot;
    this.officialHosts = new Set([
      "www.millsberry.com",
      "millsberry.com",
      "graphics.millsberry.com",
      "devgraphics.millsberry.com",
      "dev2graphics.millsberry.com",
      "dev.millsberry.com",
      "dev2.millsberry.com",
      "www.sillyrabbit.millsberry.com",
      "www.luckycharms.millsberry.com",
      "www.luckycharmsfun.millsberry.com",
      "www.nutsabouthoney.millsberry.com",
      "www.honeydefender.millsberry.com",
      "honeydefender.millsberry.com",
      "www.honeynutcheerios.millsberry.com"
    ]);
    this.assetRoots = [
      path.join(repoRoot, "official-recovered-assets"),
      path.join(repoRoot, "official-full-backup")
    ];
    this.gamesRoot = path.join(appRoot, "recovered-games");
  }

  build() {
    const assets = this.collectAssetSwfs();
    const games = this.collectPlayableSwfs();
    return [...assets, ...games];
  }

  collectAssetSwfs() {
    const deduped = new Map();
    for (const root of this.assetRoots) {
      if (!fs.existsSync(root)) continue;
      this.walkFiles(root, (filePath) => {
        const parsed = this.parseRecoveredName(path.basename(filePath));
        if (!parsed) return;
        const ext = path.extname(parsed.originalName).toLowerCase();
        if (ext !== ".swf") return;

        const relative = path.relative(root, filePath).replace(/\\/g, "/");
        const [host, ...rest] = relative.split("/");
        if (!host || !rest.length || !this.officialHosts.has(host.toLowerCase())) return;

        const cleanRest = rest.slice(0, -1).concat(parsed.originalName).join("/");
        const sourcePath = this.canonicalPath(cleanRest);
        const key = `${host.toLowerCase()}${sourcePath}`;
        const current = deduped.get(key);
        const candidate = {
          id: key,
          kind: "Asset SWF",
          title: path.basename(sourcePath, ".swf"),
          sourceFile: filePath,
          sourcePath,
          sourceHref: sourcePath,
          timestamp: parsed.timestamp
        };
        if (!current || candidate.timestamp >= current.timestamp) {
          deduped.set(key, candidate);
        }
      });
    }
    return Array.from(deduped.values()).sort((a, b) => a.sourcePath.localeCompare(b.sourcePath));
  }

  collectPlayableSwfs() {
    const entries = [];
    if (!fs.existsSync(this.gamesRoot)) return entries;

    this.walkFiles(this.gamesRoot, (filePath) => {
      if (path.extname(filePath).toLowerCase() !== ".swf") return;
      const relative = path.relative(this.gamesRoot, filePath).replace(/\\/g, "/");
      if (relative.startsWith("originals/")) return;
      const href = `/__games/${encodeURIComponent(relative)}`;
      entries.push({
        id: `game:${relative}`,
        kind: "Playable SWF",
        title: path.basename(relative, ".swf"),
        sourceFile: filePath,
        sourcePath: relative,
        sourceHref: href,
        timestamp: ""
      });
    });

    entries.sort((a, b) => a.sourcePath.localeCompare(b.sourcePath));
    return entries;
  }

  walkFiles(root, visitor) {
    const stack = [root];
    while (stack.length) {
      const current = stack.pop();
      for (const entry of fs.readdirSync(current, { withFileTypes: true })) {
        const fullPath = path.join(current, entry.name);
        if (entry.isDirectory()) {
          stack.push(fullPath);
        } else if (entry.isFile()) {
          visitor(fullPath);
        }
      }
    }
  }

  parseRecoveredName(filename) {
    const match = String(filename).match(/^(\d{14})__([A-Z0-9]+)__(.+)$/);
    if (!match) return null;
    return {
      timestamp: match[1],
      digest: match[2],
      originalName: this.stripQueryMarker(match[3])
    };
  }

  stripQueryMarker(name) {
    return String(name).replace(/__q\d+(?=\.[^.]+$)/, "");
  }

  canonicalPath(value) {
    let output = decodeURIComponent(value || "").replace(/\\/g, "/");
    output = output.replace(/^https?:\/\/[^/]+/i, "");
    output = output.split("#")[0];
    if (!output.startsWith("/")) output = `/${output}`;
    return output.replace(/\/+/g, "/");
  }
}

class SwfTeaserExtractor {
  constructor(repoRoot, appRoot, options = {}) {
    this.repoRoot = repoRoot;
    this.appRoot = appRoot;
    this.limit = Number.isFinite(options.limit) ? options.limit : null;
    this.clean = options.clean === true;
    this.javaPath = path.join(repoRoot, "recovery-tools", "jre", "jdk-21.0.11+10-jre", "bin", "java.exe");
    this.ffdecJar = path.join(repoRoot, "recovery-tools", "ffdec", "ffdec-cli.jar");
    this.stageDir = path.join(appRoot, "output", "teaser-stage");
    this.rawExportDir = path.join(appRoot, "output", "teaser-raw");
    this.teaserRoot = path.join(appRoot, "public", "teasers", "swf");
    this.manifestPath = path.join(appRoot, "public", "teasers", "swf-manifest.json");
  }

  run() {
    this.assertPrerequisites();

    const inventoryBuilder = new SwfInventoryBuilder(this.repoRoot, this.appRoot);
    let items = inventoryBuilder.build();
    if (this.limit && this.limit > 0) {
      items = items.slice(0, this.limit);
    }

    if (!items.length) {
      throw new Error("No SWFs found to process.");
    }

    this.prepareOutputFolders();
    this.stageSwfs(items);
    this.exportFrames();

    const manifest = this.publishTeasers(items);
    fs.writeFileSync(this.manifestPath, `${JSON.stringify(manifest, null, 2)}\n`, "utf8");

    console.log(`Processed ${items.length} SWFs`);
    console.log(`Generated ${manifest.length} teaser images`);
    console.log(`Manifest: ${this.manifestPath}`);
  }

  assertPrerequisites() {
    if (!fs.existsSync(this.javaPath)) {
      throw new Error(`Bundled Java not found: ${this.javaPath}`);
    }
    if (!fs.existsSync(this.ffdecJar)) {
      throw new Error(`FFDec CLI jar not found: ${this.ffdecJar}`);
    }
  }

  prepareOutputFolders() {
    if (this.clean) {
      fs.rmSync(this.stageDir, { recursive: true, force: true });
      fs.rmSync(this.rawExportDir, { recursive: true, force: true });
      fs.rmSync(this.teaserRoot, { recursive: true, force: true });
    }
    fs.mkdirSync(this.stageDir, { recursive: true });
    fs.mkdirSync(this.rawExportDir, { recursive: true });
    fs.mkdirSync(this.teaserRoot, { recursive: true });
  }

  stageSwfs(items) {
    for (let i = 0; i < items.length; i += 1) {
      const item = items[i];
      const stageName = `${String(i + 1).padStart(6, "0")}.swf`;
      const stagePath = path.join(this.stageDir, stageName);
      item.stageName = stageName;
      item.stagePath = stagePath;
      fs.copyFileSync(item.sourceFile, stagePath);
    }
  }

  exportFrames() {
    const args = [
      "-jar",
      this.ffdecJar,
      "-format",
      "frame:webp",
      "-select",
      "1",
      "-onerror",
      "ignore",
      "-export",
      "frame",
      this.rawExportDir,
      this.stageDir
    ];

    const result = spawnSync(this.javaPath, args, {
      cwd: this.repoRoot,
      stdio: "inherit"
    });

    if (result.status !== 0) {
      throw new Error(`FFDec export failed with exit code ${result.status}`);
    }
  }

  publishTeasers(items) {
    const manifest = [];

    for (const item of items) {
      const exportedImage = path.join(this.rawExportDir, item.stageName, "1.webp");
      if (!fs.existsSync(exportedImage)) continue;

      const teaserRelative = this.toTeaserRelativePath(item.sourceHref);
      const teaserTarget = path.join(this.teaserRoot, teaserRelative);
      fs.mkdirSync(path.dirname(teaserTarget), { recursive: true });
      fs.copyFileSync(exportedImage, teaserTarget);

      manifest.push({
        id: item.id,
        kind: item.kind,
        title: item.title,
        sourcePath: item.sourcePath,
        sourceHref: item.sourceHref,
        teaserHref: `/__app/teasers/swf/${teaserRelative.replace(/\\/g, "/")}`,
        timestamp: item.timestamp || ""
      });
    }

    manifest.sort((a, b) => a.sourcePath.localeCompare(b.sourcePath));
    return manifest;
  }

  toTeaserRelativePath(sourceHref) {
    const cleaned = String(sourceHref)
      .replace(/^\/__games\//, "games/")
      .replace(/^\/+/, "")
      .replace(/[?&#].*$/, "")
      .replace(/%2F/gi, "/")
      .replace(/[^a-zA-Z0-9/_\.-]/g, "_");
    const withExt = cleaned.toLowerCase().endsWith(".swf") ? cleaned : `${cleaned}.swf`;
    return withExt.replace(/\.swf$/i, ".webp");
  }
}

function parseArgs(argv) {
  const args = { clean: true, limit: null };
  for (let i = 0; i < argv.length; i += 1) {
    const token = argv[i];
    if (token === "--no-clean") {
      args.clean = false;
      continue;
    }
    if (token === "--limit") {
      const value = Number(argv[i + 1]);
      if (Number.isFinite(value) && value > 0) {
        args.limit = value;
      }
      i += 1;
    }
  }
  return args;
}

(function main() {
  const appRoot = path.resolve(__dirname, "..");
  const repoRoot = path.resolve(appRoot, "..");
  const options = parseArgs(process.argv.slice(2));

  try {
    const extractor = new SwfTeaserExtractor(repoRoot, appRoot, options);
    extractor.run();
  } catch (error) {
    console.error(error.message || error);
    process.exitCode = 1;
  }
})();
