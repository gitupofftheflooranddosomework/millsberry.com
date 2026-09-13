const http = require("http");

const ADSENSE_CLIENT_ID = "ca-pub-3957541427097660";
const ADSENSE_SNIPPET = `<!-- Google AdSense -->
<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=${ADSENSE_CLIENT_ID}"
     crossorigin="anonymous"></script>`;

const originalEnd = http.ServerResponse.prototype.end;

http.ServerResponse.prototype.end = function adsenseEnd(chunk, encoding, callback) {
  if (chunk != null) {
    const wasBuffer = Buffer.isBuffer(chunk);
    let body = wasBuffer ? chunk.toString() : String(chunk);
    const headMatch = body.match(/<head(?:\s[^>]*)?>/i);

    if (headMatch && headMatch.index !== undefined && !body.includes(ADSENSE_CLIENT_ID)) {
      const insertionPoint = headMatch.index + headMatch[0].length;
      body = `${body.slice(0, insertionPoint)}\n${ADSENSE_SNIPPET}${body.slice(insertionPoint)}`;
      chunk = wasBuffer ? Buffer.from(body) : body;
    }
  }

  return originalEnd.call(this, chunk, encoding, callback);
};
