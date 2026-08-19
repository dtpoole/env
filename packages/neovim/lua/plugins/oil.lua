return {
  "oil.nvim",
  keys = {
    { "-",    "<CMD>Oil<CR>", desc = "Open parent directory" },
    { "<C-d>","<CMD>Oil<CR>", desc = "Open parent directory" },
  },
  after = function()
    require('oil').setup()
  end,
}
