using Latexify
using ParameterizedFunctions
using LaTeXStrings

f = @ode_def feedback begin
    dx = y/c_1 - x
    dy = x^c_2 - y
    end c_1 c_2

test_array = ["x/y * d" :x ; :( (t_sub_sub - x)^(2*p) ) 3//4 ]

for env in [:raw, :inline, :array, :align, :tabular]
    @test latexify(test_array; env=env) == eval(parse("latex$env(test_array)"))
end

@test latexify(f; starred = true) == "\\begin{align*}\n\\frac{dx}{dt} =& \\frac{y}{c_{1}} - x \\\\ \n\\frac{dy}{dt} =& x^{c_{2}} - y \\\\ \n\\end{align*}\n"
