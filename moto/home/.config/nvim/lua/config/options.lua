local opt = vim.opt

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- h at column 0 jumps to the last char of the previous line
-- l at end of line jumps to the first char of the next line
opt.whichwrap:append(",h,l")

opt.number = false
opt.relativenumber = false

if vim.env.TMUX then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
    cache_enabled = 0,
  }
end

-- Always use system clipboard for yanks and puts
vim.opt.clipboard = "unnamedplus"

vim.diagnostic.config({
  update_in_insert = true,
})
