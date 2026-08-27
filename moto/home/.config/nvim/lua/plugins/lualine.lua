return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      return opts
    end,
    config = function(_, opts)
      vim.g.lualine_enabled = false
      vim.g.lualine_laststatus = vim.o.laststatus
      vim.o.laststatus = 0

      vim.api.nvim_create_user_command("ToggleStatusbar", function()
        if vim.g.lualine_enabled then
          vim.g.lualine_enabled = false
          vim.o.laststatus = 0
        else
          vim.g.lualine_enabled = true
          vim.o.laststatus = vim.g.lualine_laststatus or 2
          require("lualine").setup(opts)
        end
      end, { desc = "Toggle lualine statusline" })
    end,
  },
}
