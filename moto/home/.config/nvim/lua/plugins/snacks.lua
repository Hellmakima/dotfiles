return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>e", false },
    },
    opts = {
      picker = {
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
          git_files = { hidden = true },
        },
      },
    },
  },
}
