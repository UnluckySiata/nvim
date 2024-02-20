local ok, cb = pcall(require, "codebuddy")
if not ok then return end

local commands = {
    c = {
        build = "clang-17 -Wall -g -o {file} {file_path}",
        run = "./{file}"
    },
    cpp = {
        build = "clang++-17 -g -o {file} -std=c++2b -stdlib=libc++ {file_path}",
        run = "./{file}",
        xd = "./{file}"
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
}

cb:setup {
    actions = {
        { name = "run",   keybind = { mode = "n", binding = "<leader>rr" } },
        { name = "build", keybind = { mode = "n", binding = "<leader>rc" } },
    },
    commands = commands,

    term = {
        no_number = true,
    },
}
