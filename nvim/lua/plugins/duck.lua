return {
    'tamton-aquib/duck.nvim',
    config = function()
        vim.keymap.set('n', '<leader>yy', function() require("duck").hatch() end, {})
        vim.keymap.set('n', '<leader>yu', function() require("duck").cook() end, {})
        vim.keymap.set('n', '<leader>yo', function() require("duck").cook_all() end, {})
    end
}
