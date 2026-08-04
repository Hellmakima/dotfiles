-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

for i = 1, 9 do
  vim.keymap.set("n", "<leader>b" .. i, function()
    require("bufferline").go_to(i, true)
  end)
end

vim.keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>")
vim.keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>")
