using Latexify: @latexrecipe
using LaTeXStrings
using DiffEqBase

@latexrecipe function latexify(ode::DiffEqBase.AbstractParameterizedFunction; bracket=false, hello=:nope, field=:funcs) 
    vars = ode.syms
    if bracket
        lhs = [LaTeXString("\\frac{\\left[ $x \\right]}{dt}") for x in ode.syms]
        rhs = Latexify.add_brackets(getfield(ode, field), ode.syms)
    else
        lhs = ["d$x/dt" for x in ode.syms]
        rhs = ode.funcs
    end
    env --> :align
    transpose --> true
    something --> 1.4
    fmt := "%.3f"
    return lhs, rhs
end

using Latexify
Latexify.apply_recipe(f; dummy_kw=:hello, hello=:yes, transpose=false, fmt="", bracket=true)
latexify(f; bracket=true)
md(f)



revise()
@macroexpand @latexrecipe function latexify(ode::DiffEqBase.AbstractParameterizedFunction; bracket=false, hello=:nope, field=:funcs) 
    vars = ode.syms
    lhs = ["d$x/dt" for x in ode.syms]
    rhs = ode.funcs
    env --> :align
    transpose --> true
    something --> 1.4
    fmt := "%.3f"
    return lhs, rhs
end

println("hi there")

using Latexify
using DiffEqBase
using ParameterizedFunctions

f = @ode_def TestAlignFeedback begin
    dx = y/c_1 - x
    dy = x^c_2 - y
end c_1 c_2

args, kwargs = Latexify.apply_recipe(f; bracket=true)
latexify(args...; kwargs...)



ode = f

lhs = ["d$x/dt" for x in ode.syms]
rhs = ode.funcs
latexify(lhs, rhs; env=:raw)


latexify(f; env=:raw)

a = begin
    hello="hi"
    return "nope"
end

a = quote f(x)
    b = 2
    return (b, 3)
end

a.args[end].args[1].args

using MacroTools: postwalk

postwalk(x-> :head in fieldnames(typeof(x)) && x.head == :return ? :(return ($(x.args[1]), kwargs)) : x, a)

a


macro mkfunc(name)
    esc(
    quote 
        function h(x::Number; kwargs...)
            return "hi $x, $kwargs" 
        end 
    end
   )
end
@mkfunc h
h(2.; hello="nope")


quote function h(x) end

    kw = Expr(:parameters, Expr(:kw, :y, Int(1)))
    kw = Expr(:parameters, Expr(:..., :kwargs))
    Expr(:call, :h, kw, :x)

ex = :(h(x; kwargs...))
ex = :(h(x; a=12))
dump(ex)
