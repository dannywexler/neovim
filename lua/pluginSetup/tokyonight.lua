import({ 'tokyonight' }, function(p)
    p.tokyonight.setup {
        styles = {
            comments = { italic = false },
            keywords = { italic = false, bold = true },
        }
    }
end)

vim.cmd.colorscheme('tokyonight')
