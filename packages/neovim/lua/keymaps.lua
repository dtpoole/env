local map = vim.keymap.set

-- Insert
map('i', 'jj', '<Esc>')

-- Window navigation
map('n', '<C-j>', '<C-w><C-j>')
map('n', '<C-k>', '<C-w><C-k>')
map('n', '<C-l>', '<C-w><C-l>')
map('n', '<C-h>', '<C-w><C-h>')

-- Movement
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- Leader
map('n', '<leader>/', ':nohlsearch<CR>')
map('n', '<leader><leader>', '<C-^>')
map('n', '<leader>l', ':set list!<CR>')
map('n', '<leader>n', ':set number!<CR>')

-- Buffer
map('n', '<C-g>', ':bn<CR>')

-- Trailing whitespace
map('n', '_$', ':%s/\\s\\+$//e<CR>')

-- LSP
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
-- float=true matches the old goto_prev/goto_next behaviour; nvim's built-in
-- ]d / [d jump without opening the float.
map('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = 'Previous diagnostic' })
map('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = 'Next diagnostic' })

-- Format (LSP or fallback)
map('n', '_=', function()
  if next(vim.lsp.get_clients()) then
    vim.lsp.buf.format({ async = false })
  else
    vim.cmd('normal! gg=G``')
  end
end)
