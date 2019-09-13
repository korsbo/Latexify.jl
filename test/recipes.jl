
@latexrecipe function latexify(ode::AbstractParameterizedFunction; bracket=false, hello=:nope) 
    vars = ode.syms
    lhs = ["d$x/dt" for x in ode.syms]
    rhs = ode.funcs
    env --> :align
    transpose --> true
    something --> 1.4
    return lhs, rhs
end

println("hi there")

using ParameterizedFunctions

f = @ode_def TestAlignFeedback begin
    dx = y/c_1 - x
    dy = x^c_2 - y
end c_1 c_2


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

