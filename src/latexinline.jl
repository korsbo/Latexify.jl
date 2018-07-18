function latexinline(x, args...)
    latexstr = latexstring( latexraw(x, args...) )
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end

latexinline(x::AbstractArray) = [ latexinline(i) for i in x]


function latexinline(f::Function, args; kwargs...)
    result_expr = parse_function_expression(f, args)
    # length(result_expr) == 1 && (result_expr = result_expr[1])
    result_expr = result_expr[end]
    return latexinline(result_expr; kwargs...)
end

@require DiffEqBase begin
    function latexinline(ode::DiffEqBase.AbstractParameterizedFunction)
        lhs = ["\\frac{d$x}{dt} = " for x in ode.syms]
        rhs = latexraw(ode.funcs)
        return latexstring.( lhs .* rhs )
    end
end
