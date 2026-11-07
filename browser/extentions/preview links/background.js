let enabled = false;

chrome.commands.onCommand.addListener((command) => {
  if (command === "toggle-preview") {
    enabled = !enabled;
    // console.log("[LinkPreview] Alt+P pressed. Enabled =", enabled);
    chrome.tabs.query({active: true, currentWindow: true}, (tabs) => {
      chrome.scripting.executeScript({
        target: {tabId: tabs[0].id},
        func: (state) => {
          window.dispatchEvent(new CustomEvent("toggleLinkPreview", {detail: state}));
        },
        args: [enabled]
      });
    });
  }
});
