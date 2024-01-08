local ok, dap = pcall(require, "dap")
if not ok then return end

local dapui = require("dapui")
local dapvt = require("nvim-dap-virtual-text")
dapui.setup()
dapvt.setup {}


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
        command = vim.fn.stdpath "data" .. "/mason/packages/codelldb/extension/adapter/codelldb",
        args = { "--port", "${port}" },
    },

    lldb = {
        showDisassembly = "never",
    },

}


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


dap.configurations.c = configs.codelldb
dap.configurations.cpp = configs.codelldb
dap.configurations.rust = configs.codelldb


vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<F12>", dap.step_out)
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>dr", dap.repl.open)
vim.keymap.set("n", "<leader>dt", dapui.toggle)
vim.keymap.set("n", "<leader>dv", ":DapVirtualTextToggle<CR>", { silent = true })
