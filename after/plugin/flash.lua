local ok, flash = pcall(require, "flash")
if not ok then return end

flash.setup()

vim.keymap.set({ "n" }, "<leader>'", function()
    require("flash").jump({
        pattern = ".", -- initialize pattern with any char
        search = {
            mode = function(pattern)
                -- remove leading dot
                if pattern:sub(1, 1) == "." then
                    pattern = pattern:sub(2)
                end
                -- return word pattern and proper skip pattern
                return ([[\v<%s\w*>]]):format(pattern), ([[\v<%s]]):format(pattern)
            end,
        },
        -- select the range
        jump = { pos = "range" },
    })
end)

vim.keymap.set({ "n", "x", "o" }, "s", flash.jump)
vim.keymap.set({ "n", "x", "o" }, "S", flash.treesitter)
vim.keymap.set({ "o" }, "r", flash.remote)
vim.keymap.set({ "o", "x" }, "R", flash.treesitter_search)
vim.keymap.set({ "c" }, "<c-s>", flash.toggle)
