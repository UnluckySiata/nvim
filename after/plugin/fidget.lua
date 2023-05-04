local ok, fidget = pcall(require, "fidget")
if not ok then return end

fidget.setup({
    text = {
        spinner = "moon",
    },
    window = {
        blend = 0,
        -- border = "rounded",
        relative = "editor",
    }
})
