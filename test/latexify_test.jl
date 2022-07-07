using Latexify
using LaTeXStrings
using Test


test_array = ["x/y * d" :x ; :( (t_sub_sub - x)^(2*p) ) 3//4 ]

 
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

@test latexify("Plots.jl") isa LaTeXString
