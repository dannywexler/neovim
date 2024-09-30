local abbreviations = {
	aa = "&&",
	c = "const",
	e = "=",
	ee = "===",
	er = "=>",
	ew = "= await",
	l = "let",
	n = "number",
	nl = "null",
	ne = "!==",
	oo = "||",
	r = "return",
	s = "string",
	u = "undefined",
	w = "await",
	y = "async",
	yi = "yield",
}

for key, value in pairs(abbreviations) do
	vim.cmd.iabbrev(key, value)
end
