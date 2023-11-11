local ok, cb = pcall(require, "codebuddy")
if not ok then return end

cb.setup {
    commands = {
        c = {
            build = "clang -Wall -g -o {file} {file}.{ext}",
            run = "./{file}"
        },
        cpp = {
            build = "clang++ -g -o {file} -std=c++20 {file}.{ext}",
            run = "./{file}"
        },
        elixir = {
            build = "mix compile",
            run = "iex -S mix"
        },
        erlang = {
            build = "erlc -o out {file}.{ext}",
            run = "erl -pa out"
        },
        python = {
            run = "python3 {file}.{ext}"
        },
        rust = {
            build = "cargo build",
            run = "cargo run"
        },
        java = {
            build = "gradle build",
            run = "gradle run"
        },
    }

}

vim.keymap.set("n", "<leader>rr", cb.run)
vim.keymap.set("n", "<leader>ra", cb.run_vsplit_args)
vim.keymap.set("n", "<leader>rv", cb.run_vsplit)
vim.keymap.set("n", "<leader>rs", cb.run_split)
vim.keymap.set("n", "<leader>rc", cb.build)
