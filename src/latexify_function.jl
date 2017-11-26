latexify(x) = latexstring( latexraw(x) )
latexify(x::AbstractArray) = [ latexify(i) for i in x]

function latexify(ode::DiffEqBase.AbstractParameterizedFunction)
    lhs = ["\\frac{d$x}{dt} = " for x in ode.syms]
    rhs = latexraw(ode.funcs)
    return latexstring.( lhs .* rhs )
end
