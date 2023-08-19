local ok, comment = pcall(require, "Comment")
if not ok then return end

comment.setup {
    toggler = {
        line = "zcc",
        block = "zbc"
    },

    opleader = {
        line = "zc",
        block = "zb"
    },

    extra = {
        above = "zcO",
        below = "zco",
        eol = "zca"
    }
}
