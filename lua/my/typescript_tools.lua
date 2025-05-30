return PLUG("pmizio/typescript-tools.nvim", {
    dependencies = { PLUG("neovim/nvim-lspconfig") },
    opts = {
        settings = {
            -- spawn additional tsserver instance to calculate diagnostics on it
            separate_diagnostic_server = true,
            -- "change"|"insert_leave" determine when the client asks the server about diagnostic
            publish_diagnostic_on = "insert_leave",
            -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
            -- "remove_unused_imports"|"organize_imports") -- or string "all"
            -- to include all supported code actions
            -- specify commands exposed as code_actions
            expose_as_code_action = "all",
            -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
            -- not exists then standard path resolution strategy is applied
            tsserver_path = nil,
            -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
            -- (see 💅 `styled-components` support section)
            tsserver_plugins = {},
            -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
            -- memory limit in megabytes or "auto"(basically no limit)
            tsserver_max_memory = "auto",
            -- https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3439
            -- Can use filetype param to set options
            tsserver_file_preferences = function(_)
                return {
                    allowIncompleteCompletions = true,
                    allowRenameOfImportPath = true,
                    allowTextChangesInNewFiles = true,
                    disableLineTextInReferences = true,
                    displayPartsForJSDoc = true,
                    generateReturnInDocTemplate = true,
                    importModuleSpecifierEnding = "auto",
                    includeAutomaticOptionalChainCompletions = true,
                    includeCompletionsForImportStatements = true,
                    includeCompletionsWithClassMemberSnippets = true,
                    includeCompletionsWithObjectLiteralMethodSnippets = true,
                    includeCompletionsWithSnippetText = true,
                    includeInlayEnumMemberValueHints = false,
                    includeInlayFunctionLikeReturnTypeHints = false,
                    includeInlayFunctionParameterTypeHints = false,
                    includeInlayParameterNameHints = "none",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayPropertyDeclarationTypeHints = false,
                    includeInlayVariableTypeHints = false,
                    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                    jsxAttributeCompletionStyle = "auto",
                    providePrefixAndSuffixTextForRename = true,
                    provideRefactorNotApplicableReason = true,
                    quotePreference = "double",
                    useLabelDetailsInCompletionEntries = true,
                }
            end,
            -- https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3418
            -- Can use filetype param to set options
            tsserver_format_options = function(_)
                return {
                    indentSwitchCase = true,
                    insertSpaceAfterCommaDelimiter = true,
                    insertSpaceAfterConstructor = false,
                    insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
                    insertSpaceAfterKeywordsInControlFlowStatements = true,
                    insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
                    insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
                    insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
                    insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
                    insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
                    insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
                    insertSpaceAfterSemicolonInForStatements = true,
                    insertSpaceAfterTypeAssertion = false,
                    insertSpaceBeforeAndAfterBinaryOperators = true,
                    insertSpaceBeforeFunctionParenthesis = false,
                    placeOpenBraceOnNewLineForControlBlocks = false,
                    placeOpenBraceOnNewLineForFunctions = false,
                    semicolons = "ignore",
                }
            end,
            -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
            complete_function_calls = false,
            include_completions_with_insert_text = true,
            -- CodeLens
            -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
            -- possible values: ("off"|"all"|"implementations_only"|"references_only")
            code_lens = "off",
            -- by default code lenses are displayed on all referencable values and for some of you it can
            -- be too much this option reduce count of them by removing member references from lenses
            disable_member_code_lens = true,
            -- JSXCloseTag
            -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
            -- that maybe have a conflict if enable this feature. )
            jsx_close_tag = {
                enable = false,
                filetypes = { "javascriptreact", "typescriptreact" },
            }
        },
    }
})
