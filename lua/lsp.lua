require'lspconfig'.lua_ls.setup {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc')) then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
}


local custom_attach = function(client)
	print("LSP started.")

	vim.api.nvim_set_keymap('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>', {})
	vim.api.nvim_set_keymap('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>', {})
	vim.api.nvim_set_keymap('n','K','<cmd>lua vim.lsp.buf.hover()<CR>', {})
	vim.api.nvim_set_keymap('n','gr','<cmd>lua vim.lsp.buf.references()<CR>', {})
	vim.api.nvim_set_keymap('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>', {})
	vim.api.nvim_set_keymap('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>', {})
	vim.api.nvim_set_keymap('n','gt','<cmd>lua vim.lsp.buf.type_definition()<CR>', {})
	vim.api.nvim_set_keymap('n','go','<cmd>ClangdSwitchSourceHeader<CR>', {})
	vim.api.nvim_set_keymap('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>', {})
	vim.api.nvim_set_keymap('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', {})
	vim.api.nvim_set_keymap('n','<leader>ah','<cmd>lua vim.lsp.buf.hover()<CR>', {})
	vim.api.nvim_set_keymap('n','<leader>af','<cmd>lua vim.lsp.buf.code_action()<CR>', {})
	vim.api.nvim_set_keymap('n','<leader>ee','<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', {})
	vim.api.nvim_set_keymap('n','<leader>ar','<cmd>lua vim.lsp.buf.rename()<CR>', {})
	vim.api.nvim_set_keymap('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>', {})
	vim.api.nvim_set_keymap('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>', {})
	vim.api.nvim_set_keymap('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', {})
end

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
       require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  },
  {
    { name = 'buffer' },
  })
})


local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function python_path_for_root(root_dir)
  local candidates = {
    root_dir .. "/.venv/bin/python",
    root_dir .. "/venv/bin/python",
    root_dir .. "/env/bin/python",
  }

  local active_env = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
  if active_env and active_env ~= "" then
    table.insert(candidates, active_env .. "/bin/python")
  end

  for _, candidate in ipairs(candidates) do
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end

  local pyenv = vim.fn.exepath("pyenv")
  if pyenv ~= "" then
    local result = vim.system({ pyenv, "which", "python" }, {
      cwd = root_dir,
      text = true,
    }):wait()
    local candidate = vim.trim(result.stdout or "")
    if result.code == 0 and candidate ~= "" and vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end

  for _, name in ipairs({ "python", "python3" }) do
    local candidate = vim.fn.exepath(name)
    if candidate ~= "" then
      return candidate
    end
  end
end

require("lspconfig").pyright.setup {
  on_attach = custom_attach,
  capabilities = capabilities,
  on_new_config = function(new_config, root_dir)
    local python_path = python_path_for_root(root_dir)
    if python_path then
      new_config.settings = new_config.settings or {}
      new_config.settings.python = new_config.settings.python or {}
      new_config.settings.python.pythonPath = python_path
    end
  end,
}
require'lspconfig'.clangd.setup{on_attach=custom_attach, capabilities=capabilities}
require'lspconfig'.rust_analyzer.setup{on_attach=custom_attach, capabilities=capabilities}

-- vim.g.loaded_coqtail = 1
-- vim.g.coqtail_supported = 0
require'coq-lsp'.setup{lsp = {on_attach=custom_attach, capabilities=capabilities} }

require('lean').setup{ mappings = true, lsp = {on_attach=custom_attach, capabilities=capabilities} }

require("flutter-tools").setup {
  lsp = {
    on_attach = custom_attach,
    capabilities = capabilities,
  }
}
