local commands = {
  c = {
    build = "gcc -Wall -g -o {file} {file_path}",
    run = "./{file}"
  },
  cpp = {
    build = "g++ -Wall -g -o {file} -std=c++23 {file_path}",
    run = "./{file}",
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
    build = "go build ./{relative_dir}",
    run = "go run ./{relative_dir}"
  },
  java = {
    build = "gradle build",
    run = "gradle run"
  },
}

return {
  {
    "unluckysiata/codebuddy.nvim",
    config = function()
      require("codebuddy"):setup {
        actions = {
          { name = "run",   keybind = { mode = "n", binding = "<leader>rr" } },
          { name = "build", keybind = { mode = "n", binding = "<leader>rc" } },
        },
        commands = commands,

        local_cfg_file = ".nv/actions.lua",

        term = {
          no_number = true,
        },
      }
    end
  }
}
