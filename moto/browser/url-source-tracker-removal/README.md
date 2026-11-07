# URL Source Tracker Removal

Strips share/tracking parameters from the address bar **before** the page loads, so the server never sees them and no extra reload happens.

Removed:

| Scope | Params |
| --- | --- |
| YouTube (`youtube.com`, `youtu.be`, `youtube-nocookie.com`) | `si`, `pp`, `feature`, `app` |
| Instagram | `obrf`, `igsh`, `igshid` |
| every site | all `utm_*`, `fbclid`, `gclid`, `dclid`, `gbraid`, `wbraid`, `msclkid`, `twclid`, `yclid`, `mc_cid`, `mc_eid`, `_hsenc`, `_hsmi` |

Examples:

- `https://www.instagram.com/reel/DfR7BUspR5W/?obrf=M205Zno0YjUwbGtt` -> `https://www.instagram.com/reel/DfR7BUspR5W/`
- `https://youtube.com/shorts/tnJ6sNngBk4?si=1RuMQB8A3RnCBrX5` -> `https://youtube.com/shorts/tnJ6sNngBk4`

## Install

Chromium only (Chrome, Edge, Brave, Cromite, Kiwi, Vivaldi). Uses Manifest V3 `declarativeNetRequest` redirects.

Desktop / Kiwi / Cromite:

1. Copy this folder to the browser machine (or zip it).
2. Open `chrome://extensions`.
3. Enable Developer mode.
4. "Load unpacked" -> pick the `url-source-tracker-removal` folder.

The `background.js` service worker is only a fallback for builds that cannot rewrite URLs via `declarativeNetRequest`; leave it alone.

## Extending

- Add params to `rules.json` **and** to the matching list in `background.js` (rules handle the normal path, the script is the safety net).
- Rule priorities: 3 = YouTube, 2 = Instagram, 1 = global. Higher priority wins for the same request.
