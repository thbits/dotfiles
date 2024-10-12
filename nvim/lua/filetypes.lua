vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
pattern = {"*.jenkinsfile"},
command = "set filetype=groovy"
})

-- example
-- vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
--   pattern = {"*.foo", "*.bar", "*.baz"},
--   command = "set filetype=python"
-- })
