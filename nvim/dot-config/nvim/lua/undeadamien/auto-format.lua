local formatters = {
	{
		pattern = { "*.h", "*.c", "*.hpp", "*.cpp" },
		command = "clang-format --style=file --fallback-style=google -i %",
	},
	{ pattern = { "*.lua" }, command = "stylua %" },
	{ pattern = { "*.sh", "*.bashrc", "*.zshrc" }, command = "shfmt --write %" },
	{ pattern = { "*.py" }, command = "isort % && black %" },
	{ pattern = { "*.md", "*.js", "*.ts", "*.html", "*.css", "*.json", "*.jsonc" }, command = "prettier --write %" },
}

for _, formatter in ipairs(formatters) do
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = formatter.pattern,
		callback = function()
			vim.api.nvim_command("silent !" .. formatter.command)
		end,
	})
end
