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
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/MunifTanjim/nui.nvim',
    'https://github.com/Bilal2453/luvit-meta',
    'https://github.com/rafamadriz/friendly-snippets',
    'https://github.com/b0o/schemastore.nvim',
    { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
    'https://github.com/folke/snacks.nvim',
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
    'https://github.com/Wansmer/treesj',
    'https://github.com/lewis6991/async.nvim',
    'https://github.com/ThePrimeagen/refactoring.nvim',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
    'https://github.com/bfontaine/Brewfile.vim',
    'https://github.com/olexsmir/gopher.nvim',
    'https://github.com/OXY2DEV/markview.nvim',
    'https://github.com/iamcco/markdown-preview.nvim',
    'https://github.com/fabridamicelli/cronex.nvim',
    'https://github.com/folke/lazydev.nvim',
    'https://github.com/xzbdmw/colorful-menu.nvim',
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.*') },
    'https://github.com/folke/noice.nvim',
    'https://github.com/folke/which-key.nvim',
    'https://github.com/folke/trouble.nvim',
    'https://github.com/MagicDuck/grug-far.nvim',
    'https://github.com/nvim-mini/mini.indentscope',
    'https://github.com/nvim-mini/mini.ai',
    'https://github.com/nvim-mini/mini.surround',
    'https://github.com/nvim-mini/mini.align',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/antosha417/nvim-lsp-file-operations',
    'https://github.com/nvim-tree/nvim-tree.lua',
    'https://github.com/stevearc/conform.nvim',
    'https://github.com/mfussenegger/nvim-lint',
    'https://github.com/geodimm/lint-actions.nvim',
    'https://github.com/ibhagwan/fzf-lua',
    'https://github.com/hoob3rt/lualine.nvim',
    'https://github.com/tpope/vim-fugitive',
    'https://github.com/sindrets/diffview.nvim',
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/johnseth97/codex.nvim',
    'https://github.com/mrjones2014/smart-splits.nvim',
    'https://github.com/geodimm/ghostty-smart-splits.nvim',
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
