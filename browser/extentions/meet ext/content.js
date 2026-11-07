// Auto-click mute and close camera
function clickIfOn(sel, attr = 'aria-label', offText = 'Turn off') {
  const el = document.querySelector(sel);
  if (el?.getAttribute(attr)?.toLowerCase().includes(offText.toLowerCase())) {
    el.click();
    return true;
  }
  return false;
}

function tryDisable() {
  if (clickIfOn('[jsname="hw0c9"]') | clickIfOn('[jsname="psRWwc"]')) {
    mediaObserver.disconnect();
  }
}

const mediaObserver = new MutationObserver(tryDisable);
tryDisable();
mediaObserver.observe(document.body, { childList: true, subtree: true });

// Auto-click Join button when it appears
const joinObserver = new MutationObserver(() => {
  const joinBtn = [...document.querySelectorAll('button')]
    .find(btn => btn.innerText.toLowerCase().includes('join'));
  if (joinBtn && !joinBtn.disabled) {
    joinBtn.click();
    joinObserver.disconnect();
    console.log('Auto-joined');
  }
});

joinObserver.observe(document.body, { childList: true, subtree: true });