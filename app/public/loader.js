// The site's own loading screen in place of Ruffle's.
//
// Every recovered movie loaded behind the M from `locations/loader.swf`: the
// oval on the interior blue, a bar filling underneath as the bytes came in.
// Ruffle draws its own splash (logo, spinner, orange bar) in each player's
// shadow root while a SWF downloads. This restyles that splash rather than
// replacing it, so the bar still reports the real download — the original was
// counting real bytes too, and a bar that runs on a timer reads as fake.
//
// The shadow root is open, so a stylesheet dropped into it reaches the splash.
// Players appear in three ways — Ruffle's polyfill swapping an <object> for a
// <ruffle-object>, its <embed> counterpart, and <ruffle-player> elements a
// page creates itself — and all three land in the DOM after this script runs,
// so the observer is the part that does the work.
(function () {
  var PLAYER_TAGS = "ruffle-object, ruffle-embed, ruffle-player";
  var CSS = [
    "#splash-screen { background: #2f6bf0; }",
    // The M at its own 201x148 on a plate, scaled down on a thumbnail. On its
    // own layer so it can fade up over the blue rather than appear with it.
    "#splash-screen::before {",
    "  content: ''; position: absolute; inset: 0;",
    "  background: url('/__app/nav/loading_m.png') center 42% / min(201px, 55%) no-repeat;",
    "  animation: mb-fade-in 0.5s ease-out both;",
    "}",
    "@keyframes mb-fade-in { from { opacity: 0; } to { opacity: 1; } }",
    "#splash-screen .logo, #splash-screen .loading-animation { display: none; }",
    // Hung beneath the M, where the original had it: a thin trough, filled
    // in the nav's yellow.
    "#splash-screen .loadbar {",
    "  position: absolute; left: 50%; top: 72%; transform: translateX(-50%);",
    "  width: 55%; max-width: 240px; height: 8px; max-height: 8px;",
    "  background: rgba(0, 0, 0, 0.18); overflow: visible;",
    "  animation: mb-fade-in 0.5s ease-out both;",
    "}",
    "#splash-screen .loadbar-inner { background: #fffa35; }",
    // The count, riding the end of the fill.
    "#splash-screen .loadpct {",
    "  position: absolute; bottom: 100%; left: 0; margin-bottom: 3px;",
    "  transform: translateX(-100%);",
    "  color: #fffa35; font: 13px 'Fontdinerdotcom Huggable', 'Trebuchet MS', sans-serif;",
    "  white-space: nowrap;",
    "}"
  ].join("\n");

  function dress(player) {
    var root = player.shadowRoot;
    if (!root || root.querySelector("style[data-millsberry-loader]")) return;
    var style = document.createElement("style");
    style.setAttribute("data-millsberry-loader", "");
    style.textContent = CSS;
    root.appendChild(style);
    followProgress(root);
  }

  // Ruffle reports progress by writing the fill's width inline as a
  // percentage; the label reads it back from there and sits at that point.
  function followProgress(root) {
    var bar = root.querySelector("#splash-screen .loadbar");
    var inner = bar && bar.querySelector(".loadbar-inner");
    if (!inner) return;
    var label = document.createElement("span");
    label.className = "loadpct";
    bar.appendChild(label);
    var update = function () {
      var pct = parseFloat(inner.style.width);
      if (isNaN(pct)) pct = 0;
      pct = Math.max(0, Math.min(100, pct));
      label.textContent = Math.round(pct) + "%";
      label.style.left = pct + "%";
      // Right-aligned to the fill's end once there is room for it; before
      // that it starts at the bar's left edge rather than hanging outside.
      var filled = (pct / 100) * bar.clientWidth;
      label.style.transform = filled >= label.offsetWidth ? "translateX(-100%)" : "none";
    };
    update();
    new MutationObserver(update).observe(inner, { attributes: true, attributeFilter: ["style"] });
  }

  function sweep(node) {
    if (!(node instanceof Element)) return;
    if (node.matches(PLAYER_TAGS)) dress(node);
    node.querySelectorAll(PLAYER_TAGS).forEach(dress);
  }

  new MutationObserver(function (records) {
    records.forEach(function (record) {
      record.addedNodes.forEach(sweep);
    });
  }).observe(document.documentElement, { childList: true, subtree: true });

  sweep(document.documentElement);
})();
