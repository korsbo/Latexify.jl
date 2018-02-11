using Latexify
using ParameterizedFunctions
using LaTeXStrings

f = @ode_def feedback begin
    dx = y/c_1 - x
    dy = x^c_2 - y
    end c_1 c_2

## Todo: write some actual tests.

test_results = []
test_array = ["x/y * d" :x ; :( (t_sub_sub - x)^(2*p) ) 3//4 ]

true
