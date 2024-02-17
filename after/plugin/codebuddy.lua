local ok, cb = pcall(require, "codebuddy")
if not ok then return end

cb:setup {
    commands = {
        c = {
            build = "clang-17 -Wall -g -o {file} {file_path}",
            run = "./{file}"
        },
        cpp = {
            build = "clang++-17 -g -o {file} -std=c++2b -stdlib=libc++ {file_path}",
            run = "./{file}"
        },
        ex = {
            build = "mix compile",
            run = "iex -S mix"
        },
        erl = {
            build = "erlc -o out {file_path}",
            run = "erl -pa out"
        },
        py = {
            run = "python3 {file_path}"
        },
        rs = {
            build = "cargo build",
            run = "cargo run"
        },
        go = {
            build = "go build .",
            run = "go run ."
        },
        java = {
            build = "gradle build",
            run = "gradle run"
        },
    },

    term = {
        start_insert = false,
        no_number = true,
    },
}


vim.keymap.set("n", "<leader>rr", cb.run)
vim.keymap.set("n", "<leader>rc", cb.build)
