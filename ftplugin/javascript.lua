local abbreviations = {
	a = "await",
	aa = "&&",
	c = "const",
	e = "=",
	ee = "==",
	eee = "===",
	er = "=>",
	l = "let",
	oo = "||",
	ne = "!=",
	r = "return",
}

for key, value in pairs(abbreviations) do
	vim.cmd.iabbrev(key, value)
end
