function removeGradients() {
  const top = document.querySelector('.ytp-gradient-top');
  const bottom = document.querySelector('.ytp-gradient-bottom');
  const topbar = document.querySelector('.ytp-chrome-top');
  
  if (top) top.remove();
  if (bottom) bottom.remove();
  if (topbar) topbar.remove();
}

// Run once and also watch for future changes
removeGradients();
const observer = new MutationObserver(removeGradients);
observer.observe(document.body, { childList: true, subtree: true });
