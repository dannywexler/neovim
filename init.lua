vim.o.winborder = "rounded"
require("utils.log")
require("utils.merge")
require("utils.plugin")
require("sleekfiles").setup()
require("sleekerrors").setup()

WINDOWS = vim.fn.has("win32") == 1

vim.filetype.add({
    extension = {
        wadl = "xml",
        wsdl = "xml",
    }
})

require("lazyConfig")
