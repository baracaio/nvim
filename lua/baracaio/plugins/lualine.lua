return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
        else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
        end
    end,
    opts = function()
        -- PERF: we don't need this lualine require madness 🤷
        local lualine_require = require("lualine_require")
        lualine_require.require = require

        vim.o.laststatus = vim.g.lualine_laststatus

        local opts = {
        options = {
            theme = "auto",
            globalstatus = vim.o.laststatus == 3,
            disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch" },

            lualine_c = {
                { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                
            },

            lualine_y = {
                { "progress", separator = " ", padding = { left = 1, right = 0 } },
                { "location", padding = { left = 0, right = 1 } },
            },
            lualine_z = {
            function()
                return " " .. os.date("%R")
            end,
            },
        },
        extensions = { "neo-tree", "lazy" },
        }

        -- do not add trouble symbols if aerial is enabled
        -- And allow it to be overriden for some buffer types (see autocmds)
        if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
        local trouble = require("trouble")
        local symbols = trouble.statusline({
            mode = "symbols",
            groups = {},
            title = false,
            filter = { range = true },
            format = "{kind_icon}{symbol.name:Normal}",
            hl_group = "lualine_c_normal",
        })
        table.insert(opts.sections.lualine_c, {
            symbols and symbols.get,
            cond = function()
            return vim.b.trouble_lualine ~= false and symbols.has()
            end,
        })
        end

        return opts
    end,
}