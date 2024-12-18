using Latexify
using LaTeXStrings
using Test


test_array = ["x/y * d" :x ; :( (t_sub_sub - x)^(2*p) ) 3//4 ]

 
#### Test the setting of default keyword arguments.

@test latexify("x * y") == 
raw"$x \cdot y$"

set_default(mult_symbol = "")

@test latexify("x * y") == 
raw"$x y$"

@test get_default() == Dict{Symbol,Any}(:mult_symbol => "")

set_default(mult_symbol = "\\cdot", transpose = true)

@test get_default() == Dict{Symbol,Any}(:mult_symbol => "\\cdot",:transpose => true)
@test get_default(:mult_symbol) == "\\cdot"
@test get_default(:mult_symbol, :transpose) == ("\\cdot", true)
@test get_default([:mult_symbol, :transpose]) == ["\\cdot", true]

reset_default()
@test get_default() == Dict{Symbol,Any}()

@test latexify("x * y") == 
raw"$x \cdot y$"

@test latexify("Plots.jl") isa LaTeXString
