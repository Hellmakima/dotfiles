// Fallback for Chromium builds where declarativeNetRequest cannot rewrite URLs.
// The static rules in rules.json run first, so this rarely fires.

const GLOBAL_PARAMS = [
  "utm_source", "utm_medium", "utm_campaign", "utm_term", "utm_content",
  "utm_id", "utm_source_platform", "utm_creative_format", "utm_marketing_tactic",
  "utm_referrer", "fbclid", "gclid", "dclid", "gbraid", "wbraid", "msclkid",
  "twclid", "yclid", "igsh", "igshid", "mc_cid", "mc_eid", "_hsenc", "_hsmi",
];

const YOUTUBE_PARAMS = ["si", "pp", "feature", "app"];
const INSTAGRAM_PARAMS = ["obrf"];

const SCOPED = [
  { domain: "youtube.com", params: YOUTUBE_PARAMS },
  { domain: "youtube-nocookie.com", params: YOUTUBE_PARAMS },
  { domain: "youtu.be", params: YOUTUBE_PARAMS },
  { domain: "instagram.com", params: INSTAGRAM_PARAMS },
];

const MAX_HISTORY = 50;
const recent = new Set();

function paramNamesFor(host) {
  const names = new Set(GLOBAL_PARAMS);
  const bare = host.replace(/^www\./, "");
  for (const entry of SCOPED) {
    if (bare === entry.domain || bare.endsWith("." + entry.domain)) {
      for (const name of entry.params) names.add(name);
    }
  }
  return names;
}

function cleanUrl(raw) {
  let url;
  try {
    url = new URL(raw);
  } catch {
    return null;
  }
  if (url.protocol !== "http:" && url.protocol !== "https:") return null;

  const names = paramNamesFor(url.hostname);
  let changed = false;
  for (const key of [...url.searchParams.keys()]) {
    if (names.has(key)) {
      url.searchParams.delete(key);
      changed = true;
    }
  }
  if (!changed) return null;
  return url.toString();
}

function remember(url) {
  if (recent.has(url)) return false;
  recent.add(url);
  if (recent.size > MAX_HISTORY) {
    recent.delete(recent.values().next().value);
  }
  return true;
}

chrome.webNavigation.onBeforeNavigate.addListener((details) => {
  if (details.frameId !== 0) return;

  const cleaned = cleanUrl(details.url);
  if (!cleaned || cleaned === details.url) return;
  if (!remember(details.url)) return;

  chrome.tabs.update(details.tabId, { url: cleaned }).catch(() => {
    recent.delete(details.url);
  });
});
