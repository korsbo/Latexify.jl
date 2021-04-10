using Latexify
using LaTeXStrings
using Test


test_array = ["x/y * d" :x ; :( (t_sub_sub - x)^(2*p) ) 3//4 ]

 
#### Test the setting of default keyword arguments.

@test latexify("x * y") == 
raw"$x \cdot y$"

set_default(mulsym = " ")
@test latexify("x * y") == 
raw"$x y$"

@test get_default() == Dict{Symbol,Any}(:mulsym => " ")

set_default(mulsym = " \\cdot ", transpose = true)

@test get_default() == Dict{Symbol,Any}(:mulsym => " \\cdot ",:transpose => true)
@test get_default(:mulsym) == " \\cdot "
@test get_default(:mulsym, :transpose) == (" \\cdot ", true)
@test get_default([:mulsym, :transpose]) == [" \\cdot ", true]

reset_default()
@test get_default() == Dict{Symbol,Any}()

@test latexify("x * y") == 
raw"$x \cdot y$"


