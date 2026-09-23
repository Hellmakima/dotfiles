-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.api.nvim_create_user_command("V", "normal! V", {})
-- vim.api.nvim_create_user_command("v", "normal! v", {})

vim.keymap.set("n", ";", ":", { desc = "Command line" })
vim.keymap.set("n", "<leader><leader>", "<cmd>w<cr>", { desc = "write" })
vim.keymap.set({"n", "v"}, "q", "<cmd>q<cr>", { desc = "quit" })
vim.keymap.set({"i", "v"}, "jk", "<ESC>", { desc = "write"})
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "half page down + center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "half page up + center" })
