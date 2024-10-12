return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({})
			-- Use the bufferline recommended mappings
			vim.api.nvim_set_keymap('n', ']', ':bnext<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', '[', ':bprevious<CR>', { noremap = true, silent = true })
		end,
	},
}
