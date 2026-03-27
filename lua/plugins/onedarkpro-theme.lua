return {
  {
    "olimorris/onedarkpro.nvim",
    lazy = false, -- load at startup (not later)
    priority = 2000, -- load before most other plugins
    config = function()
      -- 1) Configure the theme
      require("onedarkpro").setup({
        lsp_semantic_highlights = true,
        colors = {
          bg = "#22252C",
          white = "#F8F8F2",
          black = "#000000",
        },
        highlights = {
          -- -- make pop up windows blend better with the background
          ["FloatBorder"] = { bg = "${bg}" },
          ["NormalFloat"] = { bg = "${bg}" },
          ["NvimTreeNormal"] = { bg = "${bg}" },
          ["NvimTreeEndOfBuffer"] = { bg = "${bg}", fg = "${bg}" },
          ["@variable"] = { fg = "${white}" },
          ["Number"] = { fg = "${yellow}", italic = true, bold = true },
          -- -- ["@comment"] = { fg = "${yellow}", italic = true, bold = true },
          -- ["OpencodeHint"] = { fg = "${yellow}", bold = true },
          ["Question"] = { fg = "${white}", bold = true },
          -- ["@spell.markdown"] = { fg = "${white}" },
          ["RenderMarkdownCode"] = { bg = "${black}" },
          ["RenderMarkdownCodeInline"] = { bg = "${black}" },
          -- ["@variable.go"] = { fg = "${white}" },
          ["@type.builtin.go"] = { fg = "${yellow}" },
          ["LspInlayHint"] = { fg = "${gray}", italic = true, bold = true },
        },
      })
      require("onedarkpro").load({ theme = "onedark_vivid" })
    end,
  },
}
