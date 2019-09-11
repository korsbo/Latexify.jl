using Latexify
using ParameterizedFunctions
using LaTeXStrings
using Test

f = @ode_def feedback begin
    dx = y/c_1 - x
    dy = x^c_2 - y
    end c_1 c_2

test_array = ["x/y * d" :x ; :( (t_sub_sub - x)^(2*p) ) 3//4 ]

for env in [:raw, :inline, :array, :align, :tabular]
    @test latexify(test_array; env=env) == eval(Meta.parse("latex$env(test_array)"))
end

@test latexify(f; starred=true) ==
raw"\begin{align*}
\frac{dx}{dt} =& \frac{y}{c_{1}} - x \\
\frac{dy}{dt} =& x^{c_{2}} - y
\end{align*}
"
 
#### Test the setting of default keyword arguments.

@test latexify("x * y") == 
raw"$x \cdot y$"

set_default(cdot = false)

@test latexify("x * y") == 
raw"$x y$"

@test get_default() == Dict{Symbol,Any}(:cdot => false)

set_default(cdot = true, transpose = true)

@test get_default() == Dict{Symbol,Any}(:cdot => true,:transpose => true)
@test get_default(:cdot) == true
@test get_default(:cdot, :transpose) == (true, true)
@test get_default([:cdot, :transpose]) == Bool[1, 1]

reset_default()
@test get_default() == Dict{Symbol,Any}()

@test latexify("x * y") == 
raw"$x \cdot y$"


