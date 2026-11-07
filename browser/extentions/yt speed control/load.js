// load.js
const DEFAULT_SPEED = 1;
let currentSpeed = DEFAULT_SPEED;
let attachedVideo = null;
let loadedMetaHandler = null;
let lastUrl = location.href;

// get stored speed
function getStoredSpeed() {
  return new Promise((resolve) => {
    chrome.storage.local.get("ytSpeed", ({ ytSpeed }) => {
      resolve(typeof ytSpeed === "number" ? ytSpeed : DEFAULT_SPEED);
    });
  });
}

function applySpeedToVideo(v, speed) {
  try {
    if (!v) return;
    // set playbackRate; do it twice in case YouTube resets it briefly
    v.playbackRate = speed;
    setTimeout(() => {
      if (v && Math.abs(v.playbackRate - speed) > 1e-6) v.playbackRate = speed;
    }, 100);
  } catch (e) {
    // ignore
  }
}

function detachFromVideo() {
  if (!attachedVideo) return;
  if (loadedMetaHandler) {
    attachedVideo.removeEventListener("loadedmetadata", loadedMetaHandler);
    loadedMetaHandler = null;
  }
  attachedVideo = null;
}

function attachToVideo(v) {
  if (!v) return;
  if (attachedVideo === v) return;
  detachFromVideo();
  attachedVideo = v;

  // handler for metadata reloads (src changes)
  loadedMetaHandler = () => {
    applySpeedToVideo(attachedVideo, currentSpeed);
  };
  attachedVideo.addEventListener("loadedmetadata", loadedMetaHandler);

  // also apply immediately
  applySpeedToVideo(attachedVideo, currentSpeed);
}

function findAndAttachVideo() {
  const v = document.querySelector("video");
  if (v) attachToVideo(v);
  return !!v;
}

// Observe for new video elements added to the DOM
const nodeObserver = new MutationObserver((mutations) => {
  for (const m of mutations) {
    if (m.addedNodes && m.addedNodes.length) {
      for (const node of m.addedNodes) {
        if (node.nodeType !== 1) continue;
        if (node.tagName === "VIDEO") {
          attachToVideo(node);
          return;
        }
        const inner = node.querySelector && node.querySelector("video");
        if (inner) {
          attachToVideo(inner);
          return;
        }
      }
    }
  }
});
nodeObserver.observe(document, { childList: true, subtree: true });

// Hook history API to detect SPA navigation reliably
(function () {
  function wrap(type) {
    const orig = history[type];
    return function () {
      const res = orig.apply(this, arguments);
      window.dispatchEvent(new Event("locationchange"));
      return res;
    };
  }
  history.pushState = wrap("pushState");
  history.replaceState = wrap("replaceState");
  window.addEventListener("popstate", () =>
    window.dispatchEvent(new Event("locationchange")),
  );
})();

window.addEventListener("locationchange", () => {
  if (location.href === lastUrl) return;
  lastUrl = location.href;
  // give YouTube a short moment to swap content, then hunt for a video
  setTimeout(() => {
    // try quick attach; if not found, the nodeObserver will catch added video
    findAndAttachVideo();
  }, 200);
});

// Listen for storage changes (applies when background updates ytSpeed)
chrome.storage.onChanged.addListener((changes, area) => {
  if (area !== "local") return;
  if (changes.ytSpeed) {
    currentSpeed =
      typeof changes.ytSpeed.newValue === "number"
        ? changes.ytSpeed.newValue
        : DEFAULT_SPEED;
    if (attachedVideo) applySpeedToVideo(attachedVideo, currentSpeed);
    else findAndAttachVideo();
  }
});

// Also accept direct messages from background to be extra responsive
chrome.runtime.onMessage.addListener((msg, sender, sendResponse) => {
  if (msg && msg.type === "yt-speed-updated") {
    currentSpeed = typeof msg.speed === "number" ? msg.speed : currentSpeed;
    if (attachedVideo) applySpeedToVideo(attachedVideo, currentSpeed);
    else findAndAttachVideo();
  }
});

// initial startup: read stored speed, attach to any existing video
getStoredSpeed().then((s) => {
  currentSpeed = s;
  findAndAttachVideo();
});
