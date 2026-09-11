-- vim.pack: install and load all plugins, then run user/pack_config.lua
local M = {}

local function opt_path(name)
  return vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt', name)
end

vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'vim.pack post-install: TSUpdate, yarn',
  callback = function(ev)
    local d = ev.data
    if not d or not d.spec or not d.kind then
      return
    end
    local name, kind = d.spec.name, d.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end

    if name == 'nvim-treesitter' then
      if not d.active then
        pcall(vim.cmd, 'packadd nvim-treesitter')
      end
      pcall(vim.cmd, 'TSUpdate')
      return
    end

    if kind == 'install' and name == 'markdown-preview.nvim' then
      local p = opt_path('markdown-preview.nvim')
      if vim.uv.fs_stat(p) then
        vim.system({ 'sh', '-c', 'cd app && yarn install' }, { cwd = p }):wait()
      end
      return
    end
  end,
})

---@return unknown[]
function M.plugin_specs()
  return {
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
    { src = 'https://github.com/MunifTanjim/nui.nvim' },
    { src = 'https://github.com/Bilal2453/luvit-meta' },
    { src = 'https://github.com/rafamadriz/friendly-snippets' },
    { src = 'https://github.com/b0o/schemastore.nvim' },
    { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
    { src = 'https://github.com/folke/snacks.nvim' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
    { src = 'https://github.com/Wansmer/treesj' },
    { src = 'https://github.com/lewis6991/async.nvim' },
    { src = 'https://github.com/ThePrimeagen/refactoring.nvim' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
    { src = 'https://github.com/bfontaine/Brewfile.vim' },
    { src = 'https://github.com/olexsmir/gopher.nvim' },
    { src = 'https://github.com/OXY2DEV/markview.nvim' },
    { src = 'https://github.com/iamcco/markdown-preview.nvim' },
    { src = 'https://github.com/fabridamicelli/cronex.nvim' },
    { src = 'https://github.com/folke/lazydev.nvim' },
    { src = 'https://github.com/xzbdmw/colorful-menu.nvim' },
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.*') },
    { src = 'https://github.com/folke/noice.nvim' },
    { src = 'https://github.com/folke/which-key.nvim' },
    { src = 'https://github.com/folke/trouble.nvim' },
    { src = 'https://github.com/MagicDuck/grug-far.nvim' },
    { src = 'https://github.com/nvim-mini/mini.indentscope' },
    { src = 'https://github.com/nvim-mini/mini.ai' },
    { src = 'https://github.com/nvim-mini/mini.surround' },
    { src = 'https://github.com/nvim-mini/mini.align' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/antosha417/nvim-lsp-file-operations' },
    { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
    { src = 'https://github.com/stevearc/conform.nvim' },
    { src = 'https://github.com/mfussenegger/nvim-lint' },
    { src = 'https://github.com/geodimm/lint-actions.nvim' },
    { src = 'https://github.com/ibhagwan/fzf-lua' },
    { src = 'https://github.com/hoob3rt/lualine.nvim' },
    { src = 'https://github.com/tpope/vim-fugitive' },
    { src = 'https://github.com/sindrets/diffview.nvim' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    { src = 'https://github.com/johnseth97/codex.nvim' },
    { src = 'https://github.com/smart-splits-nvim/smart-splits.nvim', version = 'v3' },
    { src = 'https://github.com/smart-splits-nvim/backend-ghostty', version = vim.version.range('0.0.0 - 1.0.0') },
  }
end

function M.setup()
  vim.pack.add(M.plugin_specs(), { confirm = false })
  require('user.pack_config')()
  -- One-shot ms from first line of `init.lua` to here (dashboard must not recompute live).
  local t0 = vim.g._nvim_start_hrtime_ms
  if t0 then
    vim.g._nvim_pack_startup_ms = vim.uv.hrtime() / 1e6 - t0
  end
end

return M
