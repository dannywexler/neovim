require("utils.log")
require("utils.merge")
require("utils.plugin")
require("sleekfiles").setup()
require("sleekerrors").setup()

WINDOWS = vim.fn.has("win32") == 1

require("lazyConfig")
