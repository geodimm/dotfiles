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
    hl = 'DevIconVim',
  },
}

local function info_value()
  local total_plugins = #vim.tbl_keys(packer_plugins)
  local datetime = os.date(' %d-%m-%Y')
  local version = vim.version()
  local nvim_version_info = '   v' .. version.major .. '.' .. version.minor .. '.' .. version.patch

  return '        ' .. datetime .. '   ' .. total_plugins .. ' plugins' .. nvim_version_info
end

local info = {
  type = 'text',
  val = info_value(),
  opts = {
    hl = 'DevIconVim',
    position = 'left',
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
    info,
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
        desc = 'disable status, tabline and cmdline for alpha',
        callback = function()
          vim.go.laststatus = 0
          vim.opt.showtabline = 0
          vim.opt.cmdheight = 0
        end,
      })
      vim.api.nvim_create_autocmd('BufUnload', {
        buffer = 0,
        desc = 'enable status, tabline and cmdline after alpha',
        callback = function()
          vim.go.laststatus = 3
          vim.opt.showtabline = 2
          vim.opt.cmdheight = 1
        end,
      })
    end,
    margin = 5,
  },
}

alpha.setup(config)
