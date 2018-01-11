
"""
    latexoperation(ex::Expr, prevOp::AbstractArray)

Translate a simple operation given by `ex` to LaTeX maths syntax.
This uses the information about the previous operations to decide if
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
            prevOp[i] in [:+, :-]  && (arg = "\\left( $arg \\right)")
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
        prevOp[2] != :none  && (args[2]="\\left( $(args[2]) \\right)")
        return "$(args[2])^{$(args[3])}"
    elseif ex.head == :(=) && length(args) == 2
        return "$(args[1]) = $(args[2])"
    end

    op == :log10 && return "\\log_{10}\\left( $(args[2]) \\right)"
    op == :log2 && return "\\log_{2}\\left( $(args[2]) \\right)"
    op == :sqrt && return "\\$op{$(args[2])}"
    op == :abs && return "\\left\\|$(args[2])\\right\\|"
    op == :exp && return "e^{$(args[2])}"

    #if op in [:log, :sin, :asin, :cos, :acos :tan, :atan]
    length(args) == 2 &&  return "\\$op\\left( $(args[2]) \\right)"

    ## if we have reached this far without a return, then error.
    error("Latexify.jl's latexoperation does not know what to do with one of the
                operators in your expression.")
    return ""
end

latexoperation(sym::Symbol, prevOp::AbstractArray) = "$sym"


function convertSubscript!(ex::Expr)
    for i in 1:length(ex.args)
        arg = ex.args[i]
        if arg isa Symbol
            ex.args[i] = convertSubscript(arg)
        end
    end
    return nothing
end

function convertSubscript(sym::Symbol)
    if contains(string(sym), "_")
        subscriptList = split(string(sym), "_")
        subscript = join(subscriptList[2:end], "\\_")
        result = "$(subscriptList[1])_{$subscript}"
    else
        result = "$sym"
    end
    return result
end
