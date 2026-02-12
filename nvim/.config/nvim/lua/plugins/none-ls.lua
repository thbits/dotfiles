return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"gbprod/none-ls-shellcheck.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		local sources = {
			null_ls.builtins.completion.spell,
		}

		local conditional_sources = {
			{ cmd = "stylua", source = null_ls.builtins.formatting.stylua },
			{ cmd = "isort", source = null_ls.builtins.formatting.isort },
			{ cmd = "black", source = null_ls.builtins.formatting.black },
			{ cmd = "hadolint", source = null_ls.builtins.diagnostics.hadolint },
			{ cmd = "npm-groovy-lint", source = null_ls.builtins.diagnostics.npm_groovy_lint },
			{ cmd = "prettier", source = null_ls.builtins.formatting.prettier },
			{ cmd = "terraform", source = null_ls.builtins.formatting.terraform_fmt },
			{ cmd = "terraform", source = null_ls.builtins.diagnostics.terraform_validate },
			{ cmd = "yamlfix", source = null_ls.builtins.formatting.yamlfix },
			{ cmd = "shfmt", source = null_ls.builtins.formatting.shfmt },
			{ cmd = "djlint", source = null_ls.builtins.formatting.djlint },
		}

		for _, entry in ipairs(conditional_sources) do
			if vim.fn.executable(entry.cmd) == 1 then
				table.insert(sources, entry.source)
			end
		end

		if vim.fn.executable("shellcheck") == 1 then
			table.insert(sources, require("none-ls-shellcheck.diagnostics"))
			table.insert(sources, require("none-ls-shellcheck.code_actions"))
		end

		null_ls.setup({ sources = sources })
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
