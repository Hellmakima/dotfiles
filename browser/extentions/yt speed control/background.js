// background.js
const MIN_SPEED = 0.25;
const MAX_SPEED = 4;
const STEP = 0.25;

function clamp(v) {
  return Math.max(MIN_SPEED, Math.min(MAX_SPEED, v));
}

chrome.commands.onCommand.addListener((command) => {
  if (command !== "increase-speed" && command !== "decrease-speed") return;
  const delta = command === "increase-speed" ? STEP : -STEP;

  chrome.storage.local.get("ytSpeed", ({ ytSpeed }) => {
    const base = typeof ytSpeed === "number" ? ytSpeed : 1;
    const newSpeed = clamp(Math.round((base + delta) * 100) / 100);
    chrome.storage.local.set({ ytSpeed: newSpeed }, () => {
      // push a message to all YouTube watch tabs so they immediately apply
      chrome.tabs.query({ url: "*://www.youtube.com/watch*" }, (tabs) => {
        for (const t of tabs) {
          chrome.tabs.sendMessage(
            t.id,
            { type: "yt-speed-updated", speed: newSpeed },
            () => {},
          );
        }
      });
    });
  });
});
