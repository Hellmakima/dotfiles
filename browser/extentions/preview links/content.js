let previewEnabled = false;
let iframe = null;
let lastHref = null;

console.log("[LinkPreview] Content script loaded");

window.addEventListener("toggleLinkPreview", (e) => {
  previewEnabled = e.detail;
  console.log("[LinkPreview] Preview mode =", previewEnabled);

  if (!previewEnabled && iframe) {
    console.log("[LinkPreview] Disabling and removing iframe");
    iframe.remove();
    iframe = null;
    lastHref = null;
  }
});

document.addEventListener("mousemove", (e) => {
  if (!previewEnabled) return;

  const link = e.target.closest("a[href]");
  if (link) {
    // console.log("[LinkPreview] Hovering link:", link.href);

    if (!iframe) {
      // console.log("[LinkPreview] Creating iframe");
      iframe = document.createElement("iframe");
      iframe.style.position = "fixed";
      iframe.style.width = "400px";
      iframe.style.height = "300px";
      iframe.style.border = "2px solid black";
      iframe.style.zIndex = "999999";
      document.body.appendChild(iframe);
    }

    if (link.href !== lastHref) {
      console.log("[LinkPreview] Setting iframe src to:", link.href);
      iframe.src = link.href;
      lastHref = link.href;
    }

    const padding = 20;
    const iframeWidth = 400;
    const iframeHeight = 300;

    let left = e.clientX + padding;
    let top = e.clientY + padding;

    if (left + iframeWidth > window.innerWidth) {
      left = window.innerWidth - iframeWidth - padding;
    }
    if (top + iframeHeight > window.innerHeight) {
      top = window.innerHeight - iframeHeight - padding;
    }

    iframe.style.left = left + "px";
    iframe.style.top = top + "px";

    console.log("[LinkPreview] Moved iframe to:", iframe.style.left, iframe.style.top);
  } else if (iframe) {
    console.log("[LinkPreview] Not hovering a link, removing iframe");
    iframe.remove();
    iframe = null;
    lastHref = null;
  }
});
