-- mini.pairs - Auto pairs for brackets, quotes, etc.
return {
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {
      -- In which modes mappings should be created
      modes = { insert = true, command = false, terminal = false },

      -- Global mappings (uses official defaults)
      -- By default pair is not inserted after `\`, quotes are not recognized by
      -- <CR>, `'` does not insert the pair after a letter.
      mappings = {
        ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]" },
        ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]" },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]" },

        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]" },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]" },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]" },

        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\]", register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\]", register = { cr = false } },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\]", register = { cr = false } },
      },
    },
  },
}
