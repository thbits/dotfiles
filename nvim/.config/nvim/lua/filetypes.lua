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
    vim.env.JENKINS_PASSWORD = "c664edd5a79b4ad184d9fa2645e8202c"
    require("jenkinsfile_linter").validate()
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.jenkinsfile" },
  callback = function()
    require("jenkinsfile_linter").validate()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "helm", -- fires whenever ft becomes `helm`
  callback = function(args)
    -- Use the new API: returns only clients attached to this buffer
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
      if client.name == "yamlls" then
        client.stop() -- cleanly detach yamlls from this buffer
      end
    end
  end,
})

-- example
-- vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
--   pattern = {"*.foo", "*.bar", "*.baz"},
--   command = "set filetype=python"
-- })
