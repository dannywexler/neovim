local abbreviations = {
	e = "=",
	l = "local",
	r = 'require("")<Left><Left>',
	re = "return",
}

for key, value in pairs(abbreviations) do
	vim.cmd.iabbrev(key, value)
end
