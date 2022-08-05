local status_ok, alpha = pcall(require, 'alpha')
if not status_ok then
  return
end

local startify = require('alpha.themes.startify')
local fortune = require('alpha.fortune')

local logo = {
  type = 'text',
  val = {
    '                                                    ',
    ' ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
    ' ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
    ' ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
    ' ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
    ' ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
    ' ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
  },
  opts = {
    position = 'left',
    hl = 'Function',
  },
}

local message = {
  type = 'text',
  val = fortune({ max_width = 60 }),
  opts = {
    position = 'left',
    hl = 'Statement',
  },
}

local header = {
  type = 'group',
  val = {
    logo,
    message,
  },
}

local mru = {
  type = 'group',
  val = {
    {
      type = 'text',
      val = 'Recent files',
      opts = {
        hl = 'String',
        shrink_margin = false,
        position = 'left',
      },
    },
    { type = 'padding', val = 1 },
    {
      type = 'group',
      val = function()
        return { startify.mru(1, vim.fn.getcwd(), 5) }
      end,
    },
  },
}

local buttons = {
  type = 'group',
  val = {
    {
      type = 'text',
      val = 'Actions',
      opts = {
        hl = 'String',
        shrink_margin = false,
        position = 'left',
      },
    },
    { type = 'padding', val = 1 },
    startify.button('e', '  New file', ':ene <BAR> startinsert<CR>'),
    startify.button('f', '  Find file', "<cmd>lua require('telescope.builtin').find_files()<CR>"),
    startify.button('a', '  Live grep', "<cmd>lua require('telescope.builtin').live_grep({shorten_path=true})<CR>"),
    startify.button(
      'd',
      '  Dotfiles',
      "<cmd>lua require('telescope.builtin').find_files({ search_dirs = { os.getenv('HOME') .. '/dotfiles' } })<CR>"
    ),
    startify.button('u', '  Update plugins', ':PackerSync<CR>'),
    startify.button('q', '  Quit', ':qa<CR>'),
  },
  opts = {
    position = 'left',
  },
}

local config = {
  layout = {
    header,
    { type = 'padding', val = 1 },
    mru,
    { type = 'padding', val = 1 },
    buttons,
  },
  opts = {
    setup = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'AlphaReady',
        desc = 'disable lualine for alpha',
        callback = function()
          local ok, lualine = pcall(require, 'lualine')
          if ok then
            lualine.hide({})
            vim.go.laststatus = 0
          end
        end,
      })
      vim.api.nvim_create_autocmd('BufUnload', {
        buffer = 0,
        desc = 'enable lualine after alpha',
        callback = function()
          local ok, lualine = pcall(require, 'lualine')
          if ok then
            vim.go.laststatus = 2
            lualine.hide({ unhide = true })
          end
        end,
      })
    end,
    margin = 5,
  },
}

alpha.setup(config)
