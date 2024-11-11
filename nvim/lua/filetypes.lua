-- vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
-- pattern = {"*.jenkinsfile"},
-- command = "set filetype=groovy"
-- })
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = { "*.jenkinsfile" },
--   callback = function()
--     vim.bo.filetype = "groovy"
--     vim.bo.shiftwidth = 4
--     vim.bo.tabstop = 4
--     vim.bo.softtabstop = 4
--   end,
-- })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.jenkinsfile" },
  callback = function()
    -- Set buffer options
    vim.bo.filetype = "groovy"
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4

    -- Set environment variables with password in plain text
    vim.env.JENKINS_USER_ID = "admin"
    vim.env.JENKINS_URL = "http://localhost:8081"
    vim.env.JENKINS_PASSWORD = "4f534631b2474b4e8ae72f028137a2df"
    require("jenkinsfile_linter").validate()
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.jenkinsfile" },
  callback = function()
    require("jenkinsfile_linter").validate()
  end,
})

-- example
-- vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
--   pattern = {"*.foo", "*.bar", "*.baz"},
--   command = "set filetype=python"
-- })
