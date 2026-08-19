return {
  "nord.nvim",
  lazy = false,
  after = function()
    vim.g.nord_contrast = true
    vim.g.nord_borders = true
    vim.g.nord_disable_background = false
    vim.g.nord_italic = false
    vim.g.nord_uniform_diff_background = true
    vim.g.nord_bold = false
    require('nord').set()
    vim.cmd.colorscheme 'nord'
    vim.cmd([[highlight WinSeparator guifg=#434C5E guibg=NONE]])
  end,
}
