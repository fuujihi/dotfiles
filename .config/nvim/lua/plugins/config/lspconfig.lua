-- LSP設定 - 確実に動作する版

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
else
	vim.notify("Mason not found", vim.log.levels.INFO)
end

-- nvim-cmpとの連携
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_nvim_lsp_ok then
	capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- LSP接続時のキーマッピング
local function on_attach(client, bufnr)
	vim.notify("LSP attached: " .. client.name .. " to buffer " .. bufnr, vim.log.levels.INFO)

	-- omnifunc設定
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- lspsagaが使わないキーのみ設定
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

	-- ワークスペース管理
	vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set('n', '<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)

	-- その他の操作
	vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
	vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
	vim.keymap.set('n', '<leader>f', function()
		vim.lsp.buf.format { async = true }
	end, opts)

	-- 診断ナビゲーション（lspsagaが使わないキー）
	vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
end

-- Masonのパスを取得するヘルパー関数
local function get_mason_cmd(package_name, executable_name)
	local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
	if mason_registry_ok and mason_registry.is_installed(package_name) then
		local install_path = mason_registry.get_package(package_name):get_install_path()
		return install_path .. "/bin/" .. executable_name
	end
	return executable_name
end

-- LSPサーバー起動関数
local function start_lsp_server(name, config)
	vim.notify("Starting LSP: " .. name, vim.log.levels.INFO)

	local client_id = vim.lsp.start(config)
	if client_id then
		vim.notify("LSP started successfully: " .. name .. " (ID: " .. client_id .. ")", vim.log.levels.INFO)
	else
		vim.notify("Failed to start LSP: " .. name, vim.log.levels.ERROR)
	end
	return client_id
end

-- Lua Language Server
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		local cmd = get_mason_cmd("lua-language-server", "lua-language-server")

		start_lsp_server("lua_ls", {
			name = "lua_ls",
			cmd = { cmd },
			on_attach = on_attach,
			capabilities = capabilities,
			root_dir = vim.fs.dirname(vim.fs.find({".git", "lua"}, { upward = true })[1]) or vim.fn.getcwd(),
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})
	end,
	once = false,
})

-- Python Language Server
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		local cmd = get_mason_cmd("pyright", "pyright-langserver")

		start_lsp_server("pyright", {
			name = "pyright",
			cmd = { cmd, "--stdio" },
			on_attach = on_attach,
			capabilities = capabilities,
			root_dir = vim.fs.dirname(vim.fs.find({".git", "setup.py", "pyproject.toml"}, { upward = true })[1]) or vim.fn.getcwd(),
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
	once = false,
})

-- 診断表示設定
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 4,
	},
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		source = "always",
		border = "rounded",
	},
})

-- 診断シンボル設定
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- LSP状態確認コマンド
vim.api.nvim_create_user_command('LspStatus', function()
	local clients = vim.lsp.get_clients()
	if #clients == 0 then
		vim.notify("No LSP clients attached", vim.log.levels.INFO)
	else
		local info = "Active LSP clients:\n"
		for _, client in ipairs(clients) do
			info = info .. "- " .. client.name .. " (id: " .. client.id .. ")\n"
		end
		vim.notify(info, vim.log.levels.INFO)
	end
end, { desc = "Show LSP client status" })

-- Mason状態確認コマンド
vim.api.nvim_create_user_command('MasonStatus', function()
	if not mason_ok then
		vim.notify("Mason not available", vim.log.levels.ERROR)
		return
	end

	local registry_ok, registry = pcall(require, "mason-registry")
	if not registry_ok then
		vim.notify("Mason registry not available", vim.log.levels.ERROR)
		return
	end

	local installed = registry.get_installed_package_names()
	if #installed == 0 then
		vim.notify("No packages installed via Mason", vim.log.levels.INFO)
	else
		local info = "Mason installed packages:\n"
		for _, pkg in ipairs(installed) do
			info = info .. "- " .. pkg .. "\n"
		end
		vim.notify(info, vim.log.levels.INFO)
	end
end, { desc = "Show Mason package status" })