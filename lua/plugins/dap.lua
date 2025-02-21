local configs = {}
local function mk_config(type)
  return {
    {
      name = "Launch",
      type = type,
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = function()
        local input = vim.fn.input("args: ")
        return vim.split(input, " ")
      end
    },
  }
end

configs.codelldb = mk_config("codelldb")
configs.gdb = mk_config("gdb")
configs.rust_gdb = mk_config("rust_gdb")

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      -- requires gdb 14 or higher
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" },
      }

      dap.adapters.rust_gdb = {
        type = "executable",
        command = "rust-gdb",
        args = { "-i", "dap" },
      }

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",

        executable = {
          command = "codelldb",
          args = { "--port", "${port}" },
        },

        lldb = {
          showDisassembly = "never",
        },

      }


      dap.adapters.debugpy = function(cb, config)
        if config.request == "attach" then
          ---@diagnostic disable-next-line: undefined-field
          local port = (config.connect or config).port
          ---@diagnostic disable-next-line: undefined-field
          local host = (config.connect or config).host or "127.0.0.1"
          cb({
            type = "server",
            port = assert(port, "`connect.port` is required for a python `attach` configuration"),
            host = host,
            options = {
              source_filetype = "python",
            },
          })
        else
          cb({
            type = "executable",
            command = "python3",
            args = { "-m", "debugpy.adapter" },
            options = {
              source_filetype = "python",
            },
          })
        end
      end


      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
          command = "delve",
          args = { "dap", "-l", "127.0.0.1:${port}" },
        }
      }

      dap.configurations.c = configs.codelldb
      dap.configurations.cpp = configs.codelldb
      dap.configurations.rust = configs.codelldb


      dap.configurations.python = {
        {
          type = "debugpy",
          request = "launch",
          name = "Launch file",

          program = "${file}",
          pythonPath = "python3",
        },
      }


      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug",
          request = "launch",
          program = "${file}"
        },
        {
          type = "delve",
          name = "Debug test",
          request = "launch",
          mode = "test",
          program = "${file}"
        },
        {
          type = "delve",
          name = "Debug test (go.mod)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}"
        }
      }

      vim.keymap.set("n", "<F5>", dap.continue)
      vim.keymap.set("n", "<F10>", dap.step_over)
      vim.keymap.set("n", "<F11>", dap.step_into)
      vim.keymap.set("n", "<F12>", dap.step_out)
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>dr", dap.repl.open)
      vim.keymap.set("n", "<leader>dt", dapui.toggle)
    end
  }
}
