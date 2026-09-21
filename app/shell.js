// The 2010 Millsberry page frame.
//
// Wraps every page but the launcher — the reconstructed ones (account,
// inventory, bank, the map, the arcade) through renderAppPage, and recovered
// captures through reframeCapture, which lifts a capture's content out of
// whichever era's chrome it was saved with — in the frame the site had at
// closure: the 775px shell from the 2006 template.css, the top-bar pills, and
// the left column with the Buddy's name plate, the five stat meters and the
// "my" destinations. Geometry and colours are read off the recovered
// navigation movies; see public/nav/SOURCES.md for which sprite is which.

const TOP_NAV = [
  // The badge marks are stand-ins: the movies loaded each icon at runtime
  // from an XML feed, so the real ones were never in any SWF.
  { href: "/main_map.phtml", label: "The City", badge: "⌂" },
  { href: "/main_map.phtml?location=downtown", label: "Downtown", badge: "▦" },
  // The reconstructed arcade, not the archived /complex/arcade.phtml: that
  // capture was taken logged out, so its game list is empty.
  { href: "/arcade", label: "Arcade", badge: "★" }
];

// The side column's own buttons, in the order the 2010 screenshot shows them.
// A destination with no reconstructed page renders as the same button, inert,
// so the shape of the nav is preserved rather than quietly shortened.
const SIDE_NAV = [
  { href: "/buddies.phtml", label: "My Buddies" },
  { href: "/inventory.phtml", label: "My Stuff" },
  { href: (user) => `/home/?user=${encodeURIComponent(user.username)}`, label: "My Place" },
  { href: "/shortcuts.phtml", label: "My Links" }
];

// Hot Spots, verbatim from the same screenshot. Art Class is inert: its route
// (/museum/paint/) only reaches a map fallback in the current replay.
const HOT_SPOTS = [
  { href: null, label: "Art Class" },
  { href: "/studio.phtml", label: "Studio T" },
  { href: "/communitycenter/dojo/", label: "The Dojo" }
];

// "If you point your mouse cursor over each bar, you'll see the name and
// quantity of each statistic." The title attribute is the original affordance.
const METERS = [
  { key: "fitness", label: "Fitness", icon: "stat_fit_v1.png" },
  { key: "civics", label: "Civics", icon: "stat_civ_v1.png" },
  { key: "health", label: "Health", icon: "stat_hea_v1.png" },
  { key: "intelligence", label: "Intelligence", icon: "stat_int_v1.png" },
  { key: "hunger", label: "Hunger", icon: "stat_hun_v1.png" }
];

// Everything the frame paints with, fetched from the first line of <head> so
// it is in hand by first paint. Without this the sprites, icons, logo and
// faces each arrived on their own schedule after the stylesheet, and the
// frame assembled itself piecemeal on every navigation. All small: the
// thirteen images are 33 KB together, the two faces 23 KB.
const PRELOADS = [
  ["font", "/__app/nav/fonts/huggable.woff2"],
  ["font", "/__app/nav/fonts/cheeseburger.woff2"],
  ["image", "/site_gfx/layout/title_logo.png"],
  ["image", "/__app/nav/top_button.png"],
  ["image", "/__app/nav/side_button.png"],
  ["image", "/__app/nav/side_bar.png"],
  // The hover twins too, or the first roll-over waits on a fetch instead of
  // tweening.
  ["image", "/__app/nav/top_button_hover.png"],
  ["image", "/__app/nav/side_button_hover.png"],
  ["image", "/__app/nav/side_bar_hover.png"],
  ["image", "/__app/nav/name_plate.png"],
  ["image", "/__app/nav/section_plate.png"],
  ["image", "/__app/nav/buy_icon.png"],
  ...["fit", "civ", "hea", "int", "hun"].map((stat) => ["image", `/__app/nav/stat_${stat}_v1.png`])
].map(([as, href]) =>
  // Fonts are fetched in CORS mode even from the same origin, and a preload
  // that does not match the fetch mode is discarded and fetched twice.
  `  <link rel="preload" as="${as}" href="${href}"${as === "font" ? ` type="font/woff2" crossorigin` : ""}>`
).join("\n");

function escapeHtml(value) {
  return String(value).replace(/[&<>"']/g, (char) => ({
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    "\"": "&quot;",
    "'": "&#39;"
  }[char]));
}

function navButton(href, label, className) {
  if (!href) {
    return `<span class="mb_button ${className} nav_button_off" title="Not reconstructed yet">${escapeHtml(label)}</span>`;
  }
  return `<a class="mb_button ${className}" href="${escapeHtml(href)}">${escapeHtml(label)}</a>`;
}

// Account records carry no stats yet. Until that system is reconstructed the
// trough is drawn empty and says so, rather than showing an invented level.
function statusMeters(user) {
  const stats = user && user.stats && typeof user.stats === "object" ? user.stats : null;
  const rows = METERS.map((meter) => {
    const raw = stats ? Number(stats[meter.key]) : NaN;
    const value = Number.isFinite(raw) ? Math.max(0, Math.min(100, Math.round(raw))) : null;
    const title = value === null ? `${meter.label}: not reconstructed yet` : `${meter.label}: ${value}`;
    const fill = value === null ? "" : `<span style="width:${value}%"></span>`;
    return `<div class="status_row" title="${escapeHtml(title)}">` +
      `<div class="status_icon"><img src="/__app/nav/${meter.icon}" alt="${escapeHtml(meter.label)}" width="25" height="20"></div>` +
      `<div class="status_info"><div class="meter">${fill}</div></div>` +
      "</div>";
  });
  return `<div id="status">${rows.join("")}</div>`;
}

function sideNav(user) {
  if (!user) {
    return `<div id="side_nav_links"><a href="/signup.phtml">Become a citizen!</a></div>`;
  }
  const millsBucks = Number(user.millsBucks || 0).toLocaleString("en-US");
  return [
    navButton("/logout.phtml", "Sign Out", "nav_button nav_button_lead"),
    `<div class="nav_body">`,
    `<div class="name_plate"><span>${escapeHtml(user.displayName || user.username)}</span></div>`,
    // The Buddy's frame, empty: no buddy artwork is reconstructed, so the box
    // holds the space the 82px figure took rather than a stand-in.
    `<div class="nav_portrait" aria-hidden="true"></div>`,
    navButton("/buddy_change.phtml", "Customize Buddy", "nav_button"),
    `<div class="nav_title">Buddy Stats</div>`,
    statusMeters(user),
    `<div class="nav_tally" title="Millsbucks"><span class="nav_tally_icon"><img src="/__app/nav/buy_icon.png" alt="" width="22" height="22"></span><span class="nav_tally_value">${millsBucks}</span></div>`,
    ...SIDE_NAV.map((item) => navButton(typeof item.href === "function" ? item.href(user) : item.href, item.label, "nav_button")),
    `<div class="nav_head"><span>Find a Buddy</span></div>`,
    `<form class="nav_find" method="get" action="/home/"><input type="text" name="user" aria-label="Find a buddy" maxlength="40"><button type="submit" class="nav_go">Go &gt;&gt;</button></form>`,
    `<div class="nav_head"><span>Hot Spots</span></div>`,
    ...HOT_SPOTS.map((item) => navButton(item.href, item.label, "nav_button")),
    "</div>"
  ].join("\n");
}

// Signed in, this line is the account summary that rewriteAccountState used
// to put where a capture's login form was, so it keeps that class.
function loginInfo(user) {
  if (user) {
    return `<span class="replay-account-summary">Welcome, <strong>${escapeHtml(user.username)}</strong> &middot; <a href="/__account">My Account</a> &middot; <a href="/logout.phtml">Log Out</a></span>`;
  }
  return `<a href="/__account">Sign In</a> &middot; <a href="/signup.phtml">Sign Up</a>`;
}

function topNav() {
  return TOP_NAV.map((item) =>
    `<a class="mb_button top_pill" href="${escapeHtml(item.href)}" style="--mb-badge:'${item.badge}'">${escapeHtml(item.label)}</a>`
  ).join("\n");
}

// title     the italic stripe over the content pane, and the document title
// content   HTML for the 600px pane
// main      alternatively, the whole #main column verbatim — a recovered
//           capture's own #interior plate, stripe and #content
// user      the signed-in account, or null
// head      extra <head> markup: the Ruffle snippet, or a capture's own
//           stylesheets and scripts. Placed *before* the shell's stylesheet so
//           a capture's template.css cannot restyle the frame.
// appCss    whether to load app.css. Off for captures, whose content was
//           styled by their own stylesheets and should stay that way. Also
//           marks <body> `mb_app`, which scopes shell.css's pane overrides.
// bodyAttrs attributes carried over from a capture's <body> (an onload)
// after     markup appended at the end of <body> (the replay toolbar)
// footer    extra footer markup (the project's release line)
function renderShell({
  title,
  content = "",
  main = "",
  user = null,
  message = "",
  error = "",
  head = "",
  appCss = true,
  bodyAttrs = "",
  after = "",
  footer = ""
}) {
  const pane = main || `
        <div id="interior_stripe">${escapeHtml(title)}</div>
        <div id="content">
          ${message ? `<p class="message">${escapeHtml(message)}</p>` : ""}
          ${error ? `<p class="error-message">${escapeHtml(error)}</p>` : ""}
          ${content}
        </div>`;
  return `<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${escapeHtml(title)}</title>
${PRELOADS}
  ${head}
  ${appCss ? `<link rel="stylesheet" href="/__app/app.css">` : ""}
  <link rel="stylesheet" href="/__app/shell.css">
</head>
<body class="mb_site${appCss ? " mb_app" : ""}"${bodyAttrs ? ` ${bodyAttrs}` : ""}>
  <div id="top">
    <div id="logo"><a href="/__official-root" aria-label="Millsberry home"><img src="/site_gfx/layout/title_logo.png" alt="Millsberry.com" width="192"></a></div>
    <div id="layout_head">
      <div id="login_info">${loginInfo(user)}</div>
      <div id="stripe">
${topNav()}
      </div>
    </div>
  </div>
  <div id="body">
    <div id="layout_body">
      <div id="side_nav">
${sideNav(user)}
      </div>
      <div id="main">${pane}
      </div>
      <div id="footer">
        MILLSBERRY&reg;, characters, logos, product names and all related indicia are trademarks of Mills Online, Inc.<br>
        <a href="/town_hall/terms.phtml">Terms and Conditions</a> &middot; <a href="/town_hall/policy.phtml">Privacy Policy</a> &middot; <a href="/town_hall/faq.phtml">FAQ</a>
        ${footer}
      </div>
    </div>
  </div>
  <div id="bottom"></div>
  ${after}
</body>
</html>`;
}

module.exports = {
  HOT_SPOTS,
  SIDE_NAV,
  TOP_NAV,
  renderShell
};
