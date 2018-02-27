using Revise
using Latexify
using DifferentialEquations
using DataFrames
using LaTeXStrings

revise()

ex = :(min(1,2))
latexify(ex)

"x/y" |> latexify
l = latexify("x/y")

join(1, ",")


f = @ode_def feedback begin
    dx = y/c_1 - x
    dy = x^c_2 - y
    end c_1 c_2

latexalign(f.syms, f.funcs)
latexify(f.syms, f.funcs)
