local status, noice = pcall(require, "noice")
if (not status) then return end

noice.setup({
    cmdline = {
        format = {
            search_down = { icon = "" },
            search_up   = { icon = "" },
        }
    },
    messages = {
        view = "mini"
    },
    views = {
        popupmenu = {
            relative = "editor",
            position = {
                row = "63%",
                col = "50%",
            },
            size = {
                width = 60,
                height = 10,
            },
            border = {
                style = "rounded",
                padding = { 0, 1 },
            },
            win_options = {
                winhighlight = {
                    Normal = "Normal",
                    FloatBorder = "DiagnosticInfo",
                },
            },
        },
    },
})
