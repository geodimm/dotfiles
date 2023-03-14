return {
  {
    'mfussenegger/nvim-dap',
    build = {
      'go install github.com/go-delve/delve/cmd/dlv@latest',
    },
    init = function()
      local texthl = {
        DapBreakpoint = 'DapBreakpoint',
        DapBreakpointCondition = 'DapBreakpointCondition',
        DapBreakpointRejected = 'DapBreakpoint',
        DapLogPoint = 'DapLogPoint',
        DapStopped = 'DapStopped',
      }
      local icons = require('user.icons')
      for type, icon in pairs(icons.dap) do
        vim.fn.sign_define(type, { text = icon, texthl = texthl[type], linehl = '', numhl = '' })
      end

      local keymap = require('utils.keymap')
      keymap.register_group('<leader>d', 'Debug', {})
    end,
    events = { 'CmdlineEnter' },
    ft = { 'go' },
    keys = {
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle breakpoint',
      },
      {
        '<leader>dc',
        function()
          require('dap').continue()
        end,
        desc = 'Continue',
      },
      {
        '<leader>di',
        function()
          require('dap').step_into()
        end,
        desc = 'Step into',
      },
      {
        '<leader>do',
        function()
          require('dap').step_out()
        end,
        desc = 'Step out',
      },
      {
        '<leader>dn',
        function()
          require('dap').step_over()
        end,
        desc = 'Step over',
      },
      {
        '<leader>dp',
        function()
          require('dap').step_back()
        end,
        desc = 'Step back',
      },
    },
    config = function()
      local dap = require('dap')
      dap.adapters.delve = {
        type = 'server',
        port = '${port}',
        executable = {
          command = 'dlv',
          args = { 'dap', '-l', '127.0.0.1:${port}' },
        },
      }

      dap.configurations.go = {
        {
          type = 'delve',
          name = 'Debug',
          request = 'launch',
          program = '${file}',
        },
        {
          type = 'delve',
          name = 'Debug test',
          request = 'launch',
          mode = 'test',
          program = './${relativeFileDirname}',
        },
      }
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    keys = {
      {
        '<leader>dd',
        function()
          require('dapui').toggle()
        end,
        desc = 'Toggle UI',
      },
      {
        '<leader>dh',
        function()
          require('dapui').eval(nil, {})
        end,
        mode = { 'n', 'v' },
        desc = 'Hover',
      },
    },
    opts = {
      floating = {
        border = 'rounded',
      },
    },
  },
}
