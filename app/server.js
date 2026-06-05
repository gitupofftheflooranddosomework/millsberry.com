const fs = require("fs");
const http = require("http");
const path = require("path");
const { URL } = require("url");
const { AccountStore, expiredSessionCookie, sessionCookie } = require("./auth");

const PORT = Number(process.env.PORT || 3000);
const HOST = process.env.HOST || "0.0.0.0";
const DATA_ROOT = process.env.DATA_ROOT || path.resolve(__dirname, "..");
const APP_ROOT = __dirname;
const RECOVERED_GAMES_ROOT = path.join(APP_ROOT, "recovered-games");
const RUFFLE_ROOT = path.join(APP_ROOT, "vendor", "ruffle");
const SWF_TEASER_MANIFEST_PATH = path.join(APP_ROOT, "public", "teasers", "swf-manifest.json");
const ACCOUNT_STORE_PATH = process.env.ACCOUNT_STORE_PATH || path.join(APP_ROOT, "data", "accounts.json");
const MISSING_LOG_PATH = process.env.MISSING_LOG_PATH || path.join(APP_ROOT, "output", "missing-requests.jsonl");
const RUFFLE_URL = process.env.RUFFLE_URL === "0" ? "" : (process.env.RUFFLE_URL || "/__ruffle/ruffle.js");
const TEST_USERNAME = process.env.TEST_USERNAME || "testcitizen";
const TEST_PASSWORD = process.env.TEST_PASSWORD || "millsberry";
const accounts = new AccountStore(ACCOUNT_STORE_PATH);
accounts.seedTestAccount(TEST_USERNAME, TEST_PASSWORD);

const OFFICIAL_HOSTS = new Set([
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

const OFFICIAL_HOST_ALIASES = new Map([
  ["genmills.com", "www.millsberry.com"],
  ["www.genmills.com", "www.millsberry.com"],
  ["generalmills.com", "www.millsberry.com"],
  ["www.generalmills.com", "www.millsberry.com"]
]);

const RECOGNIZED_OFFICIAL_HOSTS = new Set([
  ...OFFICIAL_HOSTS,
  ...OFFICIAL_HOST_ALIASES.keys()
]);

function canonicalOfficialHost(hostname) {
  const normalizedHost = (hostname || "").toLowerCase();
  if (OFFICIAL_HOSTS.has(normalizedHost)) return normalizedHost;
  return OFFICIAL_HOST_ALIASES.get(normalizedHost) || null;
}

function isRecognizedOfficialHost(hostname) {
  return canonicalOfficialHost(hostname) !== null;
}

const MIME_TYPES = {
  ".html": "text/html; charset=utf-8",
  ".phtml": "text/html; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "application/javascript; charset=utf-8",
  ".wasm": "application/wasm",
  ".json": "application/json; charset=utf-8",
  ".gif": "image/gif",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".png": "image/png",
  ".ico": "image/x-icon",
  ".swf": "application/x-shockwave-flash",
  ".pdf": "application/pdf",
  ".xml": "application/xml; charset=utf-8",
  ".txt": "text/plain; charset=utf-8",
  ".unity3d": "application/vnd.unity"
};

const pageRoots = [
  path.join(DATA_ROOT, "official-core-recovered"),
  path.join(DATA_ROOT, "official-recovered"),
  path.join(DATA_ROOT, "official-full-backup")
];
const assetRoots = [
  path.join(DATA_ROOT, "official-recovered-assets"),
  path.join(DATA_ROOT, "official-full-backup")
];
const manifestPath = path.join(DATA_ROOT, "recovery-osint", "official_core_pages_manifest.json");

const PAGE_EXTENSIONS = new Set([".html", ".phtml", ".xml", ".pdf"]);
const STATIC_EXTENSIONS = new Set([
  ".css",
  ".js",
  ".gif",
  ".jpg",
  ".jpeg",
  ".png",
  ".ico",
  ".swf",
  ".txt",
  ".unity3d",
  ".json"
]);

const routeIndex = new Map();
const pathFallbackIndex = new Map();
const assetIndex = new Map();
const assetPathFallbackIndex = new Map();
const assetNameFallbackIndex = new Map();
const assetVersionlessFallbackIndex = new Map();
const pagesByDigest = new Map();
const shopItemCatalog = new Map();
const shopCatalogByShop = new Map();
const shopPageByShop = new Map();
const discoveredShopNames = new Map();
const browsableRoutes = [];
const missingRequests = new Map();
const activePathFallbackIndex = new Map();
let preferredOfficialRoot = null;

const PROCESS_ENDPOINTS = new Set([
  "/process_shortcut.phtml",
  "/process_buddy_list.phtml",
  "/process_signup.phtml",
  "/buddy/process_buddy.phtml",
  "/buddy/buddy_change_process.phtml",
  "/buddy/load_buddy_xml.phtml",
  "/buddy/process_buddy_xml.phtml",
  "/load_buddy_xml.phtml",
  "/complex/process_theater.phtml",
  "/complex/process_theater_tr.phtml",
  "/colhurst/process_tunnels.phtml",
  "/colhurst/process_key.phtml",
  "/communitycenter/dojo/process_sensei.phtml",
  "/process_elephant.phtml",
  "/process_form.phtml",
  "/process_search.phtml",
  "/process_colhurst.phtml"
]);

const PLACEHOLDER_ROUTES = new Set([
  "/main_map.phtml",
  "/home/",
  "/signup.phtml",
  "/site_search.phtml",
  "/town_hall/faq.phtml",
  "/town_hall/terms.phtml",
  "/town_hall/policy.phtml",
  "/town_hall/support.phtml"
]);

const HISCORES_CSS_PATH = "/css/gamepages/hiscores.css";
const GENERATED_NAV_IMAGES = new Map([
  ["/site_gfx/nav/nav_signup_1.png", "Sign Up"],
  ["/site_gfx/nav/nav_start_1.png", "Start"],
  ["/site_gfx/nav/nav_the_city_1.png", "The City"],
  ["/site_gfx/nav/nav_downtown_1.png", "Downtown"],
  ["/site_gfx/nav/nav_arcade_1.png", "Arcade"],
  ["/site_gfx/nav/nav_my_stuff_1.png", "My Stuff"],
  ["/site_gfx/nav/nav_my_home_1.png", "My Home"],
  ["/site_gfx/nav/nav_my_place_1.png", "My Place"],
  ["/site_gfx/nav/nav_my_crib_1.png", "My Crib"],
  ["/site_gfx/nav/nav_tour_1.png", "Tour"],
  ["/site_gfx/nav/nav_customize_1.png", "Customize"]
]);

const RECOVERED_GAMES = new Map([
  ["12", { title: "Solver", file: "g12_v9.swf", width: 720, height: 540 }],
  ["18", { title: "Peanut Butter Toast Crunch Swirl", file: "g18_v11.swf", width: 500, height: 500 }],
  ["300", { title: "Lucky Charms: Charmed Life", file: "neopets_g737_v12_44097.swf", width: 640, height: 480 }],
  ["340", { title: "Wave Blaster", file: "g340_v9.swf", width: 600, height: 400 }],
  ["400", { title: "Black Belt Karate", file: "g400_v14.swf", width: 640, height: 480 }],
  ["505", { title: "Horton Hears a Who: Water Water Everywhere", file: "pji_horton.swf", width: 750, height: 600 }],
  ["510", { title: "Millsberry 500", file: "g510_v1.swf", width: 680, height: 530 }],
  ["511", { title: "Honey Nut Cheerios: Save the Honey", file: "g511_v1.swf", width: 728, height: 315 }]
]);

// These IDs came from historical arcade captures even when the SWF binary is still missing.
const KNOWN_GAME_IDS = [
  "12", "13", "16", "18", "19", "60", "80", "100", "140", "160", "180", "220", "240",
  "260", "300", "320", "340", "360", "380", "400", "420", "440", "484", "486", "505",
  "510", "511", "515", "520", "525", "535"
];

// These titles were recovered from archived arcade and hi-score pages even though the SWFs are still missing.
const RECOVERED_PLACEHOLDER_TITLES = new Map([
  ["13", "Hop-N-Drop"],
  ["16", "Millsberry's Match Wanted"],
  ["19", "Peabody Park Cleanup"],
  ["60", "Peabody Park Half-Pipe Competition"],
  ["80", "Countdown!"],
  ["100", "Rope Race"],
  ["140", "Sink The Three!"],
  ["160", "Sherman Home Run Derby"],
  ["180", "Galactic Swirl Defender"],
  ["220", "Cocoa Puffs Crossword"],
  ["240", "Millsberry Hide & Seek"],
  ["260", "Reese's Puffs Cereal Snowboard Slalom"],
  ["300", "Lucky Charms Charmed Life"],
  ["320", "Archery Challenge"],
  ["340", "Wave Blaster"],
  ["360", "Slap Shot Shootout"],
  ["380", "Sudoku"],
  ["400", "Black Belt Karate"],
  ["420", "Millsberry Gazette: Editor in Chief"],
  ["440", "Bumper Boats"],
  ["484", "Tricky Touchdown"],
  ["486", "Kai's Ultimate Surfari"],
  ["505", "Horton Hears a Who: Water Water Everywhere"],
  ["510", "Millsberry 500"],
  ["511", "Honey Nut Cheerios: Save the Honey"],
  ["515", "Honey Nut Cheerios: Buzzing For Water"],
  ["520", "Fruit Roll-Ups Scoops Memory Game"],
  ["525", "Fruit Gushers Flavor Shock presents GushBerry"],
  ["535", "Brick House Hop"]
]);

class GameCatalog {
  constructor(gamesRoot, curatedGames, knownGameIds) {
    this.gamesRoot = path.resolve(gamesRoot);
    this.curatedGames = curatedGames;
    this.knownGameIds = new Set(knownGameIds);
    this.binaryIndex = new Map();
    this.assetBinaryIndex = new Map();
    this.interiorIndex = new Map();
    this.indexBuilt = false;
  }

  registerBinaryCandidate(targetMap, candidate) {
    const current = targetMap.get(candidate.gameId);
    if (!current || candidate.version > current.version) {
      targetMap.set(candidate.gameId, candidate);
    }
    this.knownGameIds.add(candidate.gameId);
  }

  ensureIndexed() {
    if (this.indexBuilt) return;
    walkFiles(this.gamesRoot, (filePath) => {
      const relative = path.relative(this.gamesRoot, filePath).replace(/\\/g, "/");
      if (relative.startsWith("originals/")) return;
      const baseName = path.basename(filePath);
      const gameMatch = baseName.match(/^g(\d+)_v(\d+)\.swf$/i);
      if (gameMatch) {
        const gameId = gameMatch[1];
        const version = Number(gameMatch[2]);
        this.registerBinaryCandidate(this.binaryIndex, {
          gameId,
          version,
          source: "local",
          file: relative,
          title: `Recovered Game ${gameId}`,
          width: 600,
          height: 450
        });
        return;
      }

      const interiorMatch = baseName.match(/^interior_(\d+)_v(\d+)\.swf$/i);
      if (interiorMatch) {
        const gameId = interiorMatch[1];
        const version = Number(interiorMatch[2]);
        // Interior SWFs are launch wrappers/previews, not the actual playable game binary.
        this.registerBinaryCandidate(this.interiorIndex, {
          gameId,
          version,
          source: "local",
          file: relative,
          title: `Recovered Interior Game ${gameId}`,
          width: 600,
          height: 450
        });
      }
    });
    this.indexBuilt = true;
  }

  registerAssetBinary(entry) {
    const name = path.posix.basename(entry.pathname || "").toLowerCase();
    const match = name.match(/^g(\d+)_v(\d+)\.swf$/i);
    if (!match) return;
    const gameId = String(Number(match[1]));
    const version = Number(match[2]);
    if (!Number.isFinite(version)) return;
    this.registerBinaryCandidate(this.assetBinaryIndex, {
      gameId,
      version,
      source: "asset",
      file: entry.pathname,
      host: entry.host,
      title: `Recovered Game ${gameId}`,
      width: 600,
      height: 450
    });
  }

  registerKnownIds(ids) {
    for (const id of ids) {
      const normalized = String(id || "");
      if (!/^\d+$/.test(normalized)) continue;
      const numeric = Number(normalized);
      // Keep discovery focused on plausible Millsberry game IDs.
      if (numeric < 1 || numeric > 999) continue;
      this.knownGameIds.add(String(numeric));
    }
  }

  registerKnownIdsFromHtml(html) {
    const ids = new Set();
    const patterns = [
      /game_id=([0-9]{1,4})/gi,
      /game_id['"\s:=]+([0-9]{1,4})/gi,
      /launch_game\.phtml[^"']*game_id=([0-9]{1,4})/gi,
      /flashgame_ctp\.phtml[^"']*game_id=([0-9]{1,4})/gi
    ];
    for (const pattern of patterns) {
      for (const match of html.matchAll(pattern)) {
        ids.add(match[1]);
      }
    }
    this.registerKnownIds(ids);
  }

  isKnownGameId(gameId) {
    return this.knownGameIds.has(String(gameId || ""));
  }

  hasInteriorWrapper(gameId) {
    const id = String(gameId || "");
    if (!/^\d+$/.test(id)) return false;
    this.ensureIndexed();
    return this.interiorIndex.has(id);
  }

  resolveGame(gameId, width, height) {
    const id = String(gameId || "");
    if (!/^\d+$/.test(id)) return null;
    this.ensureIndexed();
    const curated = this.curatedGames.get(id);
    const indexed = this.binaryIndex.get(id);
    const assetBacked = this.assetBinaryIndex.get(id);
    const source = curated || indexed || assetBacked;
    if (!source) return null;
    return {
      gameId: id,
      source: source.source || "local",
      host: source.host || "",
      title: source.title || `Recovered Game ${id}`,
      file: source.file,
      width: width || source.width || 600,
      height: height || source.height || 450
    };
  }

  playableGames() {
    this.ensureIndexed();
    const merged = new Map();
    for (const [gameId, game] of this.assetBinaryIndex.entries()) {
      merged.set(gameId, { ...game, gameId });
    }
    for (const [gameId, game] of this.binaryIndex.entries()) {
      merged.set(gameId, { ...game, gameId });
    }
    for (const [gameId, game] of this.curatedGames.entries()) {
      merged.set(gameId, { ...merged.get(gameId), ...game, gameId });
    }
    return Array.from(merged.values()).sort((a, b) => Number(a.gameId) - Number(b.gameId));
  }

  missingKnownGameIds() {
    const playable = new Set(this.playableGames().map((game) => game.gameId));
    return Array.from(this.knownGameIds)
      .filter((gameId) => !playable.has(gameId))
      .sort((a, b) => Number(a) - Number(b));
  }

  placeholderTitle(gameId) {
    const id = String(gameId || "");
    return RECOVERED_PLACEHOLDER_TITLES.get(id) || `Recovered Game ${id}`;
  }
}

const GAME_CATALOG = new GameCatalog(RECOVERED_GAMES_ROOT, RECOVERED_GAMES, KNOWN_GAME_IDS);

function walkFiles(root, visitor) {
  if (!fs.existsSync(root)) return;
  const stack = [root];
  while (stack.length) {
    const current = stack.pop();
    for (const entry of fs.readdirSync(current, { withFileTypes: true })) {
      const full = path.join(current, entry.name);
      if (entry.isDirectory()) {
        stack.push(full);
      } else if (entry.isFile()) {
        visitor(full);
      }
    }
  }
}

function parseRecoveredName(filePath) {
  const name = path.basename(filePath);
  const match = name.match(/^(\d{14})__([A-Z0-9]+)__(.+)$/);
  if (!match) return null;
  return {
    timestamp: match[1],
    digest: match[2],
    originalName: stripQueryMarker(match[3])
  };
}

function stripQueryMarker(name) {
  return name.replace(/__q\d+(?=\.[^.]+$)/, "");
}

function recoveredExtension(name) {
  return name.startsWith(".") ? name.toLowerCase() : path.extname(name).toLowerCase();
}

function canonicalPath(value) {
  let output = decodeURIComponentSafe(value || "/").replace(/\\/g, "/");
  output = output.replace(/^https?:\/\/[^/]+/i, "");
  output = output.split("#")[0];
  if (!output.startsWith("/")) output = `/${output}`;
  output = output.replace(/\/+/g, "/");
  if (output.length > 1 && output.endsWith("/index.phtml")) {
    output = output.slice(0, -"index.phtml".length);
  }
  if (output.length > 1 && output.endsWith("/index.html")) {
    output = output.slice(0, -"index.html".length);
  }
  return output;
}

function canonicalRouteKey(pathname, search = "") {
  const cleanPath = canonicalPath(pathname);
  const params = new URLSearchParams(search || "");
  const pairs = [];
  for (const [key, value] of params.entries()) {
    if (!key) continue;
    pairs.push([key, value]);
  }
  pairs.sort((a, b) => a[0].localeCompare(b[0]) || a[1].localeCompare(b[1]));
  if (!pairs.length) return cleanPath;
  return `${cleanPath}?${pairs.map(([key, value]) => `${encodeURIComponent(key)}=${encodeURIComponent(value)}`).join("&")}`;
}

function digestLookupKey(timestamp, digest) {
  return `${timestamp}__${digest}`;
}

function newest(current, candidate) {
  if (!current) return candidate;
  return candidate.timestamp >= current.timestamp ? candidate : current;
}

function indexRecoveredPages() {
  for (const root of pageRoots) {
    walkFiles(root, (filePath) => {
      const parsed = parseRecoveredName(filePath);
      if (!parsed) return;
      const ext = recoveredExtension(parsed.originalName);
      if (!PAGE_EXTENSIONS.has(ext) && ![".js", ".css"].includes(ext)) return;
      const originalLocation = recoveredOriginalLocation(root, filePath, parsed);
      pagesByDigest.set(digestLookupKey(parsed.timestamp, parsed.digest), {
        filePath,
        timestamp: parsed.timestamp,
        digest: parsed.digest,
        originalName: parsed.originalName,
        ...originalLocation
      });
    });
  }
}

function indexShopCatalog() {
  shopCatalogByShop.clear();
  shopPageByShop.clear();
  discoveredShopNames.clear();
  for (const page of pagesByDigest.values()) {
    if (![".html", ".phtml"].includes(path.extname(page.filePath).toLowerCase())) continue;
    const html = fs.readFileSync(page.filePath, "latin1");
    if (!/process_shop\.phtml/i.test(html)) continue;
    const shopId = normalizeShopId(html.match(/name=['"]shop_id['"][^>]*value=['"](\d+)['"]/i)?.[1] || "");
    if (!shopId) continue;

    const detectedName = detectShopName(html, shopId);
    if (detectedName) {
      discoveredShopNames.set(shopId, detectedName);
    }

    // Keep a canonical archived source page per shop so /shop.phtml?shop_id=* resolves
    // to authentic captures instead of unrelated fallback pages.
    const existingShopPage = shopPageByShop.get(shopId);
    if (!existingShopPage || page.timestamp >= existingShopPage.timestamp) {
      shopPageByShop.set(shopId, page);
    }

    // Extract each purchasable cell so stores like Hair Salon (image-button grid layout) are indexed.
    for (const cell of html.match(/<td\b[\s\S]*?<\/td>/gi) || []) {
      const itemId = cell.match(/name=['"]buy_(\d+):[^'"]+['"]/i)?.[1];
      const priceText = cell.match(/(\d[\d,]*)\s*Millsbucks/i)?.[1];
      if (!itemId || !priceText) continue;
      const embeddedAssetId = cell.match(/item_(\d+)\.swf/i)?.[1];
      const candidate = {
        id: itemId,
        name: cleanRecoveredText(cell.match(/<b>([\s\S]*?)<\/b>\s*<br\s*\/?>/i)?.[1]) || `Item ${itemId}`,
        description: cleanRecoveredText(cell.match(/<i>([\s\S]*?)<\/i>/i)?.[1]),
        price: Number(priceText.replace(/,/g, "")),
        assetPath: embeddedAssetId ? `/items/item_${embeddedAssetId}.swf` : `/items/item_${itemId}.swf`,
        shopId,
        timestamp: page.timestamp
      };

      const existingGlobal = shopItemCatalog.get(itemId);
      if (!existingGlobal || candidate.timestamp >= existingGlobal.timestamp) {
        shopItemCatalog.set(itemId, candidate);
      }

      if (!shopCatalogByShop.has(shopId)) {
        shopCatalogByShop.set(shopId, new Map());
      }
      const byShop = shopCatalogByShop.get(shopId);
      const existingLocal = byShop.get(itemId);
      if (!existingLocal || candidate.timestamp >= existingLocal.timestamp) {
        byShop.set(itemId, candidate);
      }
    }
  }
}

function cleanRecoveredText(value = "") {
  return String(value)
    .replace(/<[^>]*>/g, " ")
    .replace(/&#(\d+);/g, (match, code) => String.fromCharCode(Number(code)))
    .replace(/&amp;/gi, "&")
    .replace(/&quot;/gi, "\"")
    .replace(/&apos;|&#0*39;/gi, "'")
    .replace(/&lt;/gi, "<")
    .replace(/&gt;/gi, ">")
    .replace(/\s+/g, " ")
    .trim();
}

function escapeRegex(value = "") {
  return String(value).replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function normalizeShopLabel(value = "") {
  const cleaned = cleanRecoveredText(value)
    .replace(/\s*\|\s*Millsberry.*$/i, "")
    .replace(/\s*-\s*Millsberry.*$/i, "")
    .replace(/^Millsberry\s*[-:|]\s*/i, "")
    .replace(/^Shop\s*[-:|]\s*/i, "")
    .replace(/\s+/g, " ")
    .trim();
  if (!cleaned || /^shop\s*\d+$/i.test(cleaned)) return "";
  return cleaned;
}

function detectShopName(html, shopId) {
  const escapedShopId = escapeRegex(shopId);
  const candidatePatterns = [
    new RegExp(`shop\\.phtml\\?shop_id=${escapedShopId}[^>]*>([^<]+)<`, "i"),
    /<div[^>]+id=['"]interior_stripe['"][^>]*>[\s\S]*?<a[^>]*>([^<]+)<\/a>/i,
    /<h1[^>]*>([\s\S]*?)<\/h1>/i,
    /<title[^>]*>([\s\S]*?)<\/title>/i
  ];
  for (const pattern of candidatePatterns) {
    const label = normalizeShopLabel(html.match(pattern)?.[1] || "");
    if (label) return label;
  }
  return "";
}

function shopLabelForId(shopId) {
  return SHOP_NAMES.get(shopId) || discoveredShopNames.get(shopId) || `Shop ${shopId}`;
}

function recoveredOriginalLocation(root, filePath, parsed) {
  const relative = path.relative(root, filePath).replace(/\\/g, "/");
  const [host, ...rest] = relative.split("/");
  if (!host || !OFFICIAL_HOSTS.has(host.toLowerCase())) return {};
  const originalName = parsed.originalName.startsWith(".") ? "" : parsed.originalName;
  const pathname = canonicalPath(rest.slice(0, -1).concat(originalName).join("/"));
  return {
    host: host.toLowerCase(),
    pathname
  };
}

function indexManifestRoutes() {
  if (!fs.existsSync(manifestPath)) return;
  const rows = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
  for (const row of rows.slice(1)) {
    const [timestamp, original, statusCode, mimeType, digest] = row;
    if (statusCode !== "200") continue;
    let parsedUrl;
    try {
      parsedUrl = new URL(original);
    } catch {
      continue;
    }
    const page = pagesByDigest.get(digestLookupKey(timestamp, digest));
    if (!page) continue;
    const key = canonicalRouteKey(parsedUrl.pathname, parsedUrl.search);
    const pathname = canonicalPath(parsedUrl.pathname);
    const entry = {
      ...page,
      original,
      host: parsedUrl.hostname,
      route: key,
      pathname,
      mimeType
    };
    routeIndex.set(key, newest(routeIndex.get(key), entry));
    pathFallbackIndex.set(pathname, newest(pathFallbackIndex.get(pathname), entry));
    if (mimeType.includes("html")) {
      browsableRoutes.push(entry);
    }
  }
  browsableRoutes.sort((a, b) => a.route.localeCompare(b.route) || b.timestamp.localeCompare(a.timestamp));
}

function indexAssets() {
  for (const root of assetRoots) {
    walkFiles(root, (filePath) => {
      const parsed = parseRecoveredName(filePath);
      if (!parsed) return;
      const ext = recoveredExtension(parsed.originalName);
      if (!STATIC_EXTENSIONS.has(ext)) return;
      const relative = path.relative(root, filePath).replace(/\\/g, "/");
      const [host, ...rest] = relative.split("/");
      if (!host || !rest.length || !OFFICIAL_HOSTS.has(host.toLowerCase())) return;
      const cleanRest = rest.slice(0, -1).concat(parsed.originalName).join("/");
      const assetPath = canonicalPath(cleanRest);
      const entry = {
        filePath,
        host: host.toLowerCase(),
        pathname: assetPath,
        timestamp: parsed.timestamp
      };
      const hostKey = `${entry.host}${assetPath}`;
      assetIndex.set(hostKey, newest(assetIndex.get(hostKey), entry));
      assetPathFallbackIndex.set(assetPath, newest(assetPathFallbackIndex.get(assetPath), entry));
      assetNameFallbackIndex.set(parsed.originalName.toLowerCase(), newest(assetNameFallbackIndex.get(parsed.originalName.toLowerCase()), entry));
      assetVersionlessFallbackIndex.set(versionlessAssetName(parsed.originalName), newest(assetVersionlessFallbackIndex.get(versionlessAssetName(parsed.originalName)), entry));
    });
  }
}

function indexInferredRoutes() {
  for (const page of pagesByDigest.values()) {
    const ext = recoveredExtension(page.originalName);
    if (!PAGE_EXTENSIONS.has(ext) || !page.pathname || !page.host) continue;
    const key = canonicalRouteKey(page.pathname);
    const entry = {
      ...page,
      original: `http://${page.host}${page.pathname}`,
      route: key,
      mimeType: MIME_TYPES[ext] || "application/octet-stream"
    };
    routeIndex.set(key, newest(routeIndex.get(key), entry));
    pathFallbackIndex.set(page.pathname, newest(pathFallbackIndex.get(page.pathname), entry));
    if (ext === ".html" || ext === ".phtml") {
      browsableRoutes.push(entry);
    }
  }
  browsableRoutes.sort((a, b) => a.route.localeCompare(b.route) || b.timestamp.localeCompare(a.timestamp));
}

function routeEntryFromRecoveredPage(page) {
  const pathname = canonicalPath(page.pathname || "/");
  return {
    ...page,
    original: `http://${page.host || "www.millsberry.com"}${pathname}`,
    route: canonicalRouteKey(pathname),
    pathname,
    mimeType: MIME_TYPES[path.extname(page.filePath).toLowerCase()] || "text/html; charset=utf-8"
  };
}

function isFarewellPageContent(html) {
  return /we were sad to say farewell to such a phenomenal town/i.test(html)
    || /lots of cool stuff you can download now like/i.test(html)
    || /Millsberry was an awesome place for kids to be themselves/i.test(html);
}

function isFarewellHomepage(html) {
  return isFarewellPageContent(html);
}

function indexActivePathFallbackRoutes() {
  for (const page of pagesByDigest.values()) {
    if (!page.pathname || !page.host) continue;
    const ext = path.extname(page.filePath).toLowerCase();
    if (![".html", ".phtml"].includes(ext)) continue;
    try {
      const html = fs.readFileSync(page.filePath, "latin1");
      if (isFarewellPageContent(html)) continue;
      const entry = routeEntryFromRecoveredPage(page);
      activePathFallbackIndex.set(entry.pathname, newest(activePathFallbackIndex.get(entry.pathname), entry));
    } catch {
      // Skip unreadable HTML pages while building active fallbacks.
    }
  }
}

function preferActivePageEntry(entry, pathname) {
  if (!entry || !entry.filePath) return entry;
  if (!String(entry.mimeType || "").includes("html")) return entry;
  if (!fs.existsSync(entry.filePath)) return entry;

  try {
    const html = fs.readFileSync(entry.filePath, "latin1");
    if (!isFarewellPageContent(html)) return entry;
  } catch {
    return entry;
  }

  const activePath = canonicalPath(entry.pathname || pathname || "/");
  const active = activePathFallbackIndex.get(activePath);
  if (!active) {
    if (!preferredOfficialRoot) return entry;
    return {
      ...preferredOfficialRoot,
      route: entry.route,
      pathname: activePath,
      original: entry.original
    };
  }
  return {
    ...active,
    route: entry.route,
    pathname: activePath
  };
}

function resolvePreferredOfficialRoot() {
  const candidates = [];
  for (const page of pagesByDigest.values()) {
    if (page.pathname !== "/") continue;
    if (!["www.millsberry.com", "millsberry.com"].includes(String(page.host || "").toLowerCase())) continue;
    const ext = path.extname(page.filePath).toLowerCase();
    if (![".html", ".phtml"].includes(ext)) continue;
    candidates.push(routeEntryFromRecoveredPage(page));
  }

  candidates.sort((a, b) => b.timestamp.localeCompare(a.timestamp));
  for (const candidate of candidates) {
    try {
      const html = fs.readFileSync(candidate.filePath, "latin1");
      if (!isFarewellHomepage(html)) {
        return candidate;
      }
    } catch {
      // Continue scanning if a candidate file is unreadable.
    }
  }

  return candidates[0] || routeIndex.get("/") || null;
}

function versionlessAssetName(filename) {
  return filename.toLowerCase().replace(/_v\d+(?=\.[^.]+$)/, "");
}

function decodeURIComponentSafe(value) {
  try {
    return decodeURIComponent(value);
  } catch {
    return value;
  }
}

function findRoute(url) {
  const exact = routeIndex.get(canonicalRouteKey(url.pathname, url.search));
  if (exact) return preferActivePageEntry(exact, url.pathname);
  if (url.search) return null;
  const pathOnly = pathFallbackIndex.get(canonicalPath(url.pathname));
  if (pathOnly) return preferActivePageEntry(pathOnly, url.pathname);
  if (url.pathname === "/") {
    return preferActivePageEntry(pathFallbackIndex.get("/gamepages/") || pathFallbackIndex.get("/gamepages/games_list.phtml"), "/");
  }
  return null;
}

function findAsset(url) {
  const requestedHost = (url.searchParams.get("host") || url.hostname || "").toLowerCase();
  const host = canonicalOfficialHost(requestedHost) || "www.millsberry.com";
  const pathname = canonicalPath(url.pathname.replace(/^\/assets\/[^/]+/, ""));
  const filename = path.posix.basename(pathname).toLowerCase();
  return assetIndex.get(`${host}${pathname}`) ||
    assetPathFallbackIndex.get(pathname) ||
    assetNameFallbackIndex.get(filename) ||
    assetVersionlessFallbackIndex.get(versionlessAssetName(filename));
}

function localizeUrl(rawValue, currentHost = "www.millsberry.com") {
  if (!rawValue || /^(javascript:|mailto:|#)/i.test(rawValue)) return rawValue;
  const decoded = rawValue.replace(/&amp;/g, "&");
  try {
    if (/^https?:\/\//i.test(decoded)) {
      const parsed = new URL(decoded);
      if (!isRecognizedOfficialHost(parsed.hostname)) return rawValue;
      return `${parsed.pathname}${parsed.search}${parsed.hash}`;
    }
    if (/^\/\//.test(decoded)) {
      const parsed = new URL(`http:${decoded}`);
      if (!isRecognizedOfficialHost(parsed.hostname)) return rawValue;
      return `${parsed.pathname}${parsed.search}${parsed.hash}`;
    }
    if (decoded.startsWith("/")) return decoded;
  } catch {
    return rawValue;
  }
  return rawValue;
}

function rewriteHtml(html, entry, user) {
  let output = html;
  output = output.replace(/https?:\/\/(www\.)?millsberry\.com/gi, "");
  output = output.replace(/https?:\/\/(graphics|devgraphics|dev2graphics|dev|dev2)\.millsberry\.com/gi, "");
  output = output.replace(/\/\/(www\.)?millsberry\.com/gi, "");
  output = output.replace(/\/\/(graphics|devgraphics|dev2graphics|dev|dev2)\.millsberry\.com/gi, "");
  output = output.replace(/\b(href|src|action|background|codebase)=("|')([^"']+)\2/gi, (match, attr, quote, value) => {
    return `${attr}=${quote}${localizeUrl(value, entry.host)}${quote}`;
  });
  output = output.replace(/\b(value)=("|')(https?:\/\/[^"']+)\2/gi, (match, attr, quote, value) => {
    return `${attr}=${quote}${localizeUrl(value, entry.host)}${quote}`;
  });
  output = rewriteEncodedOfficialUrls(output);
  output = rewriteAccountState(output, user);
  output = output.replace(/(<head[^>]*>)/i, `$1\n${ruffleSnippet()}`);
  output = output.replace(/<\/body>/i, `${replayToolbar(entry, user)}</body>`);
  return output;
}

function rewriteAccountState(html, user) {
  let output = html;
  if (!user) return output;
  const accountSummary = [
    `<b>${escapeHtml(user.username)}</b>`,
    `${Number(user.millsBucks || 0).toLocaleString("en-US")} Millsbucks`,
    `<a href="/__account">My Account</a>`,
    `<a href="/home/?user=${encodeURIComponent(user.username)}">My Home</a>`,
    `<a href="/logout.phtml">Log Out</a>`
  ].join(" &nbsp;|&nbsp; ");
  output = output.replace(
    /<form\b[^>]*\bname=(["'])login\1[^>]*>[\s\S]*?<\/form>/gi,
    `<span class="replay-account-summary">${accountSummary}</span>`
  );
  output = output.replace(
    /You are not logged in\.[\s\S]*?(?:SIGN UP NOW!?<\/a>|SIGN UP NOW!?<\/A>)[!.]*/gi,
    `You are logged in as <b>${escapeHtml(user.username)}</b> and can use reconstructed account features.`
  );
  return output;
}

function rewriteEncodedOfficialUrls(html) {
  let output = html;
  for (const host of RECOGNIZED_OFFICIAL_HOSTS) {
    const single = encodeURIComponent(`http://${host}/`);
    const singleHttps = encodeURIComponent(`https://${host}/`);
    const double = encodeURIComponent(single);
    const doubleHttps = encodeURIComponent(singleHttps);
    output = replaceAllCaseInsensitive(output, double, "%252F");
    output = replaceAllCaseInsensitive(output, doubleHttps, "%252F");
    output = replaceAllCaseInsensitive(output, single, "%2F");
    output = replaceAllCaseInsensitive(output, singleHttps, "%2F");
  }
  return output;
}

function replaceAllCaseInsensitive(value, search, replacement) {
  return value.replace(new RegExp(escapeRegExp(search), "gi"), replacement);
}

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function ruffleSnippet() {
  const snippets = [legacyFlashShimSnippet()];
  if (RUFFLE_URL) {
    snippets.push(
      "<script>",
      "window.RufflePlayer = window.RufflePlayer || {};",
      "window.RufflePlayer.config = { autoplay: 'on', unmuteOverlay: 'hidden', maxExecutionDuration: 2 };",
      "</script>",
      `<script src="${escapeHtml(RUFFLE_URL)}"></script>`
    );
  }
  return snippets.join("\n");
}

function legacyFlashShimSnippet() {
  // Many recovered pages call flash_object(...) from inline scripts.
  // Provide a resilient local implementation so archived markup can render.
  return [
    "<script>",
    "(function(){",
    "  if (typeof window.flash_object === 'function') return;",
    "  function esc(value){",
    "    return String(value == null ? '' : value)",
    "      .replace(/&/g, '&amp;')",
    "      .replace(/</g, '&lt;')",
    "      .replace(/>/g, '&gt;')",
    "      .replace(/\"/g, '&quot;');",
    "  }",
    "  window.flash_object = function(src, width, height, flashVars, version, scale, wmode){",
    "    var objectHtml = '' +",
    "      '<object data=\"' + esc(src || '') + '\" type=\"application/x-shockwave-flash\" width=\"' + esc(width || 600) + '\" height=\"' + esc(height || 400) + '\">' +",
    "      '<param name=\"movie\" value=\"' + esc(src || '') + '\">' +",
    "      '<param name=\"flashvars\" value=\"' + esc(flashVars || '') + '\">' +",
    "      '<param name=\"wmode\" value=\"' + esc(wmode || 'transparent') + '\">' +",
    "      '<param name=\"scale\" value=\"' + esc(scale || 'noscale') + '\">' +",
    "      '</object>';",
    "    if (document.currentScript && document.currentScript.parentNode) {",
    "      document.currentScript.parentNode.insertAdjacentHTML('beforeend', objectHtml);",
    "      return;",
    "    }",
    "    if (typeof document.write === 'function') {",
    "      document.write(objectHtml);",
    "    }",
    "  };",
    "})();",
    "</script>"
  ].join('');
}

function replayToolbar(entry, user) {
  const original = escapeHtml(entry.original || entry.route);
  const account = user
    ? `<a href="/__account" style="color:#123d89">${escapeHtml(user.username)}</a>`
    : `<a href="/__account" style="color:#123d89">sign in</a>`;
  return [
    "<div style=\"position:fixed;right:10px;bottom:10px;z-index:2147483647;background:#fffbe8;border:1px solid #8b7a3f;padding:6px 8px;font:12px Arial,sans-serif;color:#222;max-width:360px;box-shadow:0 2px 8px rgba(0,0,0,.18)\">",
    `<b>Official replay</b> ${account} `,
    `<a href=\"/__official-root\" style=\"color:#123d89\">homepage</a> `,
    `<a href="/" style="color:#123d89">routes</a><br>`,
    `<span title="${original}">${escapeHtml(entry.timestamp)} ${escapeHtml(entry.route || entry.pathname)}</span>`,
    "</div>"
  ].join("");
}

function sendFile(res, filePath, overrideType) {
  const ext = path.extname(filePath).toLowerCase();
  const type = overrideType || MIME_TYPES[ext] || "application/octet-stream";
  res.writeHead(200, {
    "Content-Type": type,
    "Cache-Control": "no-store"
  });
  fs.createReadStream(filePath).pipe(res);
}

function sendText(res, status, body, type = "text/html; charset=utf-8", extraHeaders = {}) {
  res.writeHead(status, {
    "Content-Type": type,
    "Cache-Control": "no-store",
    ...extraHeaders
  });
  res.end(body);
}

function sendRedirect(res, location, extraHeaders = {}) {
  res.writeHead(302, {
    "Location": location,
    "Cache-Control": "no-store",
    ...extraHeaders
  });
  res.end();
}

function readRequestBody(req) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    let size = 0;
    req.on("data", (chunk) => {
      size += chunk.length;
      if (size > 1024 * 1024) {
        reject(new Error("Request body exceeds 1 MB."));
        req.destroy();
        return;
      }
      chunks.push(chunk);
    });
    req.on("end", () => resolve(Buffer.concat(chunks).toString("utf8")));
    req.on("error", reject);
  });
}

async function requestParams(req) {
  if (!["POST", "PUT", "PATCH"].includes(req.method || "")) return new URLSearchParams();
  const contentType = String(req.headers["content-type"] || "").split(";")[0].trim();
  const body = await readRequestBody(req);
  if (contentType === "application/json") {
    try {
      const parsed = JSON.parse(body);
      return new URLSearchParams(Object.entries(parsed).map(([key, value]) => [key, String(value)]));
    } catch {
      return new URLSearchParams();
    }
  }
  return new URLSearchParams(body);
}

function redirectWithoutParameter(url, parameter) {
  const redirectUrl = new URL(url.toString());
  redirectUrl.searchParams.delete(parameter);
  return `${redirectUrl.pathname}${redirectUrl.search}`;
}

function sendTransparentGif(res) {
  const pixel = Buffer.from("R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==", "base64");
  res.writeHead(200, {
    "Content-Type": "image/gif",
    "Cache-Control": "no-store",
    "X-Replay-Fallback": "missing-official-image"
  });
  res.end(pixel);
}

function sendGeneratedNavImage(req, url, res, label) {
  recordMissing(req, url, "generated-nav-image-fallback");
  const svg = generatedNavSvg(label);
  res.writeHead(200, {
    "Content-Type": "image/svg+xml; charset=utf-8",
    "Cache-Control": "no-store",
    "X-Replay-Fallback": "generated-missing-official-nav-image"
  });
  res.end(svg);
}

function generatedNavSvg(label) {
  const text = escapeHtml(label);
  return `<svg xmlns="http://www.w3.org/2000/svg" width="130" height="35" viewBox="0 0 130 35">
<defs>
  <linearGradient id="button" x1="0" x2="0" y1="0" y2="1">
    <stop offset="0" stop-color="#fff7a8"/>
    <stop offset="0.5" stop-color="#f2cf46"/>
    <stop offset="1" stop-color="#c48715"/>
  </linearGradient>
</defs>
<rect x="1" y="1" width="128" height="33" rx="6" fill="url(#button)" stroke="#713f08" stroke-width="2"/>
<rect x="5" y="5" width="120" height="8" rx="4" fill="#ffffff" opacity=".35"/>
<text x="65" y="23" text-anchor="middle" font-family="Trebuchet MS, Arial, sans-serif" font-size="15" font-weight="700" fill="#1d2e73">${text}</text>
</svg>`;
}

function sendHiscoresCssFallback(req, url, res) {
  recordMissing(req, url, "generated-css-fallback");
  res.writeHead(200, {
    "Content-Type": "text/css; charset=utf-8",
    "Cache-Control": "no-store",
    "X-Replay-Fallback": "generated-missing-official-hiscores-css"
  });
  res.end(`/* Missing official /css/gamepages/hiscores.css; replay-generated fallback. */
#high_scores {
  border-collapse: collapse;
  border: 1px solid #7f7f7f;
}
#high_scores td {
  border-bottom: 1px solid #d6d6d6;
}
#high_scores .high_score_header {
  color: #111;
  font-weight: bold;
}
#content h1,
#content h2,
#content h3 {
  color: #001e7b;
}
`);
}

function sendEmptyCss(req, url, res) {
  recordMissing(req, url, "css-fallback");
  res.writeHead(200, {
    "Content-Type": "text/css; charset=utf-8",
    "Cache-Control": "no-store",
    "X-Replay-Fallback": "missing-official-css"
  });
  res.end("/* Missing official CSS; replay fallback. */\n");
}

function renderIndex(user, activeView = "routes") {
  const uniqueRoutes = [];
  const seen = new Set();
  for (const route of browsableRoutes) {
    if (seen.has(route.route)) continue;
    seen.add(route.route);
    uniqueRoutes.push(route);
  }

  const recoveredSwfs = recoveredSwfEntries();
  const teaserEntries = activeView === "teasers" ? loadSwfTeaserManifest() : [];
  const isSwfView = activeView === "swfs";
  const isTeaserView = activeView === "teasers";
  const quickLinks = [
    ["/arcade", "Recovered Arcade"],
    ["/swfs", "Recovered SWFs"],
    ["/swf-teasers", "SWF Teaser Gallery"],
    ["/classifieds.phtml", "Yard Sale Classifieds"],
    ["/buy_ad.phtml", "Post Yard Sale Ad"],
    ["/gamepages/games_list.phtml", "Games Listing"],
    ["/gamepages/hiscores.phtml", "Hi Scores"],
    ["/main_map.phtml", "Main Map"],
    ["/bank/", "Bank"],
    ["/academy/", "Academy"],
    ["/complex/arcade.phtml", "Arcade"],
    ["/communitycenter/", "Community Center"],
    ["/yard_sale.phtml", "Yard Sales"],
    ["/farm/", "Farm"],
    ["/downloads/history-of-millsberry.pdf", "History PDF"],
    ["/__account", user ? "My Account" : "Test Login"],
    ["/__missing", "Missing Report"]
  ];
  const groups = routeGroups(uniqueRoutes);
  const tabs = [
    { href: "/", label: "Recovered Routes", active: !isSwfView && !isTeaserView },
    { href: "/swfs", label: "Recovered SWFs", active: isSwfView },
    { href: "/swf-teasers", label: "Teaser Photos", active: isTeaserView }
  ];
  const listTitle = isTeaserView ? "SWF Teaser Photos" : (isSwfView ? "Recovered SWFs" : "Recovered Routes");
  const listNote = isTeaserView
    ? "Generated first-frame teaser photos from recovered SWFs. Photos load as you scroll so large sets stay fast."
    : (isSwfView
      ? "These are recovered SWF files and playable binaries. Search by filename, title, or path, then click through to open the file directly."
      : "Recovered official pages, navigation, and SWF assets served locally.");
  const filterPlaceholder = isTeaserView
    ? "Filter teaser photos, e.g. batman, map, g400"
    : (isSwfView
      ? "Filter SWFs, e.g. g400_v14, interior_180, item_7018"
      : "Filter routes, e.g. arcade, game_id=420, historical");
  const resultsLabel = isTeaserView ? "teaser" : (isSwfView ? "swf" : "route");
  const rowCount = isTeaserView ? teaserEntries.length : (isSwfView ? recoveredSwfs.length : uniqueRoutes.length);
  const listRows = isTeaserView
    ? `<div class="route-list teaser-list-wrap" data-route-list>
          <div class="teaser-grid" data-teaser-list></div>
          <div class="teaser-loader" data-teaser-loader hidden>Loading more teaser photos...</div>
          <div class="teaser-empty" data-teaser-empty hidden>No teaser photos matched your filter.</div>
          <div class="teaser-sentinel" data-teaser-sentinel></div>
        </div>`
    : isSwfView
    ? recoveredSwfs.map((entry) => {
      const search = entry.search;
      const href = swfPreviewHref(entry.href);
      return `<div class="route-row" data-route-row data-route="${escapeHtml(entry.path)}" data-timestamp="${escapeHtml(entry.timestamp)}" data-search="${escapeHtml(search)}"><a class="route-path" href="${escapeHtml(href)}">${escapeHtml(entry.label)}</a><span class="route-meta">${escapeHtml(entry.kind)}${entry.timestamp ? ` · ${escapeHtml(entry.timestamp)}` : ""}</span></div>`;
    }).join("")
    : uniqueRoutes.map((route) => {
      const search = `${route.route} ${route.original} ${route.timestamp}`.toLowerCase();
      const href = route.route === "/" ? "/__official-root" : route.route;
      return `<div class="route-row" data-route-row data-route="${escapeHtml(route.route)}" data-timestamp="${escapeHtml(route.timestamp)}" data-search="${escapeHtml(search)}"><a class="route-path" href="${escapeHtml(href)}">${escapeHtml(route.route)}</a><span class="route-meta">${escapeHtml(route.timestamp)}</span></div>`;
    }).join("");

  return `<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Millsberry Official Replay</title>
  <link rel="stylesheet" href="/__app/app.css">
</head>
<body class="replay-index">
  <main class="shell">
    <div class="topbar">
      <div class="brand">
        <img src="/images/site_gfx/logo.gif" alt="Millsberry">
        <div>
          <h1>Official Millsberry Replay</h1>
          <div class="note">Recovered official pages, navigation, and SWF assets served locally.</div>
        </div>
      </div>
      <a class="home-button" href="/__official-root">Enter Main Homepage</a>
    </div>
    <div class="status">
      <span class="pill">${routeIndex.size} exact routes</span>
      <span class="pill">${assetIndex.size} host assets</span>
      <span class="pill">${pagesByDigest.size} recovered page files</span>
      <span class="pill">${recoveredSwfs.length} recovered SWFs</span>
      <span class="pill">${user ? `Signed in: ${escapeHtml(user.username)}` : "Guest session"}</span>
    </div>
    <div class="grid">
      <section class="panel">
        <h2>Start Here</h2>
        <div class="quick-links">
          ${quickLinks.map(([href, label]) => `<a href="${href}">${escapeHtml(label)}</a>`).join("")}
        </div>
        ${user ? `<p class="note"><b>${escapeHtml(user.displayName)}</b><br>${Number(user.millsBucks || 0).toLocaleString("en-US")} Millsbucks</p>` : `<p class="note">Test account: <b>${escapeHtml(TEST_USERNAME)}</b> / <b>${escapeHtml(TEST_PASSWORD)}</b></p>`}
        <p class="note">Flash embeds are served and Ruffle is injected into recovered pages. Some original SWFs may still depend on old browser behavior or missing server APIs.</p>
        ${isTeaserView
          ? `<p class="note">The Teaser Photos tab streams image cards as you scroll. Use the filter box to narrow by title, path, or host.</p>`
          : (isSwfView
            ? `<p class="note">The SWF tab is for direct file browsing. Playable binaries open through the recovered game files, while the rest are the archived assets that were found in the official mirrors.</p>`
            : `<h2 class="section-title">Route Groups</h2>
        <div class="group-list">
          ${groups.map((group) => `<button type="button" data-route-filter="${escapeHtml(group.filter)}"><span>${escapeHtml(group.label)}</span><b>${group.count}</b></button>`).join("")}
        </div>`)}
      </section>
      <section class="panel">
        <nav class="map-tabs" aria-label="Recovered content tabs">
          ${tabs.map((tab) => `<a href="${tab.href}" class="${tab.active ? "active" : ""}">${escapeHtml(tab.label)}</a>`).join("")}
        </nav>
        <h2>${escapeHtml(listTitle)}</h2>
        <p class="note">${escapeHtml(listNote)}</p>
        <div class="filter-controls">
          <div class="filter">
          <input data-filter type="search" placeholder="${escapeHtml(filterPlaceholder)}">
          </div>
          <div class="sort-wrap">
            <label for="route-sort">Sort:</label>
            <select id="route-sort" data-sort>
              ${isTeaserView
      ? `<option value="time-desc">Newest first</option>
              <option value="time-asc">Oldest first</option>
              <option value="route-asc">Title A-Z</option>
              <option value="route-desc">Title Z-A</option>`
      : `<option value="route-asc">${isSwfView ? "SWF A-Z" : "Route A-Z"}</option>
              <option value="route-desc">${isSwfView ? "SWF Z-A" : "Route Z-A"}</option>
              <option value="time-desc">Newest first</option>
              <option value="time-asc">Oldest first</option>`}
            </select>
            <span class="note" data-results-count data-results-label="${resultsLabel}">${rowCount} ${resultsLabel}${rowCount === 1 ? "" : "s"}</span>
          </div>
        </div>
        ${listRows}
      </section>
    </div>
  </main>
  <script src="/__app/index.js"></script>
</body>
</html>`;
}

function renderRecoveredArcade(user) {
  const playableCards = GAME_CATALOG.playableGames().map((game) => `
    <a class="game-card" href="/gamingsystem/launch_game.phtml?game_id=${game.gameId}&width=${game.width}&height=${game.height}">
      <strong>${escapeHtml(game.title)}</strong>
      <span>Game ${game.gameId}</span>
      <b>Play</b>
    </a>`).join("");

  const missingCards = GAME_CATALOG.missingKnownGameIds()
    .map((gameId) => {
      const title = GAME_CATALOG.placeholderTitle(gameId);
      return `
      <a class="game-card" href="/gamepages/flashgame_ctp.phtml?game_id=${gameId}">
        <strong>${escapeHtml(title)}</strong>
        <span>Game ${gameId}</span>
        <b>Open placeholder</b>
      </a>`;
    })
    .join("");

  return renderAppPage(
    "Recovered Arcade",
    `<p class="note">Original game binaries recovered from a preserved 2010 Millsberry browser cache.</p>
    <h2>Playable Games</h2>
    <div class="game-grid">${playableCards}</div>
    <h2 style="margin-top:18px">Known But Not Yet Recovered</h2>
    <p class="note">These game IDs are confirmed from historical arcade pages. Their original SWF files are still missing, so the links open preserved placeholders instead of dead links.</p>
    <div class="game-grid">${missingCards}</div>
    <p><a href="/complex/arcade.phtml">Original arcade page</a> · <a href="/">All recovered routes</a></p>`,
    user
  );
}

function renderSwfPreview(url, user) {
  const source = String(url.searchParams.get("src") || "");
  const decodedSource = decodeURIComponentSafe(source);
  if (!decodedSource || !decodedSource.startsWith("/")) {
    return renderAppPage(
      "SWF Preview",
      `<p class="note">Missing SWF source path. Return to <a href="/swfs">Recovered SWFs</a>.</p>`,
      user
    );
  }

  let exists = false;
  if (decodedSource.startsWith("/__games/")) {
    let relativePath = decodeURIComponentSafe(decodedSource.slice("/__games/".length));
    if (relativePath.startsWith("flashgames/")) {
      relativePath = relativePath.slice("flashgames/".length);
    }
    const gamesRoot = path.resolve(RECOVERED_GAMES_ROOT);
    const gamePath = path.resolve(gamesRoot, relativePath);
    exists = gamePath.startsWith(`${gamesRoot}${path.sep}`) && fs.existsSync(gamePath) && fs.statSync(gamePath).isFile();
  } else if (/\.swf$/i.test(decodedSource)) {
    const previewUrl = new URL(decodedSource, "http://www.millsberry.com");
    const asset = findAsset(previewUrl);
    exists = Boolean(asset && fs.existsSync(asset.filePath));
  }

  if (!exists) {
    return renderAppPage(
      "SWF Preview",
      `<p class="note">That SWF is not currently recovered or indexed: <b>${escapeHtml(decodedSource)}</b></p>
      <p><a href="/swfs">Back to Recovered SWFs</a></p>`,
      user
    );
  }

  const embed = `<div class="map-stage" style="max-width:960px; margin: 14px auto; background:#111;">
      <object data="${escapeHtml(decodedSource)}" type="application/x-shockwave-flash" width="960" height="720">
        <param name="movie" value="${escapeHtml(decodedSource)}">
        <param name="quality" value="high">
        <param name="allowScriptAccess" value="sameDomain">
        <embed src="${escapeHtml(decodedSource)}" type="application/x-shockwave-flash" width="960" height="720" quality="high">
      </object>
    </div>`;

  return `<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>SWF Preview - ${escapeHtml(path.basename(decodedSource))}</title>
  <link rel="stylesheet" href="/__app/app.css">
</head>
<body class="replay-index">
  <main class="shell">
    <div class="topbar">
      <div class="brand">
        <img src="/images/site_gfx/logo.gif" alt="Millsberry">
        <div>
          <h1>SWF Preview</h1>
          <div class="note">${escapeHtml(decodedSource)}</div>
        </div>
      </div>
      <a class="home-button" href="/swfs">Back to Recovered SWFs</a>
    </div>
    <p class="note">This preview loads the SWF through Ruffle where supported. Some ActionScript features may still fail depending on emulator coverage.</p>
    ${embed}
  </main>
  ${RUFFLE_URL ? `<script src="${escapeHtml(RUFFLE_URL)}"></script>` : ""}
</body>
</html>`;
}

function renderSwfTeasers(user) {
  const teasers = loadSwfTeaserManifest();
  if (!teasers.length) {
    return renderAppPage(
      "SWF Teaser Gallery",
      `<p class="note">No teaser manifest found yet. Run <b>node tools/extract-swf-teasers.js</b> in the app directory, then refresh this page.</p>
      <p><a href="/swfs">Back to Recovered SWFs</a></p>`,
      user
    );
  }

  const cards = teasers.map((teaser) => {
    const previewHref = swfPreviewHref(teaser.sourceHref);
    return `<article class="inventory-item">
      <a href="${escapeHtml(previewHref)}"><img src="${escapeHtml(teaser.teaserHref)}" alt="${escapeHtml(teaser.title || teaser.sourcePath || teaser.sourceHref)}" style="width:100%; max-width:220px; height:auto; border:1px solid #c9bd8f;"></a>
      <h2 style="font-size:13px; overflow-wrap:anywhere;">${escapeHtml(teaser.title || path.basename(teaser.sourcePath || teaser.sourceHref))}</h2>
      <p style="min-height:0;">${escapeHtml(teaser.kind || "SWF")}</p>
      <a href="${escapeHtml(previewHref)}">Open Preview</a>
    </article>`;
  }).join("");

  return renderAppPage(
    "SWF Teaser Gallery",
    `<p class="note">Generated teaser frames from recovered SWFs. Click any card to open a playable preview route.</p>
    <div class="inventory-grid">${cards}</div>
    <p><a href="/swfs">Back to Recovered SWFs</a></p>`,
    user
  );
}

function renderRecoveredGame(url) {
  const gameId = url.searchParams.get("game_id") || "";
  const requestedWidth = Number(url.searchParams.get("width"));
  const requestedHeight = Number(url.searchParams.get("height"));
  const width = Number.isFinite(requestedWidth) && requestedWidth > 0 ? Math.min(requestedWidth, 1200) : null;
  const height = Number.isFinite(requestedHeight) && requestedHeight > 0 ? Math.min(requestedHeight, 900) : null;
  const game = GAME_CATALOG.resolveGame(gameId, width, height);
  if (!game) return null;
  const quality = url.searchParams.get("quality") || "high";
  // Preserve launch flags from historical links so game variants can be selected when available.
  const launchParam = (name, fallback) => {
    const value = url.searchParams.get(name);
    return value === null ? fallback : value;
  };
  const gameBase = `http://${url.host}/__games/`;
  const movieParams = new URLSearchParams({
    game_id: gameId,
    id: gameId,
    itemID: gameId,
    member: "0",
    username: "",
    q: quality,
    quality,
    FG_GAME_BASE: gameBase,
    baseurl: url.host,
    imageurl: gameBase,
    lang: "en",
    hiscore: launchParam("hiscore", "0"),
    sp: launchParam("sp", "0"),
    va: launchParam("va", "1"),
    world: launchParam("world", ""),
    questionSet: launchParam("questionSet", ""),
    r: launchParam("r", "")
  });
  const movieUrl = game.source === "asset"
    ? `${game.file}?host=${encodeURIComponent(game.host || "www.millsberry.com")}&${movieParams.toString()}`
    : `/__games/${encodeURIComponent(game.file)}?${movieParams.toString()}`;
  return `<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${escapeHtml(game.title)} - Millsberry</title>
  ${ruffleSnippet()}
  <style>
    html, body { margin: 0; min-height: 100%; background: #10172b; color: white; font-family: Arial, sans-serif; }
    .game-shell { min-height: 100vh; display: grid; place-items: center; padding: 18px; box-sizing: border-box; }
    .game-frame { width: min(100%, ${width}px); }
    .game-title { display: flex; justify-content: space-between; align-items: center; gap: 16px; margin-bottom: 10px; }
    .game-title h1 { margin: 0; font-size: 20px; }
    .game-title a { color: #ffe66f; }
    object, embed, ruffle-player { display: block; width: 100%; aspect-ratio: ${width} / ${height}; background: #000; }
  </style>
</head>
<body>
  <main class="game-shell">
    <div class="game-frame">
      <div class="game-title">
        <h1>${escapeHtml(game.title)}</h1>
        <a href="/arcade">Arcade</a>
      </div>
      <object data="${escapeHtml(movieUrl)}" type="application/x-shockwave-flash" width="${width}" height="${height}">
        <param name="movie" value="${escapeHtml(movieUrl)}">
        <param name="quality" value="high">
        <param name="allowScriptAccess" value="sameDomain">
        <embed src="${escapeHtml(movieUrl)}" type="application/x-shockwave-flash" width="${width}" height="${height}" quality="high">
      </object>
    </div>
  </main>
</body>
</html>`;
}

function routeGroups(routes) {
  const groupDefs = [
    ["gamepages", "Games", "/gamepages/"],
    ["complex", "Complex", "/complex/"],
    ["academy", "Academy", "/academy/"],
    ["bank", "Bank", "/bank/"],
    ["communitycenter", "Community", "/communitycenter/"],
    ["farm", "Farm", "/farm/"],
    ["buddy", "Buddy", "/buddy/"],
    ["town_hall", "Town Hall", "/town_hall/"],
    ["activities", "Activities", "/activities/"]
  ];
  return groupDefs
    .map(([filter, label, prefix]) => ({
      filter,
      label,
      count: routes.filter((route) => route.route.startsWith(prefix)).length
    }))
    .filter((group) => group.count > 0);
}

function recoveredSwfEntries() {
  const entries = [];
  const seen = new Set();

  for (const asset of assetIndex.values()) {
    const pathname = canonicalPath(asset.pathname || "");
    if (!/\.swf$/i.test(pathname)) continue;
    const key = `asset:${asset.host}${pathname}`;
    if (seen.has(key)) continue;
    seen.add(key);
    const label = path.basename(pathname, ".swf") || pathname;
    entries.push({
      kind: "Asset SWF",
      href: pathname,
      label,
      path: pathname,
      timestamp: asset.timestamp || "",
      search: `${pathname} ${asset.host || ""} ${label}`.toLowerCase()
    });
  }

  for (const game of GAME_CATALOG.playableGames()) {
    const key = `game:${game.gameId}`;
    if (seen.has(key)) continue;
    seen.add(key);
    const href = `/__games/${encodeURIComponent(game.file)}`;
    entries.push({
      kind: "Playable SWF",
      href,
      label: game.title,
      path: game.file,
      timestamp: game.timestamp || "",
      search: `${game.gameId} ${game.title} ${game.file} playable swf`.toLowerCase()
    });
  }

  entries.sort((a, b) => a.path.localeCompare(b.path) || b.timestamp.localeCompare(a.timestamp) || a.label.localeCompare(b.label));
  return entries;
}

function swfPreviewHref(sourcePath = "") {
  return `/__swf_preview?src=${encodeURIComponent(sourcePath)}`;
}

function loadSwfTeaserManifest() {
  if (!fs.existsSync(SWF_TEASER_MANIFEST_PATH)) return [];
  try {
    const manifest = JSON.parse(fs.readFileSync(SWF_TEASER_MANIFEST_PATH, "utf8"));
    if (!Array.isArray(manifest)) return [];
    return manifest.filter((item) => item && item.sourceHref && item.teaserHref);
  } catch {
    return [];
  }
}

function parsePositiveInt(value, fallback, max) {
  const parsed = Number(value);
  if (!Number.isFinite(parsed)) return fallback;
  const normalized = Math.floor(parsed);
  if (normalized < 0) return fallback;
  return Math.min(normalized, max);
}

function compareTeasersBySort(sortBy) {
  const titleValue = (entry) => String(entry.title || path.basename(entry.sourcePath || entry.sourceHref || "")).toLowerCase();
  const stampValue = (entry) => String(entry.timestamp || "");

  if (sortBy === "time-asc") {
    return (a, b) => stampValue(a).localeCompare(stampValue(b)) || titleValue(a).localeCompare(titleValue(b));
  }
  if (sortBy === "route-asc") {
    return (a, b) => titleValue(a).localeCompare(titleValue(b)) || stampValue(b).localeCompare(stampValue(a));
  }
  if (sortBy === "route-desc") {
    return (a, b) => titleValue(b).localeCompare(titleValue(a)) || stampValue(b).localeCompare(stampValue(a));
  }
  return (a, b) => stampValue(b).localeCompare(stampValue(a)) || titleValue(a).localeCompare(titleValue(b));
}

function listTeasersPage(url) {
  const allTeasers = loadSwfTeaserManifest();
  const queryText = String(url.searchParams.get("q") || "").trim().toLowerCase();
  const sortBy = String(url.searchParams.get("sort") || "time-desc");
  const offset = parsePositiveInt(url.searchParams.get("offset"), 0, Math.max(0, allTeasers.length));
  const limit = parsePositiveInt(url.searchParams.get("limit"), 36, 120);

  let filtered = allTeasers;
  if (queryText) {
    const tokens = queryText.split(/\s+/).filter(Boolean);
    filtered = allTeasers.filter((teaser) => {
      const haystack = `${teaser.title || ""} ${teaser.sourcePath || ""} ${teaser.sourceHref || ""} ${teaser.kind || ""} ${teaser.id || ""}`.toLowerCase();
      return tokens.every((token) => haystack.includes(token));
    });
  }

  const sorted = [...filtered].sort(compareTeasersBySort(sortBy));
  const items = sorted.slice(offset, offset + limit);
  const nextOffset = offset + items.length;
  return {
    total: sorted.length,
    offset,
    limit,
    nextOffset,
    hasMore: nextOffset < sorted.length,
    items
  };
}

function recordMissing(req, url, kind) {
  const key = `${kind}:${url.pathname}${url.search}`;
  const current = missingRequests.get(key) || {
    kind,
    path: url.pathname,
    query: url.search,
    count: 0,
    firstSeen: new Date().toISOString(),
    lastSeen: null,
    referers: new Set()
  };
  current.count += 1;
  current.lastSeen = new Date().toISOString();
  const referer = req.headers.referer || req.headers.referrer;
  if (referer) current.referers.add(referer);
  missingRequests.set(key, current);
  appendMissingLog({
    time: current.lastSeen,
    kind,
    path: url.pathname,
    query: url.search,
    referer: referer || null,
    userAgent: req.headers["user-agent"] || null
  });
}

function appendMissingLog(entry) {
  try {
    fs.mkdirSync(path.dirname(MISSING_LOG_PATH), { recursive: true });
    fs.appendFileSync(MISSING_LOG_PATH, `${JSON.stringify(entry)}\n`, "utf8");
  } catch (error) {
    console.warn(`Unable to append missing request log: ${error.message}`);
  }
}

function missingRows() {
  return Array.from(missingRequests.values())
    .sort((a, b) => b.count - a.count || b.lastSeen.localeCompare(a.lastSeen))
    .map((entry) => ({
      ...entry,
      referers: Array.from(entry.referers).slice(0, 5)
    }));
}

function renderMissingReport() {
  const rows = missingRows();
  return `<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Millsberry Missing Report</title>
  <link rel="stylesheet" href="/__app/app.css">
</head>
<body class="replay-index">
  <main class="shell">
    <section class="panel">
      <h1>Missing Report</h1>
      <p class="note">${rows.length} unique missing route or asset requests recorded since server start. Decorative missing images served by transparent fallback are also tracked.</p>
      <p><a href="/">Back to recovered routes</a> · <a href="/__missing.json">JSON</a></p>
      <div class="route-list">
        ${rows.map((row) => `<div class="route-row"><div class="route-path"><b>${escapeHtml(row.kind)}</b> ${escapeHtml(row.path + row.query)}<br><span class="note">${escapeHtml(row.referers.join(" | "))}</span></div><span class="route-meta">${row.count}x</span></div>`).join("") || "<div class=\"route-row\"><div>No missing requests recorded yet.</div></div>"}
      </div>
    </section>
  </main>
</body>
</html>`;
}

function renderAccountPage(user, message = "", error = "", redirect = "/__account") {
  const safeRedirect = safeLocalRedirect(redirect || "/__account");
  const content = user ? `
    <div class="account-grid">
      <section>
        <h2>${escapeHtml(user.displayName)}</h2>
        <dl class="account-stats">
          <dt>Username</dt><dd>${escapeHtml(user.username)}</dd>
          <dt>Millsbucks</dt><dd>${Number(user.millsBucks || 0).toLocaleString("en-US")}</dd>
          <dt>Bank</dt><dd>${Number(user.bankBalance || 0).toLocaleString("en-US")}</dd>
          <dt>Home</dt><dd>${escapeHtml(user.home.address)}, ${escapeHtml(user.home.neighborhood)}</dd>
          <dt>Inventory</dt><dd>${user.inventory.length} items</dd>
          <dt>Buddies</dt><dd>${user.buddies.length}</dd>
        </dl>
      </section>
      <section>
        <h2>Citizen Links</h2>
        <div class="quick-links">
          <a href="/home/?user=${encodeURIComponent(user.username)}">My Home</a>
          <a href="/inventory.phtml">My Stuff</a>
          <a href="/bank/">Bank</a>
          <a href="/buddies.phtml">Buddies</a>
          <a href="/shortcuts.phtml">Shortcuts</a>
          <a href="/main_map.phtml">The City</a>
          <a href="/complex/arcade.phtml">Arcade</a>
          <a href="/logout.phtml">Log Out</a>
        </div>
      </section>
    </div>` : `
    <form class="account-form" method="post" action="/__login">
      <label>Username<input name="login_username" autocomplete="username" required value="${escapeHtml(TEST_USERNAME)}"></label>
      <label>Password<input type="password" name="login_pass" autocomplete="current-password" required value="${escapeHtml(TEST_PASSWORD)}"></label>
          <input type="hidden" name="redirect" value="${escapeHtml(safeRedirect)}">
      <button type="submit">Sign In</button>
    </form>
    <p class="note">Test account: <b>${escapeHtml(TEST_USERNAME)}</b> / <b>${escapeHtml(TEST_PASSWORD)}</b></p>
    <p><a href="/signup.phtml">Create another citizen</a></p>`;
  return renderAppPage(user ? "My Millsberry Account" : "Millsberry Login", content, user, message, error);
}

function renderSignupPage(user, error = "", values = {}) {
  if (user) {
    return renderAppPage(
      "Millsberry Signup",
      `<p>You are already signed in as <b>${escapeHtml(user.username)}</b>.</p><p><a href="/__account">Open My Account</a></p>`,
      user
    );
  }
  const content = `
    <form class="account-form" method="post" action="/process_signup.phtml">
      <label>Username<input name="signup_username" minlength="5" maxlength="20" pattern="[A-Za-z0-9_]+" required value="${escapeHtml(values.signup_username || "")}"></label>
      <label>Password<input type="password" name="signup_password" minlength="6" maxlength="64" pattern="[A-Za-z0-9_]+" required></label>
      <label>Repeat Password<input type="password" name="signup_verify_password" minlength="6" maxlength="64" required></label>
      <label>Display Name<input name="signup_first_name" maxlength="50" value="${escapeHtml(values.signup_first_name || "")}"></label>
      <label>Email<input type="email" name="signup_email" maxlength="100" value="${escapeHtml(values.signup_email || "")}"></label>
      <button type="submit">Sign Up</button>
    </form>
    <p class="note">Local reconstruction accounts are stored only in this Docker app. Usernames and passwords follow the original letters, numbers, and underscores rule.</p>`;
  return renderAppPage("Create a Millsberry Citizen", content, null, "", error);
}

function renderHomePage(viewedUser, signedInUser) {
  if (!viewedUser) {
    return renderAppPage(
      "Citizen Not Found",
      `<p>The requested citizen does not exist in the local reconstruction.</p><p><a href="/__account">My Account</a></p>`,
      signedInUser,
      "",
      "Citizen not found."
    );
  }
  const isOwner = signedInUser && signedInUser.username.toLowerCase() === viewedUser.username.toLowerCase();
  const archivalNote = viewedUser.isArchivalProfile
    ? `<p class="note">This username appears in an official recovered page. Its original account data was not recovered, so this is a read-only archival profile.</p>`
    : "";
  const content = `
    <div class="citizen-home">
      <div class="home-banner">
        <span class="home-avatar">${escapeHtml(viewedUser.username.slice(0, 1).toUpperCase())}</span>
        <div>
          <h2>${escapeHtml(viewedUser.displayName)}'s Home</h2>
          <p>${escapeHtml(viewedUser.home.address)}, ${escapeHtml(viewedUser.home.neighborhood)}</p>
        </div>
      </div>
      ${archivalNote}
      <dl class="account-stats">
        <dt>Citizen since</dt><dd>${escapeHtml(new Date(viewedUser.createdAt).toLocaleDateString("en-US"))}</dd>
        <dt>Inventory</dt><dd>${viewedUser.inventory.length} items</dd>
        <dt>Buddies</dt><dd>${viewedUser.buddies.length}</dd>
      </dl>
      <div class="quick-links">
        ${isOwner ? `<a href="/inventory.phtml">My Stuff</a><a href="/__account">Account</a>` : ""}
        <a href="/main_map.phtml">Return to The City</a>
      </div>
    </div>`;
  return renderAppPage(`${viewedUser.displayName}'s Home`, content, signedInUser);
}

function archivalCitizen(username) {
  const cleanUsername = String(username || "").trim();
  if (!/^[A-Za-z0-9_]{1,40}$/.test(cleanUsername)) return null;
  return {
    username: cleanUsername,
    displayName: cleanUsername,
    millsBucks: 0,
    inventory: [],
    buddies: [],
    home: {
      address: "Archived Millsberry residence",
      neighborhood: "Millsberry"
    },
    createdAt: "2006-01-01T00:00:00.000Z",
    isArchivalProfile: true
  };
}

function renderInventoryPage(user) {
  if (!user) {
    return renderAppPage(
      "My Stuff",
      `<p>You need to sign in before viewing your inventory.</p><p><a href="/__account">Sign In</a></p>`,
      null,
      "",
      "Authentication required."
    );
  }
  const items = user.inventory.length
    ? user.inventory.map((item) => `
      <article class="inventory-item">
        ${renderItemPreview(item, 100)}
        <h2>${escapeHtml(item.name || item.id)}</h2>
        <p>${escapeHtml(item.description || "")}</p>
        <strong>Quantity: ${Number(item.quantity || 1)}</strong>
      </article>`).join("")
    : `<p class="note">Your inventory is empty. Shopping and game rewards will populate this area as those systems are reconstructed.</p>`;
  return renderAppPage("My Stuff", `<div class="inventory-grid">${items}</div>`, user);
}

function renderItemPreview(item, size) {
  const assetPath = item.assetPath || `/items/item_${item.id}.swf`;
  if (assetPathFallbackIndex.has(canonicalPath(assetPath))) {
    return `<object data="${escapeHtml(assetPath)}" type="application/x-shockwave-flash" width="${size}" height="${size}">
      <span class="item-fallback">Item ${escapeHtml(item.id)}</span>
    </object>`;
  }
  const initial = String(item.name || item.id || "?").trim().slice(0, 1).toUpperCase();
  return `<div class="item-preview" style="width:${size}px;height:${size}px" title="Official item artwork was not recovered">
    <span>${escapeHtml(initial)}</span>
    <small>Item ${escapeHtml(item.id)}</small>
  </div>`;
}

function renderPurchasePage(user, item, error = "") {
  const content = error ? `
    <p>Your purchase was not completed.</p>
    <div class="quick-links"><a href="/shop.phtml?shop_id=${encodeURIComponent(item?.shopId || "")}">Return to Shop</a><a href="/inventory.phtml">My Stuff</a></div>` : `
    <div class="purchase-result">
      ${renderItemPreview(item, 120)}
      <div>
        <h2>${escapeHtml(item.name)}</h2>
        <p>${escapeHtml(item.description || "")}</p>
        <p><b>${Number(item.price).toLocaleString("en-US")} Millsbucks</b> spent. Wallet balance: <b>${Number(user.millsBucks).toLocaleString("en-US")}</b>.</p>
      </div>
    </div>
    <div class="quick-links"><a href="/inventory.phtml">View My Stuff</a><a href="/shop.phtml?shop_id=${encodeURIComponent(item.shopId || "")}">Keep Shopping</a></div>`;
  return renderAppPage(error ? "Purchase Not Completed" : "Purchase Complete", content, user, "", error);
}

const YARD_SALE_ITEMS = [
  { id: "yard-1001", name: "Antique Soda Bottle", description: "A vintage bottle found while searching around Millsberry.", price: 100 },
  { id: "yard-1002", name: "Green Star Glasses", description: "A bright pair of star-shaped glasses.", price: 38 },
  { id: "yard-1003", name: "Purple Monster Clock", description: "A playful monster clock for a bedroom or game room.", price: 145 },
  { id: "yard-1004", name: "Beanbag Chair", description: "A comfortable chair ready for a new home.", price: 75 },
  { id: "yard-1005", name: "Snowflake Sweater", description: "An out-of-season bargain from the Yard Sale Classifieds.", price: 200 },
  { id: "yard-1006", name: "Peasant Dress", description: "A colorful dress discovered on the neighborhood sale circuit.", price: 120 },
  { id: "yard-1007", name: "Combat Boots", description: "A sturdy pair of boots at a yard-sale price.", price: 85 },
  { id: "yard-1008", name: "Old Sundial", description: "An unusual antique said to have come from the Colhurst area.", price: 2000 },
  { id: "yard-1009", name: "Suit of Armor", description: "A rare decorative piece for an ambitious collector.", price: 950 }
].map((item) => ({
  ...item,
  assetPath: "/site_gfx/icon_yardsale_1_v1.gif",
  shopId: "yard-sale"
}));

const CLASSIFIED_NEIGHBORHOODS = [
  "Downtown",
  "Lakeview",
  "Golden Valley",
  "Metro Park",
  "Ravenwood",
  "Westridge"
];

function classifiedsListings() {
  return YARD_SALE_ITEMS.map((item, index) => ({
    ...item,
    neighborhood: CLASSIFIED_NEIGHBORHOODS[index % CLASSIFIED_NEIGHBORHOODS.length],
    seller: ["MapleFamily", "RetroCollector", "ParkTreasures", "LakeviewLoft", "RavenwoodDeals", "GoldenValleyShop"][index % 6],
    street: ["Thunderbird Place", "Willow Wood Way", "Oakridge Lane", "Elm Street", "Cedar Court", "Pine Ridge Road"][index % 6],
    saleOffset: index
  }));
}

function renderBuyAdPage(user, message = "", error = "", values = {}) {
  const content = `
    <p class="note">Post a replay classified ad so other citizens can find your Yard Sale listing by neighborhood or keyword.</p>
    <form class="account-form" method="post" action="/buy_ad.phtml">
      <label>Ad title
        <input name="title" value="${escapeHtml(values.title || "")}" maxlength="80" required>
      </label>
      <label>Neighborhood
        <select name="neighborhood" required>
          <option value="">Choose a neighborhood</option>
          ${CLASSIFIED_NEIGHBORHOODS.map((name) => `<option value="${escapeHtml(name)}" ${values.neighborhood === name ? "selected" : ""}>${escapeHtml(name)}</option>`).join("")}
        </select>
      </label>
      <label>Item keyword
        <input name="q" value="${escapeHtml(values.q || "")}" maxlength="80" placeholder="e.g. sweater, boots, armor" required>
      </label>
      <button type="submit">Post replay ad</button>
    </form>
    <div class="quick-links"><a href="/classifieds.phtml">Back to classifieds</a><a href="/yard_sale.phtml">Browse yard sales</a><a href="/inventory.phtml">My Stuff</a></div>`;
  return renderAppPage("Buy Yard Sale Ad", content, user, message, error);
}

function classifiedsSwfPathForNeighborhood(neighborhood = "") {
  const normalized = String(neighborhood || "").trim().toLowerCase();
  const map = new Map([
    ["golden valley", "/site_gfx/interiors/classifieds_golden_valley.swf"],
    ["metro park", "/site_gfx/interiors/classifieds_metro_park.swf"],
    ["lakeview", "/site_gfx/interiors/classifieds_lakeview.swf"],
    ["ravenwood", "/site_gfx/interiors/classifieds_ravenwood.swf"],
    ["westridge", "/site_gfx/interiors/classifieds_westridge.swf"]
  ]);
  return map.get(normalized) || "/site_gfx/interiors/classifieds.swf";
}

function renderClassifiedsPage(user, searchParams, message = "", error = "") {
  const query = String(searchParams.get("q") || "").trim().toLowerCase();
  const neighborhood = String(searchParams.get("neighborhood") || "").trim();
  const selectedSwf = classifiedsSwfPathForNeighborhood(neighborhood);
  const listings = classifiedsListings().filter((listing) => {
    const queryMatch = !query || `${listing.name} ${listing.description}`.toLowerCase().includes(query);
    const neighborhoodMatch = !neighborhood || listing.neighborhood.toLowerCase() === neighborhood.toLowerCase();
    return queryMatch && neighborhoodMatch;
  });

  const listingHtml = listings.length
    ? listings.map((listing) => `
      <tr>
        <td><img src="${escapeHtml(listing.assetPath)}" alt="" width="24" height="24"></td>
        <td><b>${escapeHtml(listing.name)}</b><br><span>${escapeHtml(listing.description)}</span></td>
        <td>${escapeHtml(listing.neighborhood)}</td>
        <td>${escapeHtml(listing.street)}</td>
        <td>${escapeHtml(listing.seller)}</td>
        <td><b>${Number(listing.price).toLocaleString("en-US")}</b></td>
        <td><a href="/yard_sale.phtml?offset=${listing.saleOffset}">Visit</a></td>
      </tr>`).join("")
    : `<tr><td colspan="7">No classifieds matched this filter yet. Try a different neighborhood or keyword.</td></tr>`;

  const notice = error
    ? `<div class="legacy-alert legacy-alert-error">${escapeHtml(error)}</div>`
    : (message ? `<div class="legacy-alert legacy-alert-success">${escapeHtml(message)}</div>` : "");
  const signedInText = user
    ? `Signed in as <b>${escapeHtml(user.username)}</b>`
    : `Browsing as guest. <a href="/__account?redirect=${encodeURIComponent("/classifieds.phtml")}">Sign in</a> for account features.`;

  return `<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Millsberry - Classifieds</title>
  ${ruffleSnippet()}
  <style>
    body { margin: 0; font-family: Verdana, Arial, sans-serif; background: #8b5e34 url('/site_gfx/tile_mill.gif') repeat; color: #111; }
    .legacy-shell { max-width: 1180px; margin: 0 auto; padding: 14px; }
    .legacy-header { background: #d8f3ff; border: 2px solid #2a6a8a; display: flex; align-items: center; gap: 16px; padding: 8px 10px; }
    .legacy-header img { height: 58px; width: auto; }
    .legacy-header-links { display: flex; flex-wrap: wrap; gap: 8px; font-size: 13px; }
    .legacy-header-links a { color: #114c6d; text-decoration: none; font-weight: 700; }
    .legacy-header-links a:hover { text-decoration: underline; }
    .legacy-grid { margin-top: 10px; display: grid; grid-template-columns: 170px 1fr; gap: 10px; }
    .legacy-nav { background: #c4e8f7; border: 2px solid #2a6a8a; padding: 10px; }
    .legacy-nav a { display: block; margin: 6px 0; color: #0f4d6f; text-decoration: none; font-weight: 700; font-size: 13px; }
    .legacy-nav a:hover { text-decoration: underline; }
    .legacy-main { background: #fff; border: 2px solid #2a6a8a; padding: 12px; }
    .legacy-title { margin: 0 0 6px 0; font-size: 28px; letter-spacing: 0.3px; }
    .legacy-sub { margin: 0 0 8px 0; color: #2d2d2d; font-size: 13px; }
    .legacy-alert { margin: 8px 0; padding: 8px 10px; border: 1px solid; font-size: 13px; }
    .legacy-alert-error { background: #ffe6e6; border-color: #bb4f4f; }
    .legacy-alert-success { background: #ecffeb; border-color: #4d9c4d; }
    .legacy-search { display: flex; flex-wrap: wrap; gap: 8px; align-items: end; margin: 10px 0; }
    .legacy-search label { display: flex; flex-direction: column; font-size: 12px; font-weight: 700; }
    .legacy-search input, .legacy-search select { padding: 5px; min-width: 190px; border: 1px solid #6ea7c0; }
    .legacy-search button { border: 1px solid #245b76; background: #2f77a0; color: #fff; padding: 6px 10px; font-weight: 700; cursor: pointer; }
    .legacy-interior { margin: 10px 0 14px; background: #d8d8d8; border: 1px solid #909090; overflow: auto; }
    .legacy-interior object, .legacy-interior embed, .legacy-interior ruffle-player { display: block; width: 960px; height: 720px; background: #000; }
    .legacy-table-wrap { overflow-x: auto; }
    .legacy-table { width: 100%; border-collapse: collapse; font-size: 12px; }
    .legacy-table th, .legacy-table td { border: 1px solid #c6d9e3; padding: 6px; vertical-align: top; }
    .legacy-table th { background: #e9f5fb; text-align: left; }
    .legacy-foot { margin-top: 10px; display: flex; flex-wrap: wrap; gap: 10px; font-size: 13px; }
    .legacy-foot a { color: #0f4d6f; font-weight: 700; }
    @media (max-width: 980px) {
      .legacy-grid { grid-template-columns: 1fr; }
      .legacy-interior object, .legacy-interior embed, .legacy-interior ruffle-player { width: 100%; height: auto; aspect-ratio: 4 / 3; }
    }
  </style>
</head>
<body>
  <div class="legacy-shell">
    <header class="legacy-header">
      <a href="/"><img src="/site_gfx/logo.gif" alt="Millsberry"></a>
      <div>
        <h1 class="legacy-title">Yard Sale Classifieds</h1>
        <p class="legacy-sub">Reconstructed from recovered SWFs and archived route behavior. ${signedInText}</p>
        <div class="legacy-header-links">
          <a href="/home/">My Home</a>
          <a href="/main_map.phtml?location=downtown">Town Center</a>
          <a href="/gamepages/hiscores.phtml">Hi Scores</a>
          <a href="/town_hall/faq.phtml">Help</a>
        </div>
      </div>
    </header>
    <div class="legacy-grid">
      <nav class="legacy-nav">
        <a href="/classifieds.phtml">All Classifieds</a>
        <a href="/classifieds.phtml?neighborhood=Lakeview">Lakeview</a>
        <a href="/classifieds.phtml?neighborhood=Golden+Valley">Golden Valley</a>
        <a href="/classifieds.phtml?neighborhood=Metro+Park">Metro Park</a>
        <a href="/classifieds.phtml?neighborhood=Ravenwood">Ravenwood</a>
        <a href="/classifieds.phtml?neighborhood=Westridge">Westridge</a>
        <a href="/buy_ad.phtml">Place An Ad</a>
        <a href="/yard_sale.phtml">Browse Yard Sales</a>
      </nav>
      <main class="legacy-main">
        ${notice}
        <form class="legacy-search" method="get" action="/classifieds.phtml">
          <label>Neighborhood
            <select name="neighborhood">
              <option value="">All neighborhoods</option>
              ${CLASSIFIED_NEIGHBORHOODS.map((name) => `<option value="${escapeHtml(name)}" ${neighborhood.toLowerCase() === name.toLowerCase() ? "selected" : ""}>${escapeHtml(name)}</option>`).join("")}
            </select>
          </label>
          <label>Item keyword
            <input name="q" value="${escapeHtml(searchParams.get("q") || "")}" maxlength="80" placeholder="Search item names or descriptions">
          </label>
          <button type="submit">Search Classifieds</button>
        </form>

        <div class="legacy-interior">
          <object data="${escapeHtml(selectedSwf)}" type="application/x-shockwave-flash" width="960" height="720">
            <param name="movie" value="${escapeHtml(selectedSwf)}">
            <param name="quality" value="high">
            <embed src="${escapeHtml(selectedSwf)}" type="application/x-shockwave-flash" width="960" height="720" quality="high">
          </object>
        </div>

        <div class="legacy-table-wrap">
          <table class="legacy-table">
            <thead>
              <tr>
                <th></th>
                <th>Listing</th>
                <th>Neighborhood</th>
                <th>Street</th>
                <th>Seller</th>
                <th>Price (MB)</th>
                <th>Sale</th>
              </tr>
            </thead>
            <tbody>${listingHtml}</tbody>
          </table>
        </div>

        <div class="legacy-foot">
          <a href="/buy_ad.phtml">Place an Ad</a>
          <a href="/yard_sale.phtml">Visit Yard Sale</a>
          <a href="/main_map.phtml?location=downtown">Downtown Map</a>
          <a href="/__missing">Recovery Status</a>
        </div>
      </main>
    </div>
  </div>
</body>
</html>`;
}

function renderYardSalePage(user, message = "", error = "", offset = 0) {
  const normalizedOffset = Math.max(0, Number(offset) || 0) % YARD_SALE_ITEMS.length;
  const visibleItems = Array.from(
    { length: 6 },
    (_, index) => YARD_SALE_ITEMS[(normalizedOffset + index) % YARD_SALE_ITEMS.length]
  );
  const cards = visibleItems.map((item) => {
    const action = user
      ? `<form class="inline-account-form" method="post" action="/yard_sale.phtml">
          <input type="hidden" name="item_id" value="${escapeHtml(item.id)}">
          <input type="hidden" name="offset" value="${normalizedOffset}">
          <button type="submit">Buy for ${Number(item.price).toLocaleString("en-US")}</button>
        </form>`
      : `<a href="/__account">Sign in to buy</a>`;
    return `<article class="inventory-item yard-sale-item">
      <img class="yard-sale-icon" src="${escapeHtml(item.assetPath)}" alt="">
      <h2>${escapeHtml(item.name)}</h2>
      <p>${escapeHtml(item.description)}</p>
      <strong>${Number(item.price).toLocaleString("en-US")} Millsbucks</strong>
      ${action}
    </article>`;
  }).join("");
  const nextOffset = (normalizedOffset + 3) % YARD_SALE_ITEMS.length;
  const content = `
    <div class="yard-sale-scene">
      <img src="/site_gfx/interiors/int_yardsale_v2.gif" alt="Millsberry yard sale">
    </div>
    <div class="yard-sale-heading">
      <div>
        <h2>Neighborhood Yard Sale</h2>
        <p>Browse bargains collected from recovered official Yard Sale stories and references.</p>
      </div>
      <a class="app-action" href="/yard_sale.phtml?offset=${nextOffset}">Visit another sale</a>
    </div>
    <p class="note">The authenticated yard-sale response was not archived. This replay uses official artwork and local account inventory data; it does not claim to reproduce the original live listings.</p>
    <div class="inventory-grid">${cards}</div>
    <div class="quick-links"><a href="/classifieds.phtml">Yard Sale Classifieds</a><a href="/buy_ad.phtml">Post an Ad</a><a href="/inventory.phtml">My Stuff</a><a href="/main_map.phtml">Map</a></div>`;
  return renderAppPage("Millsberry Yard Sale", content, user, message, error);
}

function renderBankPage(user, message = "", error = "") {
  if (!user) {
    return renderAppPage("Millsberry Bank", `<p>You need to sign in to use the bank.</p><p><a href="/__account">Sign In</a></p>`, null, "", "Authentication required.");
  }
  const content = `
    <dl class="account-stats bank-balances">
      <dt>Wallet</dt><dd>${Number(user.millsBucks).toLocaleString("en-US")} Millsbucks</dd>
      <dt>Bank balance</dt><dd>${Number(user.bankBalance).toLocaleString("en-US")} Millsbucks</dd>
    </dl>
    <form class="account-form bank-form" method="post" action="/process_bank.phtml">
      <label>Amount<input type="number" name="amount" min="1" step="1" required></label>
      <div class="bank-actions">
        <button type="submit" name="action" value="deposit">Deposit</button>
        <button type="submit" name="action" value="withdraw">Withdraw</button>
      </div>
    </form>
    <p class="note">The official captures describe wallet-to-bank savings, but the original authenticated transaction endpoint was not recovered. This local implementation preserves that behavior without inventing interest rules.</p>`;
  return renderAppPage("Millsberry Bank", content, user, message, error);
}

function renderBuddiesPage(user, message = "", error = "") {
  if (!user) return renderAppPage("My Buddies", `<p><a href="/__account">Sign in</a> to manage buddies.</p>`, null);
  const list = user.buddies.length
    ? `<div class="saved-list">${user.buddies.map((buddy) => `
      <div><a href="/home/?user=${encodeURIComponent(buddy)}">${escapeHtml(buddy)}</a>
      <form method="post" action="/process_buddy_list.phtml"><input type="hidden" name="buddy_username" value="${escapeHtml(buddy)}"><button name="action" value="remove">Remove</button></form></div>`).join("")}</div>`
    : `<p class="note">Your buddy list is empty.</p>`;
  const content = `
    <form class="account-form inline-account-form" method="post" action="/process_buddy_list.phtml">
      <label>Citizen username<input name="buddy_username" required pattern="[A-Za-z0-9_]+"></label>
      <button type="submit" name="action" value="add">Add Buddy</button>
    </form>${list}`;
  return renderAppPage("My Buddies", content, user, message, error);
}

function renderShortcutsPage(user, message = "", error = "") {
  if (!user) return renderAppPage("My Shortcuts", `<p><a href="/__account">Sign in</a> to manage shortcuts.</p>`, null);
  const list = user.shortcuts.length
    ? `<div class="saved-list">${user.shortcuts.map((shortcut) => `
      <div><a href="${escapeHtml(shortcut.url)}">${escapeHtml(shortcut.name)}</a>
      <form method="get" action="/process_shortcut.phtml"><input type="hidden" name="url" value="${escapeHtml(shortcut.url)}"><button name="action" value="remove">Remove</button></form></div>`).join("")}</div>`
    : `<p class="note">Your shortcut list is empty. Recovered pages use their original Add Shortcut control.</p>`;
  return renderAppPage("My Shortcuts", list, user, message, error);
}

const SHOP_NAMES = new Map([
  ["1", "Clothing Store"],
  ["2", "Bookends Bookshop"],
  ["3", "Furniture Store"],
  ["4", "Grocery Store"],
  ["6", "Hair Salon"],
  ["7", "Tricks, Toys & Games"],
  ["8", "Hardware Emporium"],
  ["9", "Pet Palace"],
  ["12", "Home Entertainment"]
]);

function normalizeShopId(value) {
  // Some recovered links and manual inputs include extra text (e.g. "4 5 6").
  // Treat the first numeric token as the intended shop id.
  const normalized = String(value || "").trim();
  const numericToken = normalized.match(/\d+/)?.[0] || "";
  return numericToken ? String(Number(numericToken)) : "";
}

function shopCatalogByShopId() {
  const grouped = new Map();
  for (const [shopId, entriesById] of shopCatalogByShop.entries()) {
    grouped.set(shopId, Array.from(entriesById.values()));
  }
  for (const entries of grouped.values()) {
    entries.sort((a, b) => Number(a.price || 0) - Number(b.price || 0) || String(a.name || "").localeCompare(String(b.name || "")));
  }
  return grouped;
}

function renderShopPage(user, searchParams) {
  const catalog = shopCatalogByShopId();
  const availableShopIds = Array.from(new Set([
    ...SHOP_NAMES.keys(),
    ...catalog.keys()
  ])).sort((a, b) => Number(a) - Number(b));
  const requestedShopId = normalizeShopId(searchParams.get("shop_id"));
  const activeShopId = requestedShopId && (catalog.has(requestedShopId) || SHOP_NAMES.has(requestedShopId))
    ? requestedShopId
    : (availableShopIds.includes("1") ? "1" : (availableShopIds[0] || ""));
  const items = activeShopId ? (catalog.get(activeShopId) || []) : [];
  const nav = availableShopIds.map((shopId) => {
    const label = shopLabelForId(shopId);
    const active = shopId === activeShopId ? "active" : "";
    return `<a class="${active}" href="/shop.phtml?shop_id=${encodeURIComponent(shopId)}">${escapeHtml(label)}</a>`;
  }).join("");

  const parsedClass = String(searchParams.get("class") || "").toLowerCase();
  const parsedMessage = cleanRecoveredText(searchParams.get("msg") || "");
  const message = parsedClass === "success" ? parsedMessage : "";
  const error = parsedClass !== "success" && parsedMessage ? parsedMessage : "";

  if (!activeShopId) {
    return renderAppPage(
      "Millsberry Shop",
      `<p class="note">Recovered shop inventory entries are not indexed yet in this workspace.</p>
      <div class="quick-links"><a href="/main_map.phtml?location=downtown">Return to Downtown</a><a href="/inventory.phtml">My Stuff</a></div>`,
      user,
      message,
      error
    );
  }

  const shopLabel = shopLabelForId(activeShopId);
  const cards = items.length
    ? items.map((item) => {
      const buyField = `buy_${item.id}:1`;
      const buyButton = user
        ? `<button type="submit" name="${escapeHtml(buyField)}" value="buy">Buy for ${Number(item.price || 0).toLocaleString("en-US")}</button>`
        : `<a href="/__account">Sign in to buy</a>`;
      return `<article class="inventory-item">
        ${renderItemPreview(item, 96)}
        <h2>${escapeHtml(item.name || `Item ${item.id}`)}</h2>
        <p>${escapeHtml(item.description || "Official description unavailable.")}</p>
        <strong>${Number(item.price || 0).toLocaleString("en-US")} Millsbucks</strong>
        <form class="inline-account-form" method="post" action="/process_shop.phtml">
          <input type="hidden" name="shop_id" value="${escapeHtml(activeShopId)}">
          ${buyButton}
        </form>
      </article>`;
    }).join("")
    : `<p class="note">No indexed items were recovered for this shop ID yet. Try another shop tab or browse official routes for additional captures.</p>`;

  const content = `
    <nav class="map-tabs" aria-label="Shop categories">${nav}</nav>
    <h2>${escapeHtml(shopLabel)}</h2>
    <p class="note">This page is rebuilt from recovered official shop captures so deep links such as <b>/shop.phtml?shop_id=${escapeHtml(activeShopId)}</b> continue working.</p>
    <div class="inventory-grid">${cards}</div>
    <div class="quick-links"><a href="/main_map.phtml?location=downtown">Return to Downtown</a><a href="/inventory.phtml">My Stuff</a></div>`;
  return renderAppPage(`${shopLabel} - Millsberry Shop`, content, user, message, error);
}

const MAP_VIEWS = {
  city: {
    label: "The City",
    assetPath: "/site_gfx/maps/mainmap_v30.swf",
    assetCandidates: [
      "/site_gfx/maps/mainmap_v31_winter.swf",
      "/site_gfx/maps/mainmap_v30.swf",
      "/site_gfx/maps/mainmap_v27.swf",
      "/site_gfx/maps/mainmap_v24.swf",
      "/site_gfx/maps/mainmap_v18.swf",
      "/site_gfx/maps/mainmap_v13.swf"
    ],
    height: 600,
    destinations: [
      ["Downtown", "/main_map.phtml?location=downtown"],
      ["Lakeview", "/main_map.phtml?location=lakeview"],
      ["Golden Valley", "/main_map.phtml?location=goldenvalley"],
      ["Metro Park", "/main_map.phtml?location=metropark"],
      ["Ravenwood", "/main_map.phtml?location=ravenwood"],
      ["Westridge", "/main_map.phtml?location=westridge"],
      ["Arcade", "/complex/arcade.phtml"],
      ["My Home", "/home/"]
    ]
  },
  downtown: {
    label: "Downtown",
    assetPath: "/site_gfx/maps/downtown_v31.swf",
    assetCandidates: [
      "/site_gfx/maps/downtown_v32_winter.swf",
      "/site_gfx/maps/downtown_v31.swf",
      "/site_gfx/maps/downtown_v29.swf",
      "/site_gfx/maps/downtown_v24.swf",
      "/site_gfx/maps/downtown_v18.swf"
    ],
    height: 600,
    destinations: [
      ["Clothing Store", "/shop.phtml?shop_id=1"],
      ["Bookends Bookshop", "/shop.phtml?shop_id=2"],
      ["Furniture Store", "/shop.phtml?shop_id=3"],
      ["Grocery Store", "/shop.phtml?shop_id=4"],
      ["Hair Salon", "/shop.phtml?shop_id=6"],
      ["Tricks, Toys & Games", "/shop.phtml?shop_id=7"],
      ["Hardware Emporium", "/shop.phtml?shop_id=8"],
      ["Pet Palace", "/shop.phtml?shop_id=9"],
      ["Home Entertainment", "/shop.phtml?shop_id=12"],
      ["Academy", "/academy/"],
      ["Bank", "/bank/"],
      ["Entertainment Complex", "/complex/"],
      ["Community Center", "/communitycenter/"],
      ["Museum", "/museum/"],
      ["Peabody Park", "/peabody_park/"],
      ["Police Department", "/police/"],
      ["Post Office", "/post_office/"],
      ["Recording Studio", "/studio/"],
      ["Town Hall", "/town_hall/"]
    ]
  },
  lakeview: {
    label: "Lakeview",
    assetPath: "/site_gfx/interiors/int_lakeview_v12.swf",
    assetCandidates: [
      "/site_gfx/interiors/int_lakeview_v12.swf",
      "/site_gfx/interiors/int_lakeview_v9.swf"
    ],
    height: 400,
    destinations: [
      ["The City", "/main_map.phtml"],
      ["Downtown", "/main_map.phtml?location=downtown"],
      ["My Home", "/home/"],
      ["My Stuff", "/inventory.phtml"]
    ]
  },
  goldenvalley: {
    label: "Golden Valley",
    assetPath: "/site_gfx/interiors/int_goldenvalley_v10_winter.swf",
    assetCandidates: [
      "/site_gfx/interiors/int_goldenvalley_v10_winter.swf",
      "/site_gfx/interiors/int_goldenvalley_v8.swf"
    ],
    height: 400,
    destinations: [
      ["The City", "/main_map.phtml"],
      ["Downtown", "/main_map.phtml?location=downtown"],
      ["My Home", "/home/"],
      ["My Stuff", "/inventory.phtml"]
    ]
  },
  metropark: {
    label: "Metro Park",
    assetPath: "/site_gfx/interiors/int_metropark_v13_winter.swf",
    assetCandidates: [
      "/site_gfx/interiors/int_metropark_v13_winter.swf",
      "/site_gfx/interiors/int_metropark_v9_winter.swf",
      "/site_gfx/interiors/int_metropark_v8.swf",
      "/site_gfx/interiors/int_metropark_v7.swf"
    ],
    height: 400,
    destinations: [
      ["The City", "/main_map.phtml"],
      ["Downtown", "/main_map.phtml?location=downtown"],
      ["Peabody Park", "/peabody_park/"],
      ["Arcade", "/complex/arcade.phtml"]
    ]
  },
  ravenwood: {
    label: "Ravenwood",
    assetPath: "/site_gfx/interiors/int_ravenwood_v14_winter.swf",
    assetCandidates: [
      "/site_gfx/interiors/int_ravenwood_v14_winter.swf",
      "/site_gfx/interiors/int_ravenwood_v13.swf",
      "/site_gfx/interiors/int_ravenwood_v12.swf",
      "/site_gfx/interiors/int_ravenwood_v10_nocode.swf"
    ],
    height: 400,
    destinations: [
      ["The City", "/main_map.phtml"],
      ["Downtown", "/main_map.phtml?location=downtown"],
      ["My Home", "/home/"],
      ["My Stuff", "/inventory.phtml"]
    ]
  },
  westridge: {
    label: "Westridge",
    assetPath: "/site_gfx/interiors/int_westridge_v10_winter.swf",
    assetCandidates: [
      "/site_gfx/interiors/int_westridge_v10_winter.swf",
      "/site_gfx/interiors/int_westridge_v9.swf",
      "/site_gfx/interiors/int_westridge_v7.swf"
    ],
    height: 400,
    destinations: [
      ["The City", "/main_map.phtml"],
      ["Downtown", "/main_map.phtml?location=downtown"],
      ["My Home", "/home/"],
      ["My Stuff", "/inventory.phtml"]
    ]
  }
};

function mapViewKey(value) {
  const normalized = String(value || "city").toLowerCase().replace(/[^a-z]/g, "");
  return MAP_VIEWS[normalized] ? normalized : "city";
}

function resolveOfficialAssetPath(preferredPath, candidatePaths = []) {
  // Prefer explicit candidates so archived seasonal/versioned maps load automatically.
  const orderedCandidates = [preferredPath, ...candidatePaths].filter(Boolean);
  const seen = new Set();
  for (const candidatePath of orderedCandidates) {
    const normalized = canonicalPath(candidatePath);
    if (seen.has(normalized)) continue;
    seen.add(normalized);
    const probeUrl = new URL(`http://www.millsberry.com${normalized}`);
    const asset = findAsset(probeUrl);
    if (asset && asset.pathname) {
      return { available: true, pathname: asset.pathname };
    }
  }
  return { available: false, pathname: canonicalPath(preferredPath || "/") };
}

function renderOfficialMapObject(assetPath, height, flashVars) {
  return `<object data="${escapeHtml(assetPath)}" type="application/x-shockwave-flash" width="600" height="${height}" style="aspect-ratio:600 / ${height}"><param name="flashvars" value="${escapeHtml(flashVars)}"></object>`;
}

function renderMainMapPage(user, requestedLocation) {
  const activeKey = mapViewKey(requestedLocation);
  const activeView = MAP_VIEWS[activeKey];
  const resolvedMapAsset = resolveOfficialAssetPath(activeView.assetPath, activeView.assetCandidates || []);
  const viewTabs = Object.entries(MAP_VIEWS).map(([key, view]) => {
    const href = key === "city" ? "/main_map.phtml" : `/main_map.phtml?location=${encodeURIComponent(key)}`;
    return `<a class="${key === activeKey ? "active" : ""}" href="${href}">${escapeHtml(view.label)}</a>`;
  }).join("");
  const destinations = activeView.destinations.map(([label, href]) =>
    `<a href="${escapeHtml(href)}">${escapeHtml(label)}</a>`
  ).join("");
  const flashVars = activeView.destinations.map(([label, href], index) => {
    const item = index + 1;
    return `mapLocationDataURL${item}_str=${encodeURIComponent(href)}&mapLocationDataTitle${item}_str=${encodeURIComponent(label)}`;
  }).join("&");
  const mapMarkers = activeView.destinations.slice(0, activeKey === "downtown" ? 9 : 6).map(([label, href], index) =>
    `<a class="map-marker marker-${index + 1}" href="${escapeHtml(href)}">${escapeHtml(label)}</a>`
  ).join("");
  const fallbackLoadMapCall = `loadOfficialMap(this, ${JSON.stringify(resolvedMapAsset.pathname)}, ${activeView.height}, ${JSON.stringify(flashVars)})`;
  const stageContent = resolvedMapAsset.available
    ? renderOfficialMapObject(resolvedMapAsset.pathname, activeView.height, flashVars)
    : `<div class="map-canvas">
          <div class="map-road road-horizontal"></div>
          <div class="map-road road-vertical"></div>
          ${mapMarkers}
          <button class="load-map-button" type="button" onclick="${escapeHtml(fallbackLoadMapCall)}">Load Official Flash Map</button>
        </div>`;
  const content = `
    <nav class="map-tabs" aria-label="Map views">${viewTabs}</nav>
    <div class="map-layout">
      <section class="map-stage" aria-label="${escapeHtml(activeView.label)} map">
        ${stageContent}
      </section>
      <aside class="map-destinations">
        <h2>${escapeHtml(activeView.label)} Destinations</h2>
        <div>${destinations}</div>
      </aside>
    </div>
    <script>
      function loadOfficialMap(button, assetPath, height, flashVars) {
        var stage = button.closest(".map-stage");
        var object = document.createElement("object");
        object.data = assetPath;
        object.type = "application/x-shockwave-flash";
        object.width = "600";
        object.height = String(height);
        object.style.aspectRatio = "600 / " + height;
        var params = document.createElement("param");
        params.name = "flashvars";
        params.value = flashVars;
        object.appendChild(params);
        stage.replaceChildren(object);
      }
    </script>`;
  return renderAppPage(`Millsberry Map: ${activeView.label}`, content, user);
}

function buddyListXml(user) {
  const buddies = user ? user.buddies : [];
  return `<?xml version="1.0" encoding="UTF-8"?>
<buddyList success="1" count="${buddies.length}">
${buddies.map((buddy) => `  <buddy userName="${escapeXml(buddy)}" profile="/home/?user=${encodeURIComponent(buddy)}" />`).join("\n")}
</buddyList>`;
}

function renderAppPage(title, content, user, message = "", error = "") {
  return `<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${escapeHtml(title)}</title>
  <link rel="stylesheet" href="/__app/app.css">
  ${ruffleSnippet()}
</head>
<body class="replay-index">
  <main class="shell">
    <div class="topbar">
      <a class="brand" href="/"><img src="/images/site_gfx/logo.gif" alt="Millsberry"></a>
      <div class="session-links">${user ? `<a href="/__account">${escapeHtml(user.username)}</a> · <a href="/logout.phtml">Log Out</a>` : `<a href="/__account">Sign In</a> · <a href="/signup.phtml">Sign Up</a>`}</div>
    </div>
    <section class="panel">
      <h1>${escapeHtml(title)}</h1>
      ${message ? `<p class="message">${escapeHtml(message)}</p>` : ""}
      ${error ? `<p class="error-message">${escapeHtml(error)}</p>` : ""}
      ${content}
    </section>
  </main>
</body>
</html>`;
}

function renderPlaceholderRoute(url) {
  const title = placeholderTitle(canonicalPath(url.pathname));
  return `<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${escapeHtml(title)}</title>
  <link rel="stylesheet" href="/__app/app.css">
</head>
<body class="replay-index">
  <main class="shell">
    <section class="panel">
      <h1>${escapeHtml(title)}</h1>
      <p class="note">This was a live Millsberry route, but no official page capture is currently available in the recovered files. The replay app keeps this placeholder so navigation continues and the gap stays visible.</p>
      <p class="note">Requested: ${escapeHtml(url.pathname + url.search)}</p>
      <div class="quick-links">
        <a href="/">Recovered routes</a>
        <a href="/gamepages/games_list.phtml">Games Listing</a>
        <a href="/gamepages/hiscores.phtml">Hi Scores</a>
        <a href="/__missing">Missing Report</a>
      </div>
    </section>
  </main>
</body>
</html>`;
}

function renderGamePlaceholder(url) {
  const gameId = url.searchParams.get("game_id") || "unknown";
  const known = GAME_CATALOG.isKnownGameId(gameId);
  const hasInterior = GAME_CATALOG.hasInteriorWrapper(gameId);
  return `<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Millsberry Game ${escapeHtml(gameId)}</title>
  <link rel="stylesheet" href="/__app/app.css">
</head>
<body class="replay-index">
  <main class="shell">
    <section class="panel">
      <h1>Game ${escapeHtml(gameId)}</h1>
      <p class="note">${known
    ? "This game ID is known from historical Millsberry pages, but its launch SWF is not yet recovered."
    : "This game ID was requested by a recovered page or manual URL, but its launch SWF is not yet recovered."}</p>
      ${hasInterior
    ? "<p class=\"note\">A recovered <b>interior_*</b> wrapper exists for this ID, but no playable <b>g*_v*.swf</b> game binary has been recovered yet.</p>"
    : ""}
      <p class="note">The replay app serves this placeholder with HTTP 200 so arcade navigation remains intact while recovery continues.</p>
      <div class="quick-links">
        <a href="/gamepages/hiscores.phtml?game_id=${encodeURIComponent(gameId)}">Hi Scores</a>
        <a href="/gamepages/games_list.phtml">Games Listing</a>
        <a href="/arcade">Recovered Arcade</a>
        <a href="/__missing">Missing Report</a>
      </div>
    </section>
  </main>
</body>
</html>`;
}

function renderSiteSearchPage(url, user) {
  const term = String(url.searchParams.get("search") || url.searchParams.get("q") || "").trim();
  const normalized = term.toLowerCase();
  const rows = normalized
    ? browsableRoutes.filter((entry) => {
      const hay = `${entry.pathname || ""} ${entry.filePath || ""}`.toLowerCase();
      return hay.includes(normalized);
    }).slice(0, 120)
    : [];
  const results = rows.length
    ? rows.map((entry) => `<tr><td><a href="${escapeHtml(entry.pathname || "/")}">${escapeHtml(entry.pathname || "/")}</a></td><td>${escapeHtml(entry.host || "")}</td><td>${escapeHtml(entry.timestamp || "")}</td></tr>`).join("")
    : (term ? `<tr><td colspan="3">No recovered routes matched this search.</td></tr>` : `<tr><td colspan="3">Enter a keyword to search recovered routes.</td></tr>`);
  return `<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Millsberry Search</title>
  <link rel="stylesheet" href="/__app/app.css">
</head>
<body class="replay-index">
  <main class="shell">
    <section class="panel">
      <h1>Site Search</h1>
      <p class="note">Search recovered Millsberry routes by path and source file metadata.</p>
      <form class="account-form" method="get" action="/site_search.phtml">
        <label>Search term
          <input name="search" value="${escapeHtml(term)}" maxlength="120" placeholder="classifieds, arcade, yard_sale, main_map">
        </label>
        <button type="submit">Search</button>
      </form>
      <p class="note">${term ? `${rows.length} result${rows.length === 1 ? "" : "s"} shown` : "No search submitted yet."}</p>
      <table class="route-table">
        <thead><tr><th>Route</th><th>Host</th><th>Timestamp</th></tr></thead>
        <tbody>${results}</tbody>
      </table>
      <div class="quick-links"><a href="/">Recovered Routes</a><a href="/swfs">Recovered SWFs</a><a href="/__missing">Missing Report</a></div>
    </section>
  </main>
</body>
</html>`;
}


function placeholderTitle(pathname) {
  const labels = {
    "/main_map.phtml": "Millsberry Map",
    "/home/": "Millsberry Home",
    "/signup.phtml": "Millsberry Signup",
    "/site_search.phtml": "Millsberry Search",
    "/town_hall/faq.phtml": "Millsberry FAQ",
    "/town_hall/terms.phtml": "Millsberry Terms",
    "/town_hall/policy.phtml": "Millsberry Privacy Policy",
    "/town_hall/support.phtml": "Millsberry Support"
  };
  return labels[pathname] || "Millsberry Placeholder";
}

function handleStubEndpoint(url, res) {
  const pathname = canonicalPath(url.pathname).split("&")[0];
  if (pathname === "/process_break_time.phtml") {
    if (url.searchParams.get("choice") === "2") return sendRedirect(res, "/");
    const redirect = decodeURIComponentSafe(url.searchParams.get("redirect") || "/");
    return sendRedirect(res, safeLocalRedirect(redirect));
  }

  if (pathname === "/top_nav_xml.phtml") {
    return sendText(res, 200, topNavXml(), "application/xml; charset=utf-8");
  }

  if (pathname === "/side_nav_xml.phtml") {
    return sendText(res, 200, sideNavXml(), "application/xml; charset=utf-8");
  }

  if (pathname === "/museum/paint/winners.phtml") {
    return sendRedirect(res, classifiedsSwfCompatibilityRedirect(url));
  }

  if (pathname === "/process_search.phtml") {
    const params = new URLSearchParams(url.searchParams);
    const search = params.get("search") || params.get("q") || "";
    return sendRedirect(res, `/site_search.phtml?search=${encodeURIComponent(search)}`);
  }

  if (pathname === "/process_form.phtml") {
    const redirect = decodeURIComponentSafe(url.searchParams.get("redirect") || "/");
    return sendRedirect(res, safeLocalRedirect(redirect));
  }

  if (pathname === "/buddy/buddy_change_process.phtml") {
    return sendRedirect(res, "/buddies.phtml");
  }

  if (pathname === "/communitycenter/dojo/process_sensei.phtml") {
    return sendRedirect(res, "/communitycenter/");
  }

  if (pathname === "/colhurst/process_key.phtml") {
    return sendRedirect(res, "/colhurst/index.phtml");
  }

  if (pathname === "/process_elephant.phtml") {
    return sendRedirect(res, "/main_map.phtml?location=downtown");
  }

  if (pathname === "/campaigns/frudare2010/ajax.phtml" || pathname.endsWith("/ajax.phtml")) {
    return sendText(res, 200, "<response success=\"1\"><message>Recovered replay stub</message></response>", "application/xml; charset=utf-8");
  }

  if (pathname === "/load_buddy_xml.phtml" || pathname === "/buddy/load_buddy_xml.phtml" || pathname === "/buddy/process_buddy.phtml") {
    return sendText(res, 200, buddyXml(url), "application/xml; charset=utf-8");
  }

  if (PROCESS_ENDPOINTS.has(pathname)) {
    return sendText(res, 200, renderProcessStub(pathname, url));
  }

  return false;
}

function safeLocalRedirect(value) {
  if (!value) return "/";
  try {
    if (/^https?:\/\//i.test(value)) {
      const parsed = new URL(value);
      if (!isRecognizedOfficialHost(parsed.hostname)) return "/";
      return `${parsed.pathname}${parsed.search}`;
    }
  } catch {
    return "/";
  }
  return value.startsWith("/") ? value : `/${value}`;
}

function neighborhoodToMapLocation(neighborhood = "") {
  const normalized = String(neighborhood || "").trim().toLowerCase();
  const aliases = new Map([
    ["golden valley", "goldenvalley"],
    ["metro park", "metropark"],
    ["lakeview", "lakeview"],
    ["ravenwood", "ravenwood"],
    ["westridge", "westridge"],
    ["downtown", "downtown"]
  ]);
  return aliases.get(normalized) || "downtown";
}

function classifiedsSwfCompatibilityRedirect(url) {
  const neighborhood = String(url.searchParams.get("neighborhood") || "").trim();
  const q = String(url.searchParams.get("q") || "").trim();
  const back = String(url.searchParams.get("back") || "").trim();
  const classifiedsParams = new URLSearchParams();
  if (neighborhood) classifiedsParams.set("neighborhood", neighborhood);
  if (q) classifiedsParams.set("q", q);
  const classifiedsHref = `/classifieds.phtml${classifiedsParams.toString() ? `?${classifiedsParams.toString()}` : ""}`;

  // Legacy interior SWFs route neighborhood buttons through this endpoint.
  if (back === "1") {
    return `/yard_sale.phtml${neighborhood ? `?neighborhood=${encodeURIComponent(neighborhood)}` : ""}`;
  }
  if (back === "2") {
    return `/buy_ad.phtml${neighborhood ? `?neighborhood=${encodeURIComponent(neighborhood)}` : ""}`;
  }
  if (back === "3") {
    const location = neighborhoodToMapLocation(neighborhood);
    return `/main_map.phtml?location=${encodeURIComponent(location)}`;
  }
  if (back === "4") {
    return "/main_map.phtml?location=downtown";
  }
  return classifiedsHref;
}

function topNavXml() {
  return `<?xml version="1.0" encoding="UTF-8"?>
<navigation>
  <item label="Home" url="/__official-root" />
  <item label="Map" url="/main_map.phtml" />
  <item label="Games" url="/gamepages/games_list.phtml" />
  <item label="Hi Scores" url="/gamepages/hiscores.phtml" />
  <item label="Status" url="/__missing" />
</navigation>`;
}

function sideNavXml() {
  return `<?xml version="1.0" encoding="UTF-8"?>
<navigation>
  <item label="Map" url="/main_map.phtml" />
  <item label="Games" url="/gamepages/games_list.phtml" />
  <item label="Arcade" url="/complex/arcade.phtml" />
  <item label="Classifieds" url="/classifieds.phtml" />
  <item label="Yard Sale" url="/yard_sale.phtml" />
  <item label="Bank" url="/bank/" />
  <item label="Academy" url="/academy/" />
  <item label="Community" url="/communitycenter/" />
</navigation>`;
}

function buddyXml(url) {
  const userName = escapeXml(url.searchParams.get("userName") || url.searchParams.get("username") || "millsberry");
  return `<?xml version="1.0" encoding="UTF-8"?>
<message success="1" userName="${userName}">
  <buddy>
    <name>${userName}</name>
    <status>Recovered replay placeholder</status>
  </buddy>
</message>`;
}

function renderProcessStub(pathname, url) {
  return `<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Millsberry Process Stub</title>
  <link rel="stylesheet" href="/__app/app.css">
</head>
<body class="replay-index">
  <main class="shell">
    <section class="panel">
      <h1>Recovered Process Stub</h1>
      <p class="note">${escapeHtml(pathname)} is a dynamic Millsberry endpoint. The original server behavior is not recovered, so this replay app returns a local placeholder instead of a broken 404.</p>
      <p class="note">Query: ${escapeHtml(url.search || "(none)")}</p>
      <p><a href="/">Back to recovered routes</a></p>
    </section>
  </main>
</body>
</html>`;
}

function escapeXml(value) {
  return String(value).replace(/[<>&"']/g, (char) => ({
    "<": "&lt;",
    ">": "&gt;",
    "&": "&amp;",
    "\"": "&quot;",
    "'": "&apos;"
  }[char]));
}

function escapeHtml(value) {
  return String(value).replace(/[&<>"']/g, (char) => ({
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    "\"": "&quot;",
    "'": "&#39;"
  }[char]));
}

async function handleAccountRequest(req, url, bodyParams, user, res) {
  const pathname = canonicalPath(url.pathname);
  const hasLoginFields = bodyParams.has("login_username") || bodyParams.has("login_pass");

  if ((pathname === "/__login" || hasLoginFields) && req.method === "POST") {
    const username = bodyParams.get("login_username") || "";
    const password = bodyParams.get("login_pass") || "";
    const authenticatedUser = accounts.authenticate(username, password);
    if (!authenticatedUser) {
      return sendText(
        res,
        401,
        renderAccountPage(
          null,
          "",
          "Incorrect username or password.",
          bodyParams.get("redirect") || "/__account",
        ),
      );
    }
    const token = accounts.createSession(authenticatedUser.username);
    const requestedRedirect = bodyParams.get("redirect") || redirectWithoutParameter(url, "logout");
    return sendRedirect(res, safeLocalRedirect(requestedRedirect || "/__account"), {
      "Set-Cookie": sessionCookie(token)
    });
  }

  if (pathname === "/logout.phtml" || (url.searchParams.get("logout") === "1" && req.method === "GET")) {
    accounts.deleteSession(accounts.sessionTokenForRequest(req));
    const location = pathname === "/logout.phtml" ? "/" : redirectWithoutParameter(url, "logout");
    return sendRedirect(res, location, { "Set-Cookie": expiredSessionCookie() });
  }

  if (pathname === "/__account") {
    const redirect = safeLocalRedirect(url.searchParams.get("redirect") || "/__account");
    if (user && redirect !== "/__account") {
      return sendRedirect(res, redirect);
    }
    return sendText(res, 200, renderAccountPage(user, "", "", redirect));
  }

  if (pathname === "/signup.phtml" && req.method === "GET") {
    return sendText(res, 200, renderSignupPage(user));
  }

  if (pathname === "/process_signup.phtml" && req.method === "POST") {
    const values = Object.fromEntries(bodyParams.entries());
    const result = accounts.createUser({
      username: bodyParams.get("signup_username"),
      password: bodyParams.get("signup_password"),
      verifyPassword: bodyParams.get("signup_verify_password"),
      email: bodyParams.get("signup_email"),
      displayName: bodyParams.get("signup_first_name")
    });
    if (result.error) {
      return sendText(res, 400, renderSignupPage(null, result.error, values));
    }
    const token = accounts.createSession(result.user.username);
    return sendRedirect(res, "/__account", { "Set-Cookie": sessionCookie(token) });
  }

  if (pathname === "/home/") {
    const requestedUsername = url.searchParams.get("user") || (user && user.username);
    const viewedUser = requestedUsername
      ? (accounts.findUser(requestedUsername) || archivalCitizen(requestedUsername))
      : null;
    if (!requestedUsername && !user) {
      return sendRedirect(res, "/__account");
    }
    return sendText(res, viewedUser ? 200 : 404, renderHomePage(viewedUser, user));
  }

  if (pathname === "/inventory.phtml") {
    return sendText(res, 200, renderInventoryPage(user));
  }

  if (pathname === "/classifieds.phtml" && req.method === "GET") {
    if (url.searchParams.get("buyad") === "1") {
      return sendRedirect(res, "/buy_ad.phtml");
    }
    return sendText(res, 200, renderClassifiedsPage(user, url.searchParams));
  }

  if (pathname === "/buy_ad.phtml" && req.method === "GET") {
    if (!user) {
      const redirect = `${pathname}${url.search}`;
      return sendRedirect(res, `/__account?redirect=${encodeURIComponent(redirect)}`);
    }
    return sendText(res, 200, renderBuyAdPage(user));
  }

  if (pathname === "/process_buy_ad.phtml" && req.method === "GET") {
    return sendRedirect(res, `/buy_ad.phtml${url.search || ""}`);
  }

  if ((pathname === "/buy_ad.phtml" || pathname === "/process_buy_ad.phtml") && req.method === "POST") {
    if (!user) {
      return sendRedirect(res, `/__account?redirect=${encodeURIComponent("/buy_ad.phtml")}`);
    }
    const values = {
      title: bodyParams.get("title") || "",
      neighborhood: bodyParams.get("neighborhood") || "",
      q: bodyParams.get("q") || ""
    };
    if (!values.title.trim() || !values.neighborhood.trim() || !values.q.trim()) {
      return sendText(res, 400, renderBuyAdPage(user, "", "Please complete all ad fields.", values));
    }
    const confirmation = `Ad posted for ${values.neighborhood}: ${values.title}.`;
    return sendText(res, 200, renderClassifiedsPage(user, new URLSearchParams({ neighborhood: values.neighborhood, q: values.q }), confirmation, ""));
  }

  if (pathname === "/yard_sale.phtml" && req.method === "GET") {
    return sendText(res, 200, renderYardSalePage(user, "", "", url.searchParams.get("offset")));
  }

  if (pathname === "/yard_sale.phtml" && req.method === "POST") {
    if (!user) {
      return sendRedirect(
        res,
        `/__account?redirect=${encodeURIComponent("/yard_sale.phtml")}`,
      );
    }
    const itemId = bodyParams.get("item_id") || "";
    const item = YARD_SALE_ITEMS.find((candidate) => candidate.id === itemId);
    if (!item) {
      return sendText(res, 400, renderYardSalePage(user, "", "That yard-sale listing is no longer available.", bodyParams.get("offset")));
    }
    const result = accounts.purchase(user.username, item);
    const currentUser = result.user || accounts.findUser(user.username);
    const message = result.error ? "" : `You bought ${item.name} for ${Number(item.price).toLocaleString("en-US")} Millsbucks.`;
    return sendText(res, result.error ? 400 : 200, renderYardSalePage(currentUser, message, result.error || "", bodyParams.get("offset")));
  }

  if (pathname === "/shop.phtml" && req.method === "GET") {
    // Preserve official captured shop pages by default; rebuilt catalog is available via ?rebuilt=1.
    if (url.searchParams.get("rebuilt") !== "1") {
      const requestedShopId = normalizeShopId(url.searchParams.get("shop_id"));
      if (requestedShopId && shopPageByShop.has(requestedShopId)) {
        const page = shopPageByShop.get(requestedShopId);
        if (page && fs.existsSync(page.filePath)) {
          const html = fs.readFileSync(page.filePath, "latin1");
          const pageEntry = routeEntryFromRecoveredPage(page);
          return sendText(res, 200, rewriteHtml(html, pageEntry, user));
        }
      }

      const route = findRoute(url);
      if (route && fs.existsSync(route.filePath)) {
        const ext = path.extname(route.filePath).toLowerCase();
        if ([".html", ".phtml"].includes(ext)) {
          const html = fs.readFileSync(route.filePath, "latin1");
          return sendText(res, 200, rewriteHtml(html, route, user));
        }
        return sendFile(res, route.filePath);
      }
    }
    return sendText(res, 200, renderShopPage(user, url.searchParams));
  }

  if (pathname === "/main_map.phtml") {
    return sendText(res, 200, renderMainMapPage(user, url.searchParams.get("location")));
  }

  if (pathname === "/process_shop.phtml" && req.method === "POST") {
    if (!user) return sendRedirect(res, "/__account");
    const purchaseField = [...bodyParams.keys()].find((key) => /^buy_(\d+):/i.test(key));
    const itemId = purchaseField?.match(/^buy_(\d+):/i)?.[1];
    const item = itemId ? shopItemCatalog.get(itemId) : null;
    if (!item) {
      return sendText(res, 400, renderPurchasePage(user, { shopId: bodyParams.get("shop_id") || "" }, "The selected official shop item could not be identified."));
    }
    const result = accounts.purchase(user.username, item);
    return sendText(res, result.error ? 400 : 200, renderPurchasePage(result.user || user, item, result.error || ""));
  }

  if ((pathname === "/bank/" || pathname === "/bank") && req.method === "GET") {
    return sendText(res, 200, renderBankPage(user));
  }

  if (pathname === "/process_bank.phtml" && req.method === "POST") {
    if (!user) return sendRedirect(res, "/__account");
    const action = bodyParams.get("action") || "";
    const amount = bodyParams.get("amount") || "";
    const result = accounts.bankTransaction(user.username, action, amount);
    const currentUser = result.user || accounts.findUser(user.username);
    const message = result.error ? "" : `${action === "deposit" ? "Deposited" : "Withdrew"} ${Number(amount).toLocaleString("en-US")} Millsbucks.`;
    return sendText(res, result.error ? 400 : 200, renderBankPage(currentUser, message, result.error || ""));
  }

  if (pathname === "/process_shortcut.phtml") {
    if (!user) return sendRedirect(res, "/__account");
    const action = url.searchParams.get("action") || bodyParams.get("action") || "add";
    const shortcutUrl = url.searchParams.get("url") || bodyParams.get("url") || "";
    const name = url.searchParams.get("name") || bodyParams.get("name") || shortcutUrl;
    const result = accounts.saveShortcut(user.username, { action, url: shortcutUrl, name });
    return sendText(res, result.error ? 400 : 200, renderShortcutsPage(result.user || user, result.error ? "" : action === "remove" ? "Shortcut removed." : "Shortcut saved.", result.error || ""));
  }

  if (pathname === "/shortcuts.phtml") {
    return sendText(res, 200, renderShortcutsPage(user));
  }

  if (pathname === "/process_buddy_list.phtml" && req.method === "POST") {
    if (!user) return sendRedirect(res, "/__account");
    const action = bodyParams.get("action") || "add";
    const buddyUsername = bodyParams.get("buddy_username") || bodyParams.get("userName") || "";
    const result = accounts.updateBuddy(user.username, buddyUsername, action);
    return sendText(res, result.error ? 400 : 200, renderBuddiesPage(result.user || user, result.error ? "" : action === "remove" ? "Buddy removed." : "Buddy added.", result.error || ""));
  }

  if (pathname === "/buddies.phtml") {
    return sendText(res, 200, renderBuddiesPage(user));
  }

  if (pathname === "/load_buddy_xml.phtml" || pathname === "/buddy/load_buddy_xml.phtml") {
    return sendText(res, 200, buddyListXml(user), "application/xml; charset=utf-8");
  }

  return false;
}

async function handleRequest(req, res) {
  const url = new URL(req.url, `http://${req.headers.host || "localhost"}`);
  const bodyParams = await requestParams(req);
  const user = accounts.userForRequest(req);

  const accountResponse = await handleAccountRequest(req, url, bodyParams, user, res);
  if (accountResponse !== false) return accountResponse;

  if (url.pathname.startsWith("/__games/")) {
    let relativePath = decodeURIComponentSafe(url.pathname.slice("/__games/".length));
    if (relativePath.startsWith("flashgames/")) {
      relativePath = relativePath.slice("flashgames/".length);
    }
    const gamesRoot = path.resolve(RECOVERED_GAMES_ROOT);
    const gamePath = path.resolve(gamesRoot, relativePath);
    if (
      gamePath.startsWith(`${gamesRoot}${path.sep}`)
      && fs.existsSync(gamePath)
      && fs.statSync(gamePath).isFile()
    ) {
      return sendFile(res, gamePath);
    }
    recordMissing(req, url, "game-file-unavailable");
    return sendText(res, 200, renderGamePlaceholder(url));
  }

  if (
    url.pathname.startsWith("/gamingsystem/")
    && canonicalPath(url.pathname) !== "/gamingsystem/launch_game.phtml"
  ) {
    const relativePath = decodeURIComponentSafe(url.pathname.slice("/gamingsystem/".length));
    const gamesRoot = path.resolve(RECOVERED_GAMES_ROOT, "gamingsystem");
    const gamePath = path.resolve(gamesRoot, relativePath);
    if (
      gamePath.startsWith(`${gamesRoot}${path.sep}`)
      && fs.existsSync(gamePath)
      && fs.statSync(gamePath).isFile()
    ) {
      return sendFile(res, gamePath);
    }
  }

  if (url.pathname.startsWith("/__ruffle/")) {
    const relativePath = decodeURIComponentSafe(url.pathname.slice("/__ruffle/".length));
    const ruffleRoot = path.resolve(RUFFLE_ROOT);
    const rufflePath = path.resolve(ruffleRoot, relativePath);
    if (
      rufflePath.startsWith(`${ruffleRoot}${path.sep}`)
      && fs.existsSync(rufflePath)
      && fs.statSync(rufflePath).isFile()
    ) {
      return sendFile(res, rufflePath);
    }
    recordMissing(req, url, "ruffle-asset-unavailable");
    return sendText(res, 200, "", "application/javascript; charset=utf-8");
  }

  if (url.pathname.startsWith("/__app/")) {
    const filePath = path.join(APP_ROOT, "public", url.pathname.replace("/__app/", ""));
    if (filePath.startsWith(path.join(APP_ROOT, "public")) && fs.existsSync(filePath)) {
      return sendFile(res, filePath);
    }
    recordMissing(req, url, "app-asset-unavailable");
    if (/\.css$/i.test(url.pathname)) {
      return sendEmptyCss(req, url, res);
    }
    if (/\.js$/i.test(url.pathname)) {
      return sendText(res, 200, "", "application/javascript; charset=utf-8");
    }
    return sendText(res, 200, "", "text/plain; charset=utf-8");
  }

  if (url.pathname === "/__missing") {
    return sendText(res, 200, renderMissingReport());
  }

  if (url.pathname === "/__missing.json") {
    return sendText(res, 200, JSON.stringify(missingRows(), null, 2), "application/json; charset=utf-8");
  }

  if (canonicalPath(url.pathname) === "/site_search.phtml") {
    return sendText(res, 200, renderSiteSearchPage(url, user));
  }

  if (url.pathname === "/arcade") {
    return sendText(res, 200, renderRecoveredArcade(user));
  }

  if (url.pathname === "/swfs") {
    return sendText(res, 200, renderIndex(user, "swfs"));
  }

  if (url.pathname === "/swf-teasers") {
    return sendText(res, 200, renderIndex(user, "teasers"));
  }

  if (url.pathname === "/__swf_teasers.json") {
    return sendText(res, 200, JSON.stringify(listTeasersPage(url)), "application/json; charset=utf-8");
  }

  if (url.pathname === "/__swf_preview") {
    return sendText(res, 200, renderSwfPreview(url, user));
  }

  if (url.pathname === "/" || url.pathname === "/index.html" || url.pathname === "/index.phtml") {
    return sendText(res, 200, renderIndex(user));
  }

  if (url.pathname === "/__official-root") {
    const officialRoot = preferredOfficialRoot || routeIndex.get("/");
    if (officialRoot && fs.existsSync(officialRoot.filePath)) {
      const html = fs.readFileSync(officialRoot.filePath, "latin1");
      return sendText(res, 200, rewriteHtml(html, officialRoot, user));
    }
  }

  if (canonicalPath(url.pathname) === "/gamingsystem/launch_game.phtml") {
    const gameHtml = renderRecoveredGame(url);
    if (gameHtml) {
      return sendText(res, 200, gameHtml);
    }
    recordMissing(req, url, "game-binary-not-recovered");
    return sendText(res, 200, renderGamePlaceholder(url));
  }

  const stubbed = handleStubEndpoint(url, res);
  if (stubbed !== false) return stubbed;

  const asset = findAsset(url);
  if (asset && fs.existsSync(asset.filePath)) {
    return sendFile(res, asset.filePath);
  }

  if (/^\/items\/item_\d+(?:_v\d+)?\.swf$/i.test(canonicalPath(url.pathname))) {
    recordMissing(req, url, "item-swf-unavailable");
    return sendRedirect(res, "/site_gfx/interiors/classifieds.swf");
  }

  if (/^\/site_gfx\/interiors\/int_[a-z0-9_]+_v\d+\.swf$/i.test(canonicalPath(url.pathname))) {
    recordMissing(req, url, "interior-swf-unavailable");
    return sendRedirect(res, "/site_gfx/interiors/classifieds.swf");
  }

  const route = findRoute(url);
  if (route && fs.existsSync(route.filePath)) {
    const ext = path.extname(route.filePath).toLowerCase();
    if ([".html", ".phtml"].includes(ext)) {
      const html = fs.readFileSync(route.filePath, "latin1");
      return sendText(res, 200, rewriteHtml(html, route, user));
    }
    return sendFile(res, route.filePath);
  }

  if (PLACEHOLDER_ROUTES.has(canonicalPath(url.pathname))) {
    return sendText(res, 200, renderPlaceholderRoute(url));
  }

  if (canonicalPath(url.pathname) === "/gamepages/flashgame_ctp.phtml" && url.searchParams.has("game_id")) {
    return sendText(res, 200, renderGamePlaceholder(url));
  }

  if (canonicalPath(url.pathname) === HISCORES_CSS_PATH) {
    return sendHiscoresCssFallback(req, url, res);
  }

  const generatedNavLabel = generatedNavImageLabel(url.pathname);
  if (generatedNavLabel) {
    return sendGeneratedNavImage(req, url, res, generatedNavLabel);
  }

  if (/\.css$/i.test(url.pathname)) {
    return sendEmptyCss(req, url, res);
  }

  if (/\.(gif|png|jpe?g|ico)$/i.test(url.pathname)) {
    recordMissing(req, url, "image-fallback");
    return sendTransparentGif(res);
  }

  if (/\.swf$/i.test(url.pathname)) {
    recordMissing(req, url, "swf-fallback");
    return sendRedirect(res, "/site_gfx/interiors/classifieds.swf");
  }

  recordMissing(req, url, "not-recovered");
  return sendText(res, 200, renderPlaceholderRoute(url));
}

function generatedNavImageLabel(pathname) {
  const cleanPath = canonicalPath(pathname);
  return GENERATED_NAV_IMAGES.get(cleanPath) ||
    GENERATED_NAV_IMAGES.get(cleanPath.replace(/^\/images\/site_gfx\//, "/site_gfx/"));
}

function renderNotFound(url) {
  return `<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Not recovered</title>
  <link rel="stylesheet" href="/__app/app.css">
</head>
<body class="replay-index">
  <main class="shell">
    <section class="panel">
      <h1>Route or Asset Not Recovered</h1>
      <p class="note">${escapeHtml(url.pathname + url.search)} was referenced, but no matching recovered official file is available in the current workspace.</p>
      <p><a href="/">Back to recovered routes</a></p>
    </section>
  </main>
</body>
</html>`;
}

function discoverKnownGameIdsFromRecoveredPages() {
  for (const page of pagesByDigest.values()) {
    if (!page.pathname || !/\/(gamepages|gamingsystem)\//.test(page.pathname)) continue;
    const ext = path.extname(page.filePath).toLowerCase();
    if (!ext || ![".html", ".phtml"].includes(ext)) continue;
    try {
      const html = fs.readFileSync(page.filePath, "latin1");
      GAME_CATALOG.registerKnownIdsFromHtml(html);
    } catch {
      // Skip unreadable recovered page files and continue indexing.
    }
  }
}

function discoverPlayableGamesFromRecoveredAssets() {
  for (const asset of assetPathFallbackIndex.values()) {
    GAME_CATALOG.registerAssetBinary(asset);
  }
}

indexRecoveredPages();
indexShopCatalog();
indexManifestRoutes();
indexInferredRoutes();
indexActivePathFallbackRoutes();
indexAssets();
discoverPlayableGamesFromRecoveredAssets();
discoverKnownGameIdsFromRecoveredPages();
preferredOfficialRoot = resolvePreferredOfficialRoot();

http.createServer((req, res) => {
  handleRequest(req, res).catch((error) => {
    console.error(error);
    if (!res.headersSent) {
      sendText(res, 500, renderAppPage("Replay Server Error", "<p>The local replay server could not complete this request.</p>", null, "", error.message));
    } else {
      res.end();
    }
  });
}).listen(PORT, HOST, () => {
  console.log(`Millsberry official replay listening on http://${HOST}:${PORT}`);
  console.log(`DATA_ROOT=${DATA_ROOT}`);
  console.log(`Test login: ${TEST_USERNAME} / ${TEST_PASSWORD}`);
  console.log(`${routeIndex.size} exact routes, ${assetIndex.size} assets, ${pagesByDigest.size} page files indexed`);
  console.log(`${shopItemCatalog.size} recovered shop items indexed`);
  console.log(`${activePathFallbackIndex.size} active page fallbacks indexed`);
  if (preferredOfficialRoot) {
    console.log(`Preferred official homepage: ${preferredOfficialRoot.timestamp} ${preferredOfficialRoot.original}`);
  }
});
