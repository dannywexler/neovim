return {
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        vim.opt.termguicolors = true
        local fn = vim.fn
        local feline = require 'feline'
        fn.setreg('/', 'wxyz')
        local myColors = require('d.colors')
        local icons = require('d.icons')

        local winbarColors = {
            active = myColors.green.bright,
            inactive = myColors.blue.bright,
        }

        local diagnosticColors = {
            error = myColors.red.medium,
            hint = myColors.green.medium,
            info = myColors.teal,
            warn = myColors.orange.bright
        }

        local vim_mode_colors = {
            i = myColors.green.medium,
            n = myColors.blue.bright,
            v = myColors.purple.medium,
            V = myColors.purple.medium,
        }

        local fileTypeMap = {
            DiffviewFiles = ' DIFF  ',
            NvimTree = ' File Tree 󰙅 ',
            TelescopePrompt = ' Telescope  ',
            toggleterm = ' TERMINAL  ',
        }

        local spinners = {
            '•     ',
            '••    ',
            '•••   ',
            ' •••  ',
            '  ••• ',
            '   •••',
            '    ••',
            '     •',
            '      ',
        }

        local winbarHighlights = {
            active = {
                fg = myColors.black,
                bg = winbarColors.active,
                style = 'bold'
            },
            inactive = {
                fg = myColors.black,
                bg = winbarColors.inactive,
                style = 'bold'
            }
        }

        local Highlights = {
            vi_mode = function()
                return {
                    fg = "#000000",
                    bg = vim_mode_colors[vim.fn.mode()] or myColors.orange.medium,
                    style = 'bold'
                }
            end,
            default = function()
                return {
                    fg = myColors.white,
                    bg = myColors.grey.dark
                }
            end
        }

        local diagnosticCompUpdate = { 'CursorHold' }

        local function normalize(sourceString)
            return fn.fnamemodify(sourceString, ':gs?\\?/?')
        end

        local Funcs = {
            getFolder           = function() return normalize(fn.fnamemodify(fn.getcwd(), ':~')) end,
            getParentPath       = function()
                -- print("getting parentPath for buf:", fn.bufnr())
                return normalize(fn.fnamemodify(fn.getcwd(), ':~:h'))
            end,
            getCwd              = function() return fn.fnamemodify(fn.getcwd(), ':t') end,
            getFileRelativePath = function()
                local relativePath = normalize(fn.expand('%:.:h'))
                if relativePath == '.' then return '' end
                return relativePath
            end,
            getFileName         = function()
                -- print("getting filename for buf:", fn.bufnr())
                return fileTypeMap[vim.bo.filetype] or fn.expand('%:t')
            end,
            getWinbarFileName   = function()
                -- print('getting winbar filename for buf ' .. fn.bufnr() .. ' ' .. os.date('%S'))
                local fileName = fn.expand('%:t')
                if fileName == 'NvimTree_1' then
                    return normalize(fn.fnamemodify(fn.getcwd(), ':~'))
                end
                -- if fileName:find('toggleterm') then
                --     return 'TERMINAL  '
                -- end
                return fileName
            end,
            lineAndCol          = function()
                local bars = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
                local currentLine = vim.fn.line('.')
                local totalLines = vim.fn.line('$')
                local currentCol = vim.fn.col('.')
                local bar = bars[math.floor((currentLine - 1) / totalLines * #bars) + 1]
                return ('%s%s %3s/%s | %3s '):format(bar, bar, currentLine, totalLines, currentCol)
                -- return (' C: %3s  L: %3s/%s '):format(currentCol, currentLine, totalLines)
            end,
            -- getBuildStatus      = function()
            --     local result = BuildStatus
            --     if BuildStatus == 'finished' then
            --         result = 'Build finished'
            --     elseif BuildStatus == 'in_progress' then
            --         result = 'Building ' .. spinners[os.date('%S') % #spinners + 1]
            --     end
            --     return result .. ' '
            -- end,
            getDiagnostics      = function(_, opts)
                local level = opts.level
                -- print('getting diagnostics for level:', level, 'for buf:', fn.bufnr())
                local severity = vim.diagnostic.severity[level:upper()]
                local count = vim.tbl_count(vim.diagnostic.get(0, { severity = severity }))
                if count == 0 then return '' end
                return (' %s %s'):format(count, icons.diagnostics[level])
            end,
            getFileIcon         = function()
                local icon = icons.current()
                return icon
            end,
            getFileIconColor    = function()
                local _, color = icons.current()
                return color or myColors.white
            end,
            half_dome_left      = function() return icons.bonus.left_half_dome end,
            half_dome_right     = function() return icons.bonus.right_half_dome end,
            formatSearchResults = function()
                local searchText = fn.getreg('/')
                if searchText == 'wxyz' then return '' end
                if vim.startswith(searchText, '\\<') and vim.endswith(searchText, '\\>') then
                    searchText = searchText:sub(3, #searchText - 2)
                end
                local searchCount = fn.searchcount({ maxcount = 0 })
                -- return ('%s match %2s of %s'):format(searchText, searchCount.current, searchCount.total)
                return ('%s match %2s/%s'):format(searchText, searchCount.current, searchCount.total)
            end,
            -- navic               = function()
            --     return '  ' .. require 'nvim-navic'.get_location()
            -- end,
            vimMode             = function()
                return vim.fn.mode():sub(1, 1):upper()
            end,
        }

        local function sideifyAComp(compConfig, leftOrRight, toRound)
            -- print('sideifyAComp', toRound)
            local spacer = { str = ' ', hl = Highlights.default }
            local sideConfig = {}
            if toRound then
                sideConfig.hl = Highlights.vi_mode
                if leftOrRight == 'left' then
                    sideConfig = {
                        left_sep = 'left_rounded',
                        right_sep = { 'right_rounded', spacer }
                    }
                else
                    sideConfig = {
                        left_sep = { spacer, 'left_rounded' },
                        right_sep = 'right_rounded'
                    }
                end
            else
                if leftOrRight == 'left' then
                    sideConfig = { right_sep = spacer }
                else
                    sideConfig = { left_sep = spacer }
                end
            end
            local mergedConfig = U.merge(compConfig, sideConfig)
            -- print("merged config:", vim.inspect(mergedConfig))
            return mergedConfig
        end

        local function takeASide(compConfigTable, leftOrRight)
            local mergedTable = {}
            for _, compConfig in ipairs(compConfigTable) do
                local newComp = compConfig
                if compConfig.rounded then
                    newComp.hl = Highlights.vi_mode
                    newComp = sideifyAComp(newComp, leftOrRight, true)
                else
                    newComp = sideifyAComp(newComp, leftOrRight, false)
                end
                table.insert(mergedTable, newComp)
            end
            -- print('takeASide mergedTable', vim.inspect(mergedTable))
            return mergedTable
        end

        local Comps = {
            -- buildStatus = {
            --     provider = 'getBuildStatus',
            --     hl = function()
            --         local fgColor = myColors.red.bright
            --
            --         if BuildStatus == 'finished' then
            --             fgColor = myColors.green.medium
            --         elseif BuildStatus == 'in_progress' then
            --             fgColor = myColors.orange.bright
            --         end
            --
            --         return {
            --             fg = fgColor,
            --             -- bg = '#000000',
            --         }
            --     end,
            --     enabled = function()
            --         return WINDOWS and fn.getcwd():find('bit9prog') and fn.getcwd():find('code')
            --     end,
            -- },
            diagComp = function(severity)
                return {
                    provider = {
                        name = 'getDiagnostics',
                        opts = { level = severity },
                        update = diagnosticCompUpdate
                    },
                    hl = {
                        fg = diagnosticColors[severity],
                        bg = myColors.grey.dark,
                        style = 'bold'
                    },
                    enabled = require('feline.providers.lsp').diagnostics_exist,
                }
            end,
            diagSpacer = function(onLeft, tive)
                return {
                    provider = {
                        name = onLeft and 'half_dome_left' or 'half_dome_right',
                        update = diagnosticCompUpdate,
                    },
                    hl = {
                        fg = myColors.grey.dark,
                        bg = winbarColors[tive],
                    },
                    enabled = require('feline.providers.lsp').diagnostics_exist,
                }
            end,
            gap = function(hl)
                return {
                    provider = ' ',
                    hl = hl or Highlights.default,
                }
            end,
            getParentPath = {
                provider = { name = 'getParentPath', update = { 'VimEnter' } },
                rounded = true,
            },
            getCwd = {
                provider = { name = 'getCwd', update = { 'VimEnter' } },
                rounded = true,
            },
            getFileRelativePath = {
                provider = { name = 'getFileRelativePath', update = { 'BufEnter' } },
                rounded = true,
            },
            getFileIcon = {
                provider = { name = 'getFileIcon', update = { 'BufEnter' } },
                hl = function()
                    return {
                        fg = Funcs.getFileIconColor(),
                    }
                end,
                enabled = function() return #vim.bo.buftype == 0 end,
            },
            getFileName = {
                provider = { name = 'getFileName', update = { 'BufEnter' } },
                rounded = true,
            },
            -- navic = {
            --     provider = 'navic',
            --     enabled = require 'nvim-navic'.is_available,
            --     hl = {
            --         bg = myColors.grey.dark
            --     }
            -- },
            searchResults = {
                provider = 'formatSearchResults',
                rounded = true
            },
            vimMode = {
                provider = { name = 'vimMode', update = { 'ModeChanged' } },
                rounded = true
            },
        }

        local activeLeft = {
            Comps.getParentPath,
            Comps.getCwd,
            Comps.getFileRelativePath,
            Comps.getFileName,
            Comps.getFileIcon,
            -- Comps.navic,
        }

        local activeRight = {
            -- Comps.buildStatus,
            Comps.searchResults,
            Comps.vimMode,
        }

        local inactiveLeft = {
            Comps.getParentPath,
            Comps.getCwd,
            Comps.getFileName,
        }

        -- local testCompResult = colorifyAComp

        feline.setup {
            default_bg = myColors.grey.dark,
            default_fg = myColors.white,
            components = {
                active = {
                    takeASide(activeLeft, 'left'),
                    takeASide(activeRight, 'right'),
                },
                inactive = {
                    takeASide(inactiveLeft, 'left')
                }
            },
            custom_providers = Funcs,
            force_inactive = {
                filetypes = {
                    '^NvimTree$',
                    '^toggleterm$',
                    '^DiffviewFiles$',
                    '^TelescopePrompt$'
                }
            },
            separators = {
                right_sep = 'right_rounded',
                left_sep = 'left_rounded',
            },
            theme = {
                fg = myColors.white,
                bg = myColors.grey.dark,
            },
        }

        -- WINBAR CONFIG BELOW HERE:


        local function winbarComps(tive)
            return {
                {
                    Comps.gap(winbarHighlights[tive]),
                    {
                        provider = { name = 'getFileIcon', update = { 'BufEnter' } },
                        hl = winbarHighlights[tive],
                        enabled = function() return #vim.bo.buftype == 0 end,
                    },
                    Comps.gap(winbarHighlights[tive]),
                    {
                        provider = { name = 'getWinbarFileName', update = { 'BufEnter' } },
                        hl = winbarHighlights[tive],
                    },
                    Comps.gap(winbarHighlights[tive]),
                    Comps.gap(winbarHighlights[tive]),
                    Comps.diagSpacer(true, tive),
                    Comps.diagComp('error'),
                    Comps.diagComp('warn'),
                    Comps.diagComp('info'),
                    Comps.diagComp('hint'),
                    Comps.diagSpacer(false, tive),
                    Comps.gap(winbarHighlights[tive]),
                },
                {
                    {
                        provider = 'lineAndCol',
                        hl = winbarHighlights[tive],
                        enabled = function() return #vim.bo.buftype == 0 end
                    },
                },
            }
        end

        feline.winbar.setup {
            components = {
                active = winbarComps('active'),
                inactive = winbarComps('inactive'),
            },
            disable = {
                buftypes = {
                    '^terminal$'
                },
                filetypes = {
                    '^toggleterm$'
                }
            },
        }
    end
}
