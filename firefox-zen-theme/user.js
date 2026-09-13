/* ============================================================
   ZEN-INSPIRED FIREFOX — preference pins (user.js)
   ------------------------------------------------------------
   Firefox applies this file at every startup, so the preferences
   the theme relies on can never silently drift.

   These are the ONLY prefs this theme needs. Everything else is
   styled with plain CSS and native behavior.

   NOTE: because it re-applies on every launch, any manual toggle
   you make here in about:config will be reset on restart. To stop
   that, remove this file (uninstall.sh does that for you).
   ============================================================ */

// REQUIRED — lets Firefox load chrome/userChrome.css (default off).
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Native sidebar + vertical tabs (Firefox's own implementation).
// NOTE: tab orientation is deliberately NOT pinned here — switch
// between vertical/horizontal in the sidebar settings whenever you
// like; your choice persists across launches. Only the sidebar
// engine itself is pinned.
user_pref("sidebar.revamp", true);
// user_pref("sidebar.verticalTabs", true);

// Zen-like behavior: collapsed icon rail that pops out on hover,
// overlaying the page instead of pushing it.
user_pref("sidebar.visibility", "expand-on-hover");

// CLEAN MODE (css/cleanmode.css): hides the whole toolbar + tabs
// rail and floats them back in on hover near the top / left edge.
// Turn off anytime in about:config then restart.
user_pref("useroverrides.cleanMode", true);

// Safe fallback: Firefox's native fullscreen (F11) already hides
// everything with a hover-to-reveal; keep that auto-hiding on.
user_pref("browser.fullscreen.autohide", true);

// OPTIONAL — compact UI density. The CSS no longer depends on it
// (all sizes come from css/variables.css), but compact matches
// Zen's density elsewhere (menus, context menus). Uncomment if
// this profile is not already compact.
// user_pref("browser.uidensity", -75);

/* NOT SET, on purpose:
   - browser.uiCustomization.state — the toolbar/tab layout, which
     depends on your extensions; set it once via the two checkboxes
     in the sidebar's settings menu (see README "First-time setup").
   - any theme/skin prefs — colors come from CSS tokens instead.   */
