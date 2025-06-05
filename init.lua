require("utils.log")
require("utils.merge")
require("utils.plugin")
require("sleekfiles").setup()

WINDOWS = vim.fn.has("win32") == 1

require("lazyConfig")
