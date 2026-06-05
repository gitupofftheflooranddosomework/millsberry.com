const assert = require("assert");
const fs = require("fs");
const os = require("os");
const path = require("path");
const { AccountStore } = require("../auth");

const directory = fs.mkdtempSync(path.join(os.tmpdir(), "millsberry-economy-"));
const storePath = path.join(directory, "accounts.json");

try {
  const store = new AccountStore(storePath);
  const created = store.createUser({
    username: "economy_test",
    password: "testpass",
    verifyPassword: "testpass",
    displayName: "Economy Test"
  });
  assert(created.user, created.error);
  assert.equal(created.user.millsBucks, 1000);
  assert.equal(created.user.bankBalance, 0);

  const item = {
    id: "1765",
    name: "Soccer Ball",
    description: "A good swift kick and... GOAL!",
    price: 80,
    assetPath: "/items/item_1765.swf",
    shopId: "7"
  };
  const firstPurchase = store.purchase(created.user.username, item);
  assert.equal(firstPurchase.user.millsBucks, 920);
  assert.equal(firstPurchase.user.inventory.length, 1);
  assert.equal(firstPurchase.user.inventory[0].quantity, 1);

  const secondPurchase = store.purchase(created.user.username, item);
  assert.equal(secondPurchase.user.millsBucks, 840);
  assert.equal(secondPurchase.user.inventory[0].quantity, 2);

  const deposit = store.bankTransaction(created.user.username, "deposit", 300);
  assert.equal(deposit.user.millsBucks, 540);
  assert.equal(deposit.user.bankBalance, 300);

  const withdrawal = store.bankTransaction(created.user.username, "withdraw", 125);
  assert.equal(withdrawal.user.millsBucks, 665);
  assert.equal(withdrawal.user.bankBalance, 175);

  assert(store.purchase(created.user.username, { ...item, price: 5000 }).error);
  assert(store.bankTransaction(created.user.username, "withdraw", 5000).error);

  const shortcut = store.saveShortcut(created.user.username, {
    action: "add",
    url: "/gamepages/hiscores.phtml?game_id=420",
    name: "Hi Scores"
  });
  assert.equal(shortcut.user.shortcuts.length, 1);
  assert.equal(shortcut.user.shortcuts[0].name, "Hi Scores");

  const buddy = store.updateBuddy(created.user.username, "archived_friend", "add");
  assert.equal(buddy.user.buddies.length, 1);
  assert.equal(buddy.user.buddies[0], "archived_friend");
  assert(store.updateBuddy(created.user.username, created.user.username, "add").error);

  console.log(JSON.stringify({ checks: 19, status: "passed" }, null, 2));
} finally {
  fs.rmSync(directory, { recursive: true, force: true });
}
