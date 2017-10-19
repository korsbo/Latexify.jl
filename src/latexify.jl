__precompile__()
module Latexify
using DifferentialEquations
export latexify

"""
    latexoperation(ex::Expr, prevOp::AbstractArray)

Translate a simple operation given by `ex` to LaTeX maths syntax.
This uses the information about the previous operations to deside if
a parenthesis is needed.

"""
function latexoperation(ex::Expr, prevOp::AbstractArray)
    op = ex.args[1]
    args = ex.args
    if op == :/
        return "\\frac{$(args[2])}{$(args[3])}"
    elseif op == :*
        str=""
        for i in 2:length(args)
            arg = args[i]
            prevOp[i] in [:+, :-]  && (arg = "($arg)")
            str = string(str, arg)
            i != length(args) && (str *= " \\cdot ")
        end
        return str
    elseif op in [:+, :-]
        length(args) == 2 && return "$op $(args[2])"
        str=""
        for i in 2:length(args)
            arg = args[i]
            str = string(str, arg)
            i != length(ex.args) && (str *= " $op ")
        end
        return str
    elseif op == :^
        isa(args[2], String) && (args[2]="($(args[2]))")
        return "$(args[2])^{$(args[3])}"
    else error("latexoperation does not know what to do with the provided
                operator.")
    end
    return ""
end

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
   latexify(ode::AbstractParameterizedFunction)

Generate a string containing a LaTeX align environment showing the ODE.
This is meant to be printed, rather than displayed.
"""
function latexify(ode::AbstractParameterizedFunction)
    str = "\\begin{align}\n"
    for i in 1:length(ode.syms)
        var = ode.syms[i]
        str = "$str\\frac{d$var}{dt} =& "
        lstr = latexify(ode.funcs[i])
        str = "$str $lstr \\\\ \n"
    end
    str = "$str \\end{align}\n"
end

end
