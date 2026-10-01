// Fetch the platform's revocations.json, verify it, and write it over the
// committed one only if its seq is higher. No secrets: the key below is the
// PUBLIC half of the platform's revocation-signing key.
//
//   REVOCATIONS_URL=https://HOST/revocations.json \
//   REVOCATION_PUBLIC_KEY_B64=<base64 raw 32-byte Ed25519 public key> \
//   node .github/scripts/sync-revocations.mjs
//
// Optional: REVOCATIONS_FILE (default revocations.json).
// Writes `changed=true|false` and `seq=N` to $GITHUB_OUTPUT.
// Exit 0: nothing to do or file updated. Exit 1: bad response / bad signature.
//
// Written by plugin/build/make_marketplace.sh from plugin/build/market/.
// Mirrors companion/license.py's verify_revocations exactly.
import { appendFileSync, existsSync, readFileSync, writeFileSync } from "node:fs";
import { createPublicKey, verify } from "node:crypto";

const MAX_BYTES = 1 << 20;
const URL_ = (process.env.REVOCATIONS_URL || "").trim();
const KEY_B64 = (process.env.REVOCATION_PUBLIC_KEY_B64 || "").trim();
const FILE = process.env.REVOCATIONS_FILE || "revocations.json";
// Tests only: allow a plain-http server on 127.0.0.1.
const ALLOW_LOCAL_HTTP = process.env.SYNC_TEST_ALLOW_LOCAL_HTTP === "1";

function output(k, v) {
  if (process.env.GITHUB_OUTPUT) appendFileSync(process.env.GITHUB_OUTPUT, `${k}=${v}\n`);
}

function fail(msg) {
  console.log(`::error::${msg}`);
  output("changed", "false");
  process.exit(1);
}

function strictB64(s) {
  if (typeof s !== "string" || s.length % 4 !== 0 || !/^[A-Za-z0-9+/]*={0,2}$/.test(s)) {
    throw new Error("format");
  }
  return Buffer.from(s, "base64");
}

function payloadOf(doc) {
  const body = strictB64(doc.payload);
  const data = JSON.parse(body.toString("utf8"));
  if (data === null || typeof data !== "object" || Array.isArray(data)) throw new Error("format");
  return { body, data };
}

function verifyDoc(doc, pub) {
  if (doc === null || typeof doc !== "object") throw new Error("format");
  const body = strictB64(doc.payload);
  const sig = strictB64(doc.sig);
  if (!verify(null, body, pub, sig)) throw new Error("signature");
  const { data } = payloadOf(doc);
  if (data.v !== 1 || !Number.isInteger(data.seq) || !Array.isArray(data.revoked)
      || !data.revoked.every((k) => typeof k === "string")) {
    throw new Error("format");
  }
  return data;
}

function committedSeq() {
  // Signature NOT checked: after a key rotation the old list no longer
  // verifies, but its seq still has to be exceeded.
  if (!existsSync(FILE)) return -1;
  try {
    const seq = payloadOf(JSON.parse(readFileSync(FILE, "utf8"))).data.seq;
    return Number.isInteger(seq) ? seq : -1;
  } catch {
    return -1;
  }
}

const configured = URL_ && KEY_B64 && !/PLACEHOLDER/i.test(URL_ + KEY_B64)
  && (URL_.startsWith("https://") || (ALLOW_LOCAL_HTTP && URL_.startsWith("http://127.0.0.1:")));
if (!configured) {
  console.log("platform URL or revocation key not configured in this release; nothing to sync");
  output("changed", "false");
  process.exit(0);
}

const raw = Buffer.from(KEY_B64, "base64");
if (raw.length !== 32) fail("REVOCATION_PUBLIC_KEY_B64 is not a 32-byte Ed25519 key");
const pub = createPublicKey({
  key: { kty: "OKP", crv: "Ed25519", x: raw.toString("base64url") },
  format: "jwk",
});

let text;
try {
  const res = await fetch(URL_, {
    headers: { "cache-control": "no-cache", "user-agent": "canvas-companion-sync" },
    signal: AbortSignal.timeout(20000),
  });
  if (!res.ok) fail(`GET ${URL_} -> HTTP ${res.status}`);
  const buf = Buffer.from(await res.arrayBuffer());
  if (buf.length > MAX_BYTES) fail(`response over ${MAX_BYTES} bytes`);
  text = buf.toString("utf8");
} catch (e) {
  fail(`GET ${URL_} failed: ${e.message}`);
}

let doc, data;
try {
  doc = JSON.parse(text);
  data = verifyDoc(doc, pub);
} catch (e) {
  fail(`the platform's revocations.json did not verify (${e.message}); keeping the committed list`);
}

const current = committedSeq();
output("seq", String(data.seq));
if (data.seq <= current) {
  const why = data.seq === current ? "already up to date" : "OLDER than the committed list — ignored";
  console.log(`platform seq ${data.seq}, committed seq ${current}: ${why}`);
  output("changed", "false");
  process.exit(0);
}
// Same shape as licensing/issue.py writes (json.dumps(doc, indent=1)).
writeFileSync(FILE, JSON.stringify({ payload: doc.payload, sig: doc.sig }, null, 1) + "\n");
console.log(`revocations.json: seq ${current} -> ${data.seq} (${data.revoked.length} revoked)`);
output("changed", "true");
