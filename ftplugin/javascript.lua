local abbreviations = {
	aw = "await",
	ac = "async",
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
	n = "null",
	u = "undefined",
	s = "string",
}

for key, value in pairs(abbreviations) do
	vim.cmd.iabbrev(key, value)
end
