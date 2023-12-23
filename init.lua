-- print('hello from init')
WINDOWS = vim.fn.has("win32") == 1
-- if WINDOWS then
-- print('on WINDOWS')
-- else
-- print('on Linux')
-- end

vim.g.sleekerrors_hide = false
require("lazyConfig")
