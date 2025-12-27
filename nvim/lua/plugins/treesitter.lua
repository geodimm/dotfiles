return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      local ts = require('nvim-treesitter')

      -- Enable treesitter for a buffer
      local function enable_treesitter(buf, lang)
        if not vim.api.nvim_buf_is_valid(buf) then
          return false
        end

        local ok = pcall(vim.treesitter.start, buf, lang)
        if ok then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end

        return ok
      end

      local group = vim.api.nvim_create_augroup('user_treesitter_setup', { clear = true })

      -- Install core parsers after lazy.nvim finishes loading all plugins
      vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = 'LazyDone',
        once = true,
        desc = 'Install core treesitter parsers',
        callback = function()
          ts.install({
            'bash',
            'css',
            'dockerfile',
            'git_config',
            'go',
            'gomod',
            'gosum',
            'gotmpl',
            'gowork',
            'hcl',
            'helm',
            'html',
            'http',
            'java',
            'javascript',
            'json',
            'json5',
            'jsonc',
            'jq',
            'kitty',
            'lua',
            'make',
            'markdown',
            'markdown_inline',
            'pem',
            'python',
            'regex',
            'ruby',
            'rust',
            'scss',
            'starlark',
            'ssh_config',
            'terraform',
            'toml',
            'typescript',
            'vim',
            'vimdoc',
            'xml',
            'yaml',
          }, {
            max_jobs = 8,
          })
        end,
      })

      -- Enable highlighting on FileType
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        desc = 'Enable treesitter highlighting and indentation',
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(event.match) or event.match
          local buf = event.buf

          enable_treesitter(buf, lang)
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true
    end,
    opts = {},
    config = function()
      local select = require('nvim-treesitter-textobjects.select')
      local swap = require('nvim-treesitter-textobjects.swap')
      local move = require('nvim-treesitter-textobjects.move')

      local keymap = require('utils.keymap')

      keymap.set({ 'x', 'o' }, 'af', function()
        select.select_textobject('@function.outer', 'textobjects')
      end)
      keymap.set({ 'x', 'o' }, 'if', function()
        select.select_textobject('@function.inner', 'textobjects')
      end)
      keymap.set({ 'x', 'o' }, 'ac', function()
        select.select_textobject('@class.outer', 'textobjects')
      end)
      keymap.set({ 'x', 'o' }, 'ic', function()
        select.select_textobject('@class.inner', 'textobjects')
      end)

      keymap.set({ 'n', 'x', 'o' }, ']m', function()
        move.goto_next_start('@function.outer', 'textobjects')
      end, { desc = 'Next function start' })
      keymap.set({ 'n', 'x', 'o' }, ']M', function()
        move.goto_next_end('@function.outer', 'textobjects')
      end, { desc = 'Next function end' })
      keymap.set({ 'n', 'x', 'o' }, '[m', function()
        move.goto_previous_start('@function.outer', 'textobjects')
      end, { desc = 'Previous function start' })
      keymap.set({ 'n', 'x', 'o' }, '[M', function()
        move.goto_previous_end('@function.outer', 'textobjects')
      end, { desc = 'Previous function end' })

      keymap.set({ 'n', 'x', 'o' }, ']]', function()
        move.goto_next_start('@class.outer', 'textobjects')
      end, { desc = 'Next class start' })
      keymap.set({ 'n', 'x', 'o' }, '][', function()
        move.goto_next_end('@class.outer', 'textobjects')
      end, { desc = 'Next class end' })
      keymap.set({ 'n', 'x', 'o' }, '[[', function()
        move.goto_previous_start('@class.outer', 'textobjects')
      end, { desc = 'Previous class start' })
      keymap.set({ 'n', 'x', 'o' }, '[]', function()
        move.goto_previous_end('@class.outer', 'textobjects')
      end, { desc = 'Previous class end' })

      keymap.set('n', '<leader>a', function()
        swap.swap_next('@parameter.inner')
      end, { desc = 'Swap next parameter' })
      keymap.set('n', '<leader>A', function()
        swap.swap_previous('@parameter.inner')
      end, { desc = 'Swap previous parameter' })
    end,
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
      {
        'gS',
        function()
          require('treesj').toggle()
        end,
        desc = 'Split or Join code block with autodetect',
      },
    },
    opts = {
      max_join_length = 2000,
      use_default_keymaps = false,
    },
  },
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = true,
  },
}
