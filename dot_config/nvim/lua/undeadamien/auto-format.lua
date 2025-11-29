local clang_format_cmd = "clang-format --style=file --fallback-style=google -i"
local stylua_cmd = "stylua"
local asmfmt_cmd = "asmfmt -w"
local shfmt_cmd = "shfmt --write"
local python_cmd = "isort && black"
local prettier_cmd = "prettier --write"
local formatters = {
	c = clang_format_cmd,
	cpp = clang_format_cmd,
	h = clang_format_cmd,
	hpp = clang_format_cmd,
	lua = stylua_cmd,
	s = asmfmt_cmd,
	sh = shfmt_cmd,
	bash = shfmt_cmd,
	zsh = shfmt_cmd,
	python = python_cmd,
	javascript = prettier_cmd,
	javascriptreact = prettier_cmd,
	typescript = prettier_cmd,
	typescriptreact = prettier_cmd,
	jsx = prettier_cmd,
	tsx = prettier_cmd,
	html = prettier_cmd,
	css = prettier_cmd,
	json = prettier_cmd,
	jsonc = prettier_cmd,
	markdown = prettier_cmd,
}
vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function()
		local ft = vim.bo.filetype
		local cmd = formatters[ft]
		if cmd then
			local filepath = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
			vim.api.nvim_command("silent !" .. cmd .. " " .. filepath)
		end
	end,
})
