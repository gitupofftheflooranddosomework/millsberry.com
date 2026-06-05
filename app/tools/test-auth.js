const assert = require("assert");

const baseUrl = process.env.REPLAY_BASE_URL || "http://localhost:3000";
const username = process.env.TEST_USERNAME || "testcitizen";
const password = process.env.TEST_PASSWORD || "millsberry";

async function request(pathname, options = {}) {
  return fetch(new URL(pathname, baseUrl), {
    redirect: "manual",
    ...options
  });
}

async function main() {
  const loginBody = new URLSearchParams({
    login_username: username,
    login_pass: password,
    redirect: "/__account"
  });
  const login = await request("/__login", {
    method: "POST",
    headers: { "content-type": "application/x-www-form-urlencoded" },
    body: loginBody
  });
  assert.equal(login.status, 302, "login should redirect");
  assert.equal(login.headers.get("location"), "/__account");
  const cookie = (login.headers.get("set-cookie") || "").split(";")[0];
  assert(cookie.startsWith("millsberry_session="), "login should set a session cookie");

  const account = await request("/__account", { headers: { cookie } });
  assert.equal(account.status, 200);
  const accountHtml = await account.text();
  assert(accountHtml.includes(username), "account page should show the username");
  assert(accountHtml.includes("Millsbucks"), "test account should show its Millsbucks balance");

  const recovered = await request("/gamepages/hiscores.phtml?game_id=420", { headers: { cookie } });
  assert.equal(recovered.status, 200);
  const recoveredHtml = await recovered.text();
  assert(recoveredHtml.includes("replay-account-summary"), "recovered page should show authenticated account state");
  assert(recoveredHtml.includes("/logout.phtml"), "recovered page should expose logout");

  const home = await request(`/home/?user=${encodeURIComponent(username)}`, { headers: { cookie } });
  assert.equal(home.status, 200);
  assert((await home.text()).includes("Test Citizen"), "test citizen home should render");

  const inventory = await request("/inventory.phtml", { headers: { cookie } });
  assert.equal(inventory.status, 200);

  const logout = await request("/logout.phtml", { headers: { cookie } });
  assert.equal(logout.status, 302);
  assert((logout.headers.get("set-cookie") || "").includes("Max-Age=0"), "logout should expire the session cookie");

  const invalid = await request("/__login", {
    method: "POST",
    headers: { "content-type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({ login_username: username, login_pass: "wrong-password" })
  });
  assert.equal(invalid.status, 401);

  const signup = await request("/signup.phtml");
  assert.equal(signup.status, 200);
  assert((await signup.text()).includes("signup_username"), "signup page should expose original field names");

  console.log(JSON.stringify({
    baseUrl,
    username,
    checks: 8,
    status: "passed"
  }, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
