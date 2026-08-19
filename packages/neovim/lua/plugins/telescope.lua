return {
  "telescope.nvim",
  keys = {
    { "<leader>b",  desc = "Buffers" },
    { "<leader>f",  desc = "Find files" },
    { "<leader>gb", desc = "Git branches" },
    { "<leader>gc", desc = "Git commits" },
    { "<leader>gs", desc = "Git status" },
    { "<leader>d",  desc = "Diagnostics" },
    { "<leader>g",  desc = "Live grep" },
  },
  after = function()
    local builtin = require('telescope.builtin')
    require('telescope').setup {
      pickers = {
        diagnostics = {
          layout_strategy = 'vertical',
          layout_config = {
            vertical = {
              width = 0.9,
              height = 0.9,
              preview_height = 0.5,
              mirror = true,
            },
          },
        },
      },
    }
    vim.keymap.set('n', '<leader>b', builtin.buffers,       { desc = 'Buffers' })
    vim.keymap.set('n', '<leader>f', builtin.find_files,    { desc = 'Find files' })
    vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = 'Git branches' })
    vim.keymap.set('n', '<leader>gc', builtin.git_commits,  { desc = 'Git commits' })
    vim.keymap.set('n', '<leader>gs', builtin.git_status,   { desc = 'Git status' })
    vim.keymap.set('n', '<leader>d', builtin.diagnostics,   { desc = 'Diagnostics' })
    vim.keymap.set('n', '<leader>g', builtin.live_grep,     { desc = 'Live grep' })
  end,
}
