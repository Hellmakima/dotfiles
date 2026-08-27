return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.transparent_enabled = true
      require("transparent").setup({
        extra_groups = {
          "NormalFloat",
          "NvimTreeNormal",
          "NeoTreeNormal",
          "NeoTreeNormalNC",
        },
      })

      require("transparent").clear_prefix("BufferLine")
    end,
  },
}