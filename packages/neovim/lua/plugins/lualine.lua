return {
    "lualine.nvim",
    lazy = false,
    after = function()

        local sep = { function() return '║' end, color = { fg = '#4C566A' }, padding = 0 }

        local lsp_clients = function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then return "" end
        local names = {}
        for _, client in ipairs(clients) do
            table.insert(names, client.name)
        end
        return "󰒋 " .. table.concat(names, " ")
        end

        require('lualine').setup {
        options = {
            theme = 'nord',
            section_separators = { left = '', right = '' },
            component_separators = { left = '', right = '' },
            globalstatus = true,
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff' },
            lualine_c = { 'filename', 'diagnostics' },
            lualine_x = { 'encoding', sep, 'filetype', sep, lsp_clients },
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
        },
        }
    end
}
