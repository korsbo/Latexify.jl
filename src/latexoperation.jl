
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
    op == :asin && return "\\arcsin\\left( $(args[2]) \\right)"
    op == :asinh && return "\\mathrm{arcsinh}\\left( $(args[2]) \\right)"
    op == :sinc && return "\\mathrm{sinc}\\left( $(args[2]) \\right)"
    op == :acos && return "\\arccos\\left( $(args[2]) \\right)"
    op == :acosh && return "\\mathrm{arccosh}\\left( $(args[2]) \\right)"
    op == :cosc && return "\\mathrm{cosc}\\left( $(args[2]) \\right)"
    op == :atan && return "\\arctan\\left( $(args[2]) \\right)"
    op == :atan2 && return "\\arctan\\left( $(args[2]) \\right)"
    op == :atanh && return "\\mathrm{arctanh}\\left( $(args[2]) \\right)"
    op == :acot && return "\\mathrm{arccot}\\left( $(args[2]) \\right)"
    op == :acoth && return "\\mathrm{arccoth}\\left( $(args[2]) \\right)"
    op == :asec && return "\\mathrm{arcsec}\\left( $(args[2]) \\right)"
    op == :sech && return "\\mathrm{sech}\\left( $(args[2]) \\right)"
    op == :asech && return "\\mathrm{arcsech}\\left( $(args[2]) \\right)"
    op == :acsc && return "\\mathrm{arccsc}\\left( $(args[2]) \\right)"
    op == :csch && return "\\mathrm{csch}\\left( $(args[2]) \\right)"
    op == :acsch && return "\\mathrm{arccsch}\\left( $(args[2]) \\right)"
    op == :gamma && return "\\Gamma\\left( $(args[2]) \\right)"
    op == :sqrt && return "\\$op{$(args[2])}"
    op == :abs && return "\\left\\|$(args[2])\\right\\|"
    op == :exp && return "e^{$(args[2])}"


    if ex.head == :ref
        argstring = join(args[2:end], ", ")
        return "\\mathrm{$op}\\left[$argstring\\right]"
    end


    ## operations which are called the same in Julia and LaTeX
    op_list = (# Greek letters
        :alpha, :beta, :gamma, :delta, :epsilon, :zeta, :eta, :theta,
        :iota, :kappa, :lambda, :mu, :nu, :xi, :pi, :rho, :sigma, :tau,
        :upsilon, :phi, :chi, :psi, :omega,
        :Gamma, :Delta, :Theta, :Lambda, :Xi, :Pi, :Sigma, :Upsilon,
        :Phi, :Psi, :Omega,
        # trigonometric functions
        :sin, :cos, :tan, :cot, :sec, :csc, :sinh, :cosh, :tanh, :coth,
        # log
        :log)

    op in op_list && length(args) == 1 && return "\\$op"
    op in op_list && length(args) == 2 && return "\\$op\\left( $(args[2]) \\right)"
    op in op_list && length(args) > 2 && return "\\$op\\left( $(join(args[2:end], ", ")) \\right)"


    if ex.head == :call
        return "\\mathrm{$op}\\left( $(join(args[2:end], ", ")) \\right)"
    end
    ## if we have reached this far without a return, then error.
    error("Latexify.jl's latexoperation does not know what to do with one of the
                operators in your expression ($op).")
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
