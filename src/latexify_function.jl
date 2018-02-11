function latexify(x)
    latexstr = latexstring( latexraw(x) )
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end

latexify(x::AbstractArray) = [ latexify(i) for i in x]

@require DiffEqBase begin
    function latexify(ode::DiffEqBase.AbstractParameterizedFunction)
        lhs = ["\\frac{d$x}{dt} = " for x in ode.syms]
        rhs = latexraw(ode.funcs)
        latexstr = latexstring.( lhs .* rhs )
        COPY_TO_CLIPBOARD && clipboard(latexstr)
        return latexstr
    end
end
