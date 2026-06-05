const { URL } = require("url");

const baseUrl = process.env.REPLAY_BASE_URL || "http://localhost:3000";
const maxRoutes = Number(process.env.CRAWL_MAX_ROUTES || 80);
const seedRoutes = [
  "/",
  "/__official-root",
  "/gamepages/games_list.phtml",
  "/gamepages/hiscores.phtml?game_id=420",
  "/activities/batmanfru/batman.phtml",
  "/complex/arcade.phtml",
  "/bank/",
  "/academy/",
  "/communitycenter/",
  "/top_nav_xml.phtml",
  "/side_nav_xml.phtml"
];

const seen = new Set();
const failures = [];

function localUrl(value, currentUrl) {
  if (!value || /^(javascript:|mailto:|#|data:)/i.test(value)) return null;
  const normalized = value
    .replace(/&amp;/g, "&")
    .trim()
    .replace(/^["']+/, "")
    .replace(/["';,)]+$/g, "");
  try {
    const parsed = new URL(normalized, currentUrl);
    const base = new URL(baseUrl);
    if (parsed.origin !== base.origin) return null;
    if (parsed.pathname.includes("&") && !parsed.search) return null;
    return `${parsed.pathname}${parsed.search}`;
  } catch {
    return null;
  }
}

function extractReferences(body, currentUrl) {
  const refs = new Set();
  const patterns = [
    /\b(?:href|src|action|background|codebase)=["']([^"']+)["']/gi,
    /\b(?:href|src|action|background|codebase)=([^\s>]+)/gi,
    /\b(?:movie|value)=["']([^"']+\.(?:swf|gif|png|jpe?g|css|js|xml|phtml|html)(?:\?[^"']*)?)["']/gi,
    /url\(([^)]+)\)/gi
  ];
  for (const pattern of patterns) {
    let match;
    while ((match = pattern.exec(body))) {
      const raw = match[1].replace(/^["']|["']$/g, "");
      const href = localUrl(raw, currentUrl);
      if (href) refs.add(href);
    }
  }
  for (const encoded of body.match(/%2F[a-z0-9_./%-]+\.(?:swf|gif|png|jpe?g|css|js|xml|phtml|html)(?:%3F[a-z0-9_.%=&-]+)?/gi) || []) {
    const href = localUrl(decodeURIComponentSafe(encoded), currentUrl);
    if (href) refs.add(href);
  }
  return Array.from(refs);
}

function decodeURIComponentSafe(value) {
  try {
    return decodeURIComponent(value);
  } catch {
    return value;
  }
}

async function requestPath(pathname, referer) {
  if (seen.has(pathname)) return null;
  seen.add(pathname);
  const url = new URL(pathname, baseUrl);
  const response = await fetch(url, {
    redirect: "manual",
    headers: referer ? { referer: new URL(referer, baseUrl).toString() } : {}
  });
  const contentType = response.headers.get("content-type") || "";
  if (response.status >= 400) {
    failures.push({ status: response.status, path: pathname, referer: referer || "" });
  }
  let body = "";
  if (contentType.includes("text") || contentType.includes("html") || contentType.includes("xml") || contentType.includes("javascript") || contentType.includes("json")) {
    body = await response.text();
  } else {
    await response.arrayBuffer();
  }
  return { status: response.status, contentType, body };
}

async function discoverRoutes() {
  const response = await fetch(baseUrl);
  const body = await response.text();
  return extractReferences(body, baseUrl)
    .filter((route) => !route.startsWith("/__app/") && route !== "/__missing")
    .slice(0, maxRoutes);
}

async function main() {
  const routes = Array.from(new Set(seedRoutes.concat(await discoverRoutes()))).slice(0, maxRoutes);
  for (const route of routes) {
    const page = await requestPath(route);
    if (!page || !page.body) continue;
    const refs = extractReferences(page.body, new URL(route, baseUrl).toString());
    for (const ref of refs.slice(0, 160)) {
      await requestPath(ref, route);
    }
  }

  console.log(JSON.stringify({
    baseUrl,
    requested: seen.size,
    failures: failures.length,
    sampleFailures: failures.slice(0, 20)
  }, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
