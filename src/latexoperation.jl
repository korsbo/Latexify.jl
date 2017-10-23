
"""
    latexoperation(ex::Expr, prevOp::AbstractArray)

Translate a simple operation given by `ex` to LaTeX maths syntax.
This uses the information about the previous operations to deside if
a parenthesis is needed.

"""
function latexoperation(ex::Expr, prevOp::AbstractArray)
    op = ex.args[1]
    convertSubscript!(ex)
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
        #isa(args[2], String) && (args[2]="($(args[2]))")
        prevOp[2] != :none  && (args[2]="($(args[2]))")
        return "$(args[2])^{$(args[3])}"
    else error("latexoperation does not know what to do with the provided
                operator.")
    end
    return ""
end


function convertSubscript!(ex::Expr)
    for i in 2:length(ex.args)
        arg = ex.args[i]
        if arg isa Symbol
            if contains(string(arg), "_")
                subscriptList = split(string(arg), "_")
                subscript = join(subscriptList[2:end], "\\_")
                result = "$(subscriptList[1])_{$subscript}"
                ex.args[i] = result
            end
        end
    end
    return nothing
end
