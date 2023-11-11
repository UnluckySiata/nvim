local ok, dap = pcall(require, "dap")
if not ok then return end

local dapui = require("dapui")
local dapvt = require("nvim-dap-virtual-text")
dapui.setup()
dapvt.setup { }

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",

    executable = {
        command = vim.fn.stdpath "data" .. "/mason/packages/codelldb/extension/adapter/codelldb",
        args = {"--port", "${port}"},
    },

    lldb = {
        showDisassembly = "never",
    },

}

dap.adapters.c = dap.adapters.codelldb
dap.adapters.cpp = dap.adapters.codelldb
dap.adapters.rust = dap.adapters.codelldb

dap.configurations.c = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = function ()
        local input = vim.fn.input("args: ")
        return vim.split(input, " ")
    end
  },
}

dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c

vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<F12>", dap.step_out)
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>dr", dap.repl.open)
vim.keymap.set("n", "<leader>dt", dapui.toggle)
vim.keymap.set("n", "<leader>dv", ":DapVirtualTextToggle<CR>", { silent = true })

