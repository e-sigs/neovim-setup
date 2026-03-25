-- nvim-surround - Add/change/delete surrounding pairs
return {
  {
    "kylechui/nvim-surround",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
