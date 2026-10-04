-- Treesitter is disabled on this phone.
-- Parser builds kept failing on aarch64-android and the failure was noisy on every
-- startup. Upstream LazyVim re-declares these plugins in
-- lua/lazyvim/plugins/treesitter.lua, so disable them from here instead of editing
-- the plugin repo (which gets wiped on :Lazy update).
-- To re-enable: delete this file.
return {
  { "nvim-treesitter/nvim-treesitter", enabled = false },
  { "nvim-treesitter/nvim-treesitter-textobjects", enabled = false },
  { "winddp/nvim-ts-autotag", enabled = false },
}