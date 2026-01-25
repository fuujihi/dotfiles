-- LSP設定

-- Mason設定
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
	mason.setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗"
			}
		}
	})
end

-- nvim-cmpとの連携
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_nvim_lsp_ok then
	capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- LSP接続時のキーマッピング
local function on_attach(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- lspsagaが使わないキーのみ設定
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>f", function()
		vim.lsp.buf.format({ async = true })
	end, opts)
	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
end

-- Masonのbinディレクトリのパス
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

-- Masonのパスを取得するヘルパー関数
local function get_mason_cmd(executable_name)
	local mason_path = mason_bin .. executable_name
	if vim.fn.executable(mason_path) == 1 then
		return mason_path
	end
	return executable_name
end

-- Lua Language Server
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.lsp.start({
			name = "lua_ls",
			cmd = { get_mason_cmd("lua-language-server") },
			on_attach = on_attach,
			capabilities = capabilities,
			root_dir = vim.fs.dirname(vim.fs.find({ ".git", "lua" }, { upward = true })[1]) or vim.fn.getcwd(),
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},
			},
		})
	end,
})

-- Python Language Server
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.lsp.start({
			name = "pyright",
			cmd = { get_mason_cmd("pyright-langserver"), "--stdio" },
			on_attach = on_attach,
			capabilities = capabilities,
			root_dir = vim.fs.dirname(vim.fs.find({ ".git", "setup.py", "pyproject.toml" }, { upward = true })[1]) or vim.fn.getcwd(),
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "workspace",
					},
				},
			},
		})
	end,
})

-- 診断表示設定
vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 4 },
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = { source = "always", border = "rounded" },
})

-- 診断シンボル設定
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
