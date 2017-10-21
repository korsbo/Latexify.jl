"""
    latexify(ex::Expr)

Takes an expression `ex` and returns a string formatted for a LaTex equation.

Currently, `ex` may only contain the operators + - * / and ^.
It will also not convert special characters, symbols or sub/superscripts to
anything that LaTex can actually understand.

julia> latexify(:(x/(y+x)))
"\\frac{x}{y + x}"
"""
function latexify(inputex::Expr)
    function recurseexp!(ex)
        prevOp = Vector{Symbol}(length(ex.args))
        fill!(prevOp, :none)
        for i in 1:length(ex.args)
            if isa(ex.args[i], Expr)
                length(ex.args[i].args) > 2 && (prevOp[i] = ex.args[i].args[1])
                ex.args[i] = recurseexp!(ex.args[i])
            end
        end
        return latexoperation(ex, prevOp)
    end
    ex = deepcopy(inputex)
    recurseexp!(ex)
end

"""
    latexify(arr::AbstractArray)

Recursively iterates latexify over an array of Expressions (or Arrays thereof).
Returns an array of strings which are formatted for LaTeX equations.
"""
latexify(arr::AbstractArray) = [latexify(i) for i in arr]


"""
    latexify(x::SymEngine.Basic)

Return a LaTeX formatted string from a symbolic expression.
"""
function latexify(x::SymEngine.Basic)
    str = string(x)
    ex = parse(str)
    latexify(ex)
end

"""
    latexify(ode::AbstractParameterizedFunction)

Generate a string containing a LaTeX align environment showing the ODE.
This is meant to be printed, rather than displayed.
"""
function latexify(ode::DiffEqBase.AbstractParameterizedFunction)
    str = "\\begin{align}\n"
    for i in 1:length(ode.syms)
        var = ode.syms[i]
        str = "$str\\frac{d$var}{dt} =& "
        lstr = latexify(ode.funcs[i])
        str = "$str $lstr \\\\ \n"
    end
    str = "$str \\end{align}\n"
end

latexify(i::Number) = string(i)
