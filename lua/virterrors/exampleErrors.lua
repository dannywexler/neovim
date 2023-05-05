local exampleDiag = {
    {
        bufnr = 5,
        code = "miss-symbol",
        col = 73,
        end_col = 73,
        end_lnum = 1,
        lnum = 1,
        message = "Missed symbol `)`.",
        namespace = 39,
        severity = 1,
        source = "Lua Syntax Check.",
        user_data = {
            lsp = {
                code = "miss-symbol",
                data = "syntax"
            }
        }
    },
    {
        bufnr = 5,
        code = "miss-sep-in-table",
        col = 22,
        end_col = 15,
        end_lnum = 33,
        lnum = 32,
        message = "Miss symbol `,` or `;` .",
        namespace = 39,
        severity = 1,
        source = "Lua Syntax Check.",
        user_data = {
            lsp = {
                code = "miss-sep-in-table",
                data = "syntax"
            }
        }
    },
    {
        _tags = {
            unnecessary = true
        },
        bufnr = 5,
        code = "unused-local",
        col = 6,
        end_col = 17,
        end_lnum = 4,
        lnum = 4,
        message = "Unused local `exampleDiag`.",
        namespace = 39,
        severity = 4,
        source = "Lua Diagnostics.",
        user_data = {
            lsp = {
                code = "unused-local"
            }
        }
    }
}

local moreDiags = { {
    bufnr = 7,
    code = "miss-sep-in-table",
    col = 38,
    end_col = 20,
    end_lnum = 9,
    lnum = 8,
    message = "Miss symbol `,` or `;` .",
    namespace = 43,
    severity = 1,
    source = "Lua Syntax Check.",
    user_data = {
        lsp = {
            code = "miss-sep-in-table",
            data = "syntax"
        }
    }
}, {
    _tags = {
        unnecessary = true
    },
    bufnr = 7,
    code = "unused-function",
    col = 6,
    end_col = 14,
    end_lnum = 59,
    lnum = 59,
    message = "Unused functions.",
    namespace = 43,
    severity = 4,
    source = "Lua Diagnostics.",
    user_data = {
        lsp = {
            code = "unused-function"
        }
    }
}, {
    _tags = {
        unnecessary = true
    },
    bufnr = 7,
    code = "unused-local",
    col = 6,
    end_col = 17,
    end_lnum = 0,
    lnum = 0,
    message = "Unused local `exampleDiag`.",
    namespace = 43,
    severity = 4,
    source = "Lua Diagnostics.",
    user_data = {
        lsp = {
            code = "unused-local"
        }
    }
}, {
    _tags = {
        unnecessary = true
    },
    bufnr = 7,
    code = "unused-local",
    col = 15,
    end_col = 20,
    end_lnum = 59,
    lnum = 59,
    message = "Unused local `hello`.",
    namespace = 43,
    severity = 4,
    source = "Lua Diagnostics.",
    user_data = {
        lsp = {
            code = "unused-local"
        }
    }
}, {
    _tags = {
        unnecessary = true
    },
    bufnr = 7,
    code = "unused-local",
    col = 21,
    end_col = 30,
    end_lnum = 59,
    lnum = 59,
    message = "Unused local `someParam`.",
    namespace = 43,
    severity = 4,
    source = "Lua Diagnostics.",
    user_data = {
        lsp = {
            code = "unused-local"
        }
    }
} }

local function hello(someParam)
end
