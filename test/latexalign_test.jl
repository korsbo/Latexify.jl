using Latexify
using ParameterizedFunctions

f = @ode_def feedback begin
    dx = y/c_1 - x
    dy = x^c_2 - y
end c_1 c_2

g = @ode_def test2 begin
    dx = p_x - d_x*x - d_x_y*y*x
    dy = p_y - d_y*y
    dz = p_z
end p_x d_x d_x_y p_y d_y p_z

test_results = []

push!(test_results, latexalign(["d$x/dt" for x in f.syms], f.funcs) == "\\begin{align}\n\\frac{dx}{dt} =& \\frac{y}{c_{1}} - x \\\\ \n\\frac{dy}{dt} =& x^{c_{2}} - y \\\\ \n\\end{align}\n")
push!(test_results, latexalign(f) == "\\begin{align}\n\\frac{dx}{dt} =& \\frac{y}{c_{1}} - x \\\\ \n\\frac{dy}{dt} =& x^{c_{2}} - y \\\\ \n\\end{align}\n")
push!(test_results, latexalign(f, field=:symfuncs) == "\\begin{align}\n\\frac{dx}{dt} =& - x + \\frac{y}{c_{1}} \\\\ \n\\frac{dy}{dt} =& - y + x^{c_{2}} \\\\ \n\\end{align}\n")
push!(test_results, latexalign([f,g]) == "\\begin{align}\n\\frac{dx}{dt}  &=  \\frac{y}{c_{1}} - x  &  \\frac{dx}{dt}  &=  p_{x} - d_{x} \\cdot x - d_{x\\_y} \\cdot y \\cdot x  &  \\\\ \n\\frac{dy}{dt}  &=  x^{c_{2}} - y  &  \\frac{dy}{dt}  &=  p_{y} - d_{y} \\cdot y  &  \\\\ \n  &    &  \\frac{dz}{dt}  &=  p_{z} \\cdot 1  &  \\\\ \n\\end{align}\n")

println("latexalign_test successes: \n", test_results)
all(test_results)
