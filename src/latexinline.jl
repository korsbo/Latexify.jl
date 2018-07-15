function latexinline(x)
    latexstr = latexstring( latexraw(x) )
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end

latexinline(x::AbstractArray) = [ latexinline(i) for i in x]

@require DiffEqBase begin
    function latexinline(ode::DiffEqBase.AbstractParameterizedFunction)
        lhs = ["\\frac{d$x}{dt} = " for x in ode.syms]
        rhs = latexraw(ode.funcs)
        return latexstring.( lhs .* rhs )
    end
end
