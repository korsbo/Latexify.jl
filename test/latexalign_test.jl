using Latexify
using ParameterizedFunctions

f = @ode_def feedback begin
    dx = y/c_1 - x
    dy = x^c_2 - y
end c_1=>1.0 c_2=>1.0

test_results = []

push!(test_results, latexalign(["d$x/dt" for x in f.syms], f.funcs) == "\\begin{align}\n\\frac{dx}{dt} =& \\frac{y}{c_{1}} - x \\\\ \n\\frac{dy}{dt} =& x^{c_{2}} - y \\\\ \n\\end{align}\n")
push!(test_results, latexalign(f) == "\\begin{align}\n\\frac{dx}{dt} =& \\frac{y}{c_{1}} - x \\\\ \n\\frac{dy}{dt} =& x^{c_{2}} - y \\\\ \n\\end{align}\n")
push!(test_results, latexalign(f, field=:symfuncs) == "\\begin{align}\n\\frac{dx}{dt} =& - x + \\frac{y}{c_{1}} \\\\ \n\\frac{dy}{dt} =& - y + x^{c_{2}} \\\\ \n\\end{align}\n")

println("latexalign_test successes: \n", test_results)
all(test_results)
