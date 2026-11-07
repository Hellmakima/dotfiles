// Functions
function clickVisibleLike() {
  const svgs = document.querySelectorAll('svg[aria-label="Like"], svg[aria-label="Unlike"]');
  for (const svg of svgs) {
    const rect = svg.getBoundingClientRect();
    if (rect.top >= 0 && rect.bottom <= window.innerHeight) {
      svg.closest('button,div[role="button"]').click();
      break;
    }
  }
}

function clickVisibleComment() {
  const svgs = document.querySelectorAll('svg[aria-label="Comment"]');
  for (const svg of svgs) {
    const rect = svg.getBoundingClientRect();
    if (rect.top >= 0 && rect.bottom <= window.innerHeight) {
      svg.closest('button,div[role="button"]').click();
      break;
    }
  }
}

/*
TODO:

add 
[...document.querySelectorAll('div[role="button"]')].forEach(el => {
  const rect = el.getBoundingClientRect();
  if (el.innerText.includes("Follow") && rect.top >= 0 && rect.bottom <= window.innerHeight) {
    el.click();
  }
});

*/

function toggleVisibleCaption() {
  const posts = document.querySelectorAll('div[role="button"][aria-disabled="false"]');
  for (const post of posts) {
    const rect = post.getBoundingClientRect();
    if (rect.top >= 0 && rect.bottom <= window.innerHeight) {
      const hiddenSpan = post.querySelector('span[aria-hidden="true"]');
      if (hiddenSpan && hiddenSpan.textContent.includes("… more")) {
        hiddenSpan.click();
      } else {
        post.click();
      }
      break;
    }
  }
}

function toggleReelPlay() {
  const posts = document.querySelectorAll('div[role="button"][aria-disabled="false"]');
  for (const post of posts) {
    const rect = post.getBoundingClientRect();
    if (rect.top >= 0 && rect.bottom <= window.innerHeight) {
      post.click();
      break;
    }
  }
}

function toggleAudioMute() {
  const audioButtons = document.querySelectorAll('svg[aria-label="Audio is muted"], svg[aria-label="Audio is playing"]');
  for (const btn of audioButtons) {
    const rect = btn.getBoundingClientRect();
    if (rect.top >= 0 && rect.bottom <= window.innerHeight) {
      btn.closest('div[role="button"]').click();
      break;
    }
  }
}

function moveVisibleVideo(seconds) {
  document.querySelectorAll('video').forEach(video => {
    const rect = video.getBoundingClientRect();
    if (rect.top >= 0 && rect.bottom <= window.innerHeight) {
      video.currentTime = Math.max(0, Math.min(video.duration, video.currentTime + seconds));
    }
  });
}

// Keyboard mapping
document.addEventListener('keydown', (e) => {
  if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;

  switch (e.key.toLowerCase()) {
    case 'l': // like/unlike
      clickVisibleLike();
      break;
    case 'c': // comment
      clickVisibleComment();
      break;
    case 'k': // toggle caption
      toggleVisibleCaption();
      break;
    case ' ': // space → play/pause reel
      e.preventDefault();
      toggleReelPlay();
      break;
    case 'm': // mute/unmute
      toggleAudioMute();
      break;
    case 'arrowright': // forward 5 sec
      moveVisibleVideo(5);
      break;
    case 'arrowleft': // backward 5 sec
      moveVisibleVideo(-5);
      break;
  }
});