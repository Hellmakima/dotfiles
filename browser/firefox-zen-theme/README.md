# Zen-inspired Firefox (clean mode)

Pure-CSS theme that turns Firefox into nearly a blank screen: the toolbar and
the tabs hide completely and slide back in when you hover the top or left edge
of the window. Works with horizontal **and** vertical tabs. No extensions, no
installer — the "install" is two symlinks.

## What it does

- **Clean mode** (`css/cleanmode.css`): whole top toolbox (URL bar, buttons,
  tabs) and the vertical-tabs rail are hidden until hover / focus (Ctrl+L
  keeps the bar out). Turn it off anytime: `about:config` →
  `useroverrides.cleanMode` = `false` → restart.
- **Token-driven sizing**: every number and color lives in `css/variables.css`.
- **Tab orientation is your choice** — switch in Firefox's sidebar settings;
  it is not forced by this theme.

## Layout

```
firefox-zen-theme/
├── userChrome.css     # entry point (imports css/*)
├── user.js            # required prefs (revamp, clean mode flag)
└── css/
    ├── variables.css  # ← ALL sizes + colors you'd ever tune
    ├── tabs.css       #   tab pills
    ├── sidebar.css    #   sidebar/rail
    ├── toolbar.css    #   nav bar + URL bar
    ├── cleanup.css    #   small noise removal
    └── cleanmode.css  #   autohide behavior + hover-catch thickness
```

## Install (symlink, no .sh)

Firefox loads `userChrome.css` from `<profile>/chrome/` and `user.js` from the
profile root, only when `toolkit.legacyUserProfileCustomizations.stylesheets`
is `true`.

```sh
F=~/.config/mozilla/firefox/<your-profile>   # not XDG? try ~/.mozilla/firefox
cd ~/path/to/firefox-zen-theme
ln -s "$PWD"   "$F/chrome"
ln -s "$PWD/user.js" "$F/user.js"
# first time only: about:config → toolkit.legacyUserProfileCustomizations.stylesheets = true
```

Restart Firefox. Optional one-time UI step: pick **vertical tabs** in the
sidebar's settings menu if you want the floating left rail.

## Tune it (no CSS expertise)

- Values you'd tweak ("tabs too tall", "bar too slow") are all in
  `css/variables.css`.
- The hover-catch width lives in `css/cleanmode.css` (search for `8px`);
  bigger = easier to hit, slightly visible.
- Any edit applies after a restart. Nothing to copy — the symlinks always show
  the newest version.

## Rollback

- `rm "$F/chrome" "$F/user.js"` returns Firefox to stock instantly.
- The pre-theme CSS is preserved in this repo's git history
  (`backup/userChrome.css.original` on an old commit).

## After a Firefox update

Restart and look. The most fragile block is the token overrides at the top of
`css/tabs.css` — don't touch it unless something looks broken there.