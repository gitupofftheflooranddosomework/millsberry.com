const crypto = require("crypto");
const fs = require("fs");
const path = require("path");

const SESSION_COOKIE = "millsberry_session";
const SESSION_LIFETIME_MS = 30 * 24 * 60 * 60 * 1000;

function cloneValue(value) {
  if (typeof globalThis.structuredClone === "function") {
    return globalThis.structuredClone(value);
  }
  return JSON.parse(JSON.stringify(value));
}

class AccountStore {
  constructor(filePath) {
    this.filePath = filePath;
    this.state = this.load();
    this.removeExpiredSessions();
  }

  load() {
    try {
      const parsed = JSON.parse(fs.readFileSync(this.filePath, "utf8"));
      return {
        users: parsed.users || {},
        sessions: parsed.sessions || {}
      };
    } catch {
      return { users: {}, sessions: {} };
    }
  }

  save() {
    fs.mkdirSync(path.dirname(this.filePath), { recursive: true });
    const temporaryPath = `${this.filePath}.tmp`;
    fs.writeFileSync(temporaryPath, `${JSON.stringify(this.state, null, 2)}\n`, "utf8");
    fs.renameSync(temporaryPath, this.filePath);
  }

  seedTestAccount(username, password) {
    const key = normalizeUsername(username);
    const existingUser = this.state.users[key];
    if (existingUser) {
      if (existingUser.isTestAccount && !verifyPassword(password, existingUser.passwordHash)) {
        existingUser.passwordHash = hashPassword(password);
        this.save();
      }
      return this.publicUser(existingUser);
    }
    const user = this.createUserRecord({
      username,
      password,
      email: "testcitizen@localhost.invalid",
      displayName: "Test Citizen",
      millsBucks: 5000,
      isTestAccount: true
    });
    this.state.users[key] = user;
    this.save();
    return this.publicUser(user);
  }

  createUser(input) {
    const username = String(input.username || "").trim();
    const password = String(input.password || "");
    const verifyPassword = String(input.verifyPassword || "");
    const validationError = validateSignup(username, password, verifyPassword);
    if (validationError) return { error: validationError };

    const key = normalizeUsername(username);
    if (this.state.users[key]) return { error: "That username is already registered." };

    const user = this.createUserRecord({
      username,
      password,
      email: String(input.email || "").trim(),
      displayName: String(input.displayName || username).trim() || username,
      millsBucks: 1000,
      isTestAccount: false
    });
    this.state.users[key] = user;
    this.save();
    return { user: this.publicUser(user) };
  }

  createUserRecord(input) {
    const passwordHash = hashPassword(input.password);
    return {
      id: crypto.randomUUID(),
      username: input.username,
      usernameKey: normalizeUsername(input.username),
      displayName: input.displayName,
      email: input.email,
      passwordHash,
      millsBucks: input.millsBucks,
      bankBalance: 0,
      inventory: [],
      buddies: [],
      shortcuts: [],
      home: {
        address: `${Math.floor(10000 + Math.random() * 80000)} Berry Lane`,
        neighborhood: "Golden Valley"
      },
      createdAt: new Date().toISOString(),
      isTestAccount: input.isTestAccount
    };
  }

  authenticate(username, password) {
    const user = this.state.users[normalizeUsername(username)];
    if (!user || !verifyPassword(password, user.passwordHash)) return null;
    return this.publicUser(user);
  }

  createSession(username) {
    const user = this.state.users[normalizeUsername(username)];
    if (!user) return null;
    const token = crypto.randomBytes(32).toString("base64url");
    this.state.sessions[token] = {
      usernameKey: user.usernameKey,
      createdAt: new Date().toISOString(),
      expiresAt: new Date(Date.now() + SESSION_LIFETIME_MS).toISOString()
    };
    this.save();
    return token;
  }

  deleteSession(token) {
    if (!token || !this.state.sessions[token]) return;
    delete this.state.sessions[token];
    this.save();
  }

  userForRequest(req) {
    const token = parseCookies(req.headers.cookie || "")[SESSION_COOKIE];
    if (!token) return null;
    const session = this.state.sessions[token];
    if (!session) return null;
    if (Date.parse(session.expiresAt) <= Date.now()) {
      this.deleteSession(token);
      return null;
    }
    const user = this.state.users[session.usernameKey];
    return user ? this.publicUser(user) : null;
  }

  sessionTokenForRequest(req) {
    return parseCookies(req.headers.cookie || "")[SESSION_COOKIE] || "";
  }

  findUser(username) {
    const user = this.state.users[normalizeUsername(username)];
    return user ? this.publicUser(user) : null;
  }

  purchase(username, item) {
    const user = this.state.users[normalizeUsername(username)];
    const price = Number(item && item.price);
    if (!user) return { error: "Account not found." };
    if (!item || !item.id || !Number.isInteger(price) || price < 0) {
      return { error: "This recovered shop item is not valid." };
    }
    if (Number(user.millsBucks || 0) < price) {
      return { error: `You need ${price.toLocaleString("en-US")} Millsbucks to buy this item.` };
    }

    user.millsBucks = Number(user.millsBucks || 0) - price;
    user.inventory = Array.isArray(user.inventory) ? user.inventory : [];
    const existing = user.inventory.find((ownedItem) => String(ownedItem.id) === String(item.id));
    if (existing) {
      existing.quantity = Number(existing.quantity || 1) + 1;
      existing.lastPurchasedAt = new Date().toISOString();
    } else {
      user.inventory.push({
        id: String(item.id),
        name: String(item.name || `Item ${item.id}`),
        description: String(item.description || ""),
        pricePaid: price,
        quantity: 1,
        assetPath: String(item.assetPath || `/items/item_${item.id}.swf`),
        shopId: String(item.shopId || ""),
        purchasedAt: new Date().toISOString()
      });
    }
    this.save();
    return { user: this.publicUser(user), item: cloneValue(item) };
  }

  bankTransaction(username, action, amountValue) {
    const user = this.state.users[normalizeUsername(username)];
    const amount = Number(amountValue);
    if (!user) return { error: "Account not found." };
    if (!Number.isInteger(amount) || amount <= 0) {
      return { error: "Enter a whole-number amount greater than zero." };
    }

    user.millsBucks = Number(user.millsBucks || 0);
    user.bankBalance = Number(user.bankBalance || 0);
    if (action === "deposit") {
      if (user.millsBucks < amount) return { error: "You do not have enough Millsbucks in your wallet." };
      user.millsBucks -= amount;
      user.bankBalance += amount;
    } else if (action === "withdraw") {
      if (user.bankBalance < amount) return { error: "You do not have enough Millsbucks in the bank." };
      user.bankBalance -= amount;
      user.millsBucks += amount;
    } else {
      return { error: "Unknown bank transaction." };
    }

    this.save();
    return { user: this.publicUser(user) };
  }

  saveShortcut(username, input) {
    const user = this.state.users[normalizeUsername(username)];
    if (!user) return { error: "Account not found." };
    user.shortcuts = Array.isArray(user.shortcuts) ? user.shortcuts : [];
    const url = safeShortcutUrl(input.url);
    if (!url) return { error: "That shortcut URL is not valid." };
    const name = String(input.name || url).trim().slice(0, 80) || url;
    const existing = user.shortcuts.find((shortcut) => shortcut.url === url);
    if (input.action === "remove") {
      user.shortcuts = user.shortcuts.filter((shortcut) => shortcut.url !== url);
    } else if (existing) {
      existing.name = name;
    } else {
      user.shortcuts.push({ name, url, createdAt: new Date().toISOString() });
    }
    this.save();
    return { user: this.publicUser(user) };
  }

  updateBuddy(username, buddyUsername, action = "add") {
    const user = this.state.users[normalizeUsername(username)];
    const buddy = String(buddyUsername || "").trim();
    if (!user) return { error: "Account not found." };
    if (!/^[A-Za-z0-9_]{1,40}$/.test(buddy)) return { error: "Enter a valid Millsberry username." };
    if (normalizeUsername(buddy) === user.usernameKey) return { error: "You cannot add yourself as a buddy." };
    user.buddies = Array.isArray(user.buddies) ? user.buddies : [];
    if (action === "remove") {
      user.buddies = user.buddies.filter((name) => normalizeUsername(name) !== normalizeUsername(buddy));
    } else if (!user.buddies.some((name) => normalizeUsername(name) === normalizeUsername(buddy))) {
      user.buddies.push(buddy);
    }
    this.save();
    return { user: this.publicUser(user) };
  }

  publicUser(user) {
    if (!user) return null;
    const { passwordHash, email, usernameKey, ...publicFields } = user;
    publicFields.millsBucks = Number(publicFields.millsBucks || 0);
    publicFields.bankBalance = Number(publicFields.bankBalance || 0);
    publicFields.inventory = Array.isArray(publicFields.inventory) ? publicFields.inventory : [];
    publicFields.buddies = Array.isArray(publicFields.buddies) ? publicFields.buddies : [];
    publicFields.shortcuts = Array.isArray(publicFields.shortcuts) ? publicFields.shortcuts : [];
    return cloneValue(publicFields);
  }

  removeExpiredSessions() {
    let changed = false;
    for (const [token, session] of Object.entries(this.state.sessions)) {
      if (Date.parse(session.expiresAt) <= Date.now()) {
        delete this.state.sessions[token];
        changed = true;
      }
    }
    if (changed) this.save();
  }
}

function normalizeUsername(username) {
  return String(username || "").trim().toLowerCase();
}

function validateSignup(username, password, verifyPassword) {
  if (!/^[A-Za-z0-9_]{5,20}$/.test(username)) {
    return "Username must be 5-20 letters, numbers, or underscores.";
  }
  if (!/^[A-Za-z0-9_]{6,64}$/.test(password)) {
    return "Password must be 6-64 letters, numbers, or underscores.";
  }
  if (password !== verifyPassword) return "The passwords do not match.";
  return "";
}

function hashPassword(password) {
  const salt = crypto.randomBytes(16);
  const derived = crypto.scryptSync(String(password), salt, 64);
  return `scrypt$${salt.toString("hex")}$${derived.toString("hex")}`;
}

function verifyPassword(password, encodedHash) {
  const [algorithm, saltHex, hashHex] = String(encodedHash || "").split("$");
  if (algorithm !== "scrypt" || !saltHex || !hashHex) return false;
  const expected = Buffer.from(hashHex, "hex");
  const actual = crypto.scryptSync(String(password), Buffer.from(saltHex, "hex"), expected.length);
  return expected.length === actual.length && crypto.timingSafeEqual(expected, actual);
}

function parseCookies(header) {
  const cookies = {};
  for (const part of String(header).split(";")) {
    const separator = part.indexOf("=");
    if (separator < 0) continue;
    const key = part.slice(0, separator).trim();
    const value = part.slice(separator + 1).trim();
    if (key) cookies[key] = decodeURIComponentSafe(value);
  }
  return cookies;
}

function decodeURIComponentSafe(value) {
  try {
    return decodeURIComponent(value);
  } catch {
    return value;
  }
}

function safeShortcutUrl(value) {
  const url = String(value || "").trim();
  if (!url.startsWith("/") || url.startsWith("//")) return "";
  return url.slice(0, 500);
}

function sessionCookie(token) {
  return `${SESSION_COOKIE}=${encodeURIComponent(token)}; Path=/; HttpOnly; SameSite=Lax; Max-Age=${Math.floor(SESSION_LIFETIME_MS / 1000)}`;
}

function expiredSessionCookie() {
  return `${SESSION_COOKIE}=; Path=/; HttpOnly; SameSite=Lax; Max-Age=0`;
}

module.exports = {
  AccountStore,
  expiredSessionCookie,
  sessionCookie
};
