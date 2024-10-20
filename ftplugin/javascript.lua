local abbreviations = {
	aa = "&&",
	c = "const",
	e = "=",
	ee = "===",
	er = "=>",
	ew = "= await",
	l = "let",
	n = "null",
	ne = "!==",
	oo = "||",
	r = "return",
	s = "string",
	u = "undefined",
	w = "await",
	y = "async",
}

for key, value in pairs(abbreviations) do
	vim.cmd.iabbrev(key, value)
end
