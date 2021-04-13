"""
    latexoperation(ex::Expr, prevOp::AbstractArray)

Translate a simple operation given by `ex` to LaTeX maths syntax.
This uses the information about the previous operations to decide if
a parenthesis is needed.

"""
function latexoperation(ex::Expr, prevOp::AbstractArray; cdot=true, index=:bracket, kwargs...)::String
    op = ex.args[1]
    filter!(x -> !(x isa LineNumberNode), ex.args)
    args = map(i -> typeof(i) ∉ (String, LineNumberNode) ? latexraw(i; kwargs...) : i, ex.args)

    # Remove math italics for variables (i.e. words) longer than 2 characters.
    # args = map(i -> (i isa String && all(map(isletter, collect(i))) && length(i) > 2) ? "{\\rm $i}" : i, args)

    if ex.head == :latexifymerge
        if all(prevOp .== :none)
            return join(args)
        else
            return "$(args[1])\\left( $(join(args[2:end])) \\right)"
        end
    end

    if op in [:/, :./]
        return "\\frac{$(args[2])}{$(args[3])}"

    elseif op in [:*, :.*]
        str=""
        for i in 2:length(args)
            arg = args[i]
            prevOp[i] in [:+, :-, :±]  && (arg = "\\left( $arg \\right)")
            str = string(str, arg)
            i != length(args) && (str *= cdot ? " \\cdot " : " ")
        end
        return str

    elseif op in [:+, :.+]
        str = join(args[2:end], " + ")
        str = replace(str, "+  -"=>"-")
        str = replace(str, "+ -"=>"-")
        return str

    elseif op in [:±, :.±]
        return "$(args[2]) \\pm $(args[3])"

    elseif op in [:-, :.-]
        if length(args) == 2
            if prevOp[2] == :none && string(args[2])[1] == '-'
                return " + " * string(args[2])[2:end]
            elseif prevOp[2] == :none && string(args[2])[1] == '+'
                return " - " * string(args[2])[2:end]
            elseif prevOp[2] in [:+, :-, :±]
                return " - \\left( $(args[2]) \\right)"
            end
            return " - $(args[2])"
        end
        prevOp[3] in [:+, :-, :±] &&  (args[3] = "\\left( $(args[3]) \\right)")

        if prevOp[3] == :none && string(args[3])[1] == '-'
            return "$(args[2]) + " * string(args[3])[2:end]
        end
        return "$(args[2]) - $(args[3])"

    elseif op in [:^, :.^]
        #isa(args[2], String) && (args[2]="($(args[2]))")
        if prevOp[2] in trigonometric_functions
            str = get(function2latex, prevOp[2], "\\$(prevOp[2])")
            return replace(args[2], str => "$(str)^{$(args[3])}")
        end
        if (prevOp[2] != :none) || (ex.args[2] isa Real && sign(ex.args[2]) == -1) || (ex.args[2] isa Complex) || (ex.args[2] isa Rational)
            args[2]="\\left( $(args[2]) \\right)"
        end
        return "$(args[2])^{$(args[3])}"
    elseif (ex.head in (:(=), :function)) && length(args) == 2
        return "$(args[1]) = $(args[2])"
    elseif op == :(!)
        return "\\neg $(args[2])"
    end

    if ex.head == :.
        ex.head = :call
        # op = string(op, ".") ## Signifies broadcasting.
    end

    string(op)[1] == '.' && (op = Symbol(string(op)[2:end]))

    # infix_operators = [:<, :>, Symbol("=="), :<=, :>=, :!=]
    comparison_operators = Dict(
        :< => "<",
        :.< => "<",
        :> => ">",
        :.> => ">",
        Symbol("==") => "=",
        Symbol(".==") => "=",
        :<= => "\\leq",
        :.<= => "\\leq",
        :>= => "\\geq",
        :.>= => "\\geq",
        :!= => "\\neq",
        :.!= => "\\neq",
        )

    if op in keys(comparison_operators) && length(args) == 3
        str = "$(args[2]) $(comparison_operators[op]) $(args[3])"
        str = "\\left( $str \\right)"
        return str
    end

    ### Check for chained comparison operators
    if ex.head == :comparison && Symbol.(args[2:2:end]) ⊆ keys(comparison_operators)
        str = join([isodd(i) ? "$var" : comparison_operators[var] for (i, var) in enumerate(Symbol.(args))], " ")
        str = "\\left( $str \\right)"
        return str
    end

    if op in keys(function2latex)
        return "$(function2latex[op])\\left( $(join(args[2:end], ", ")) \\right)"
    end

    op == :sqrt && return "\\$op{$(args[2])}"
    op == :abs && return "\\left\\|$(args[2])\\right\\|"
    op == :exp && return "e^{$(args[2])}"

    ## Leave math italics for single-character operator names (e.g., f(x)).
    opname = replace(string(op), '_'=>raw"\_")
    if length(opname) > 1
        opname = "\\mathrm{$opname}"
    end

    if ex.head == :ref
        if index == :subscript
            return "$(args[1])_{$(join(args[2:end], ","))}"
        elseif index == :bracket
            argstring = join(args[2:end], ", ")
            return "$opname\\left[$argstring\\right]"
        else
            throw(ArgumentError("Incorrect `index` keyword argument to latexify. Valid values are :subscript and :bracket"))
        end
    end

    if ex.head == :macrocall && ex.args[1] == Symbol("@__dot__")
        return string(ex.args[end])
    end

    if ex.head == :macrocall 
        ex.head = :call
    end

    if ex.head == :call
        if length(args) == 1
            return "$opname()"
        elseif args[2] isa String && occursin("=", args[2])
            return "$opname\\left( $(join(args[3:end], ", ")); $(args[2]) \\right)"
        else
            return "$opname\\left( $(join(args[2:end], ", ")) \\right)"
        end
    end

    if ex.head == :tuple
        # return "\\left(" * join(ex.args, ", ") * "\\right)"
        return join(ex.args, ", ")
    end

    ex.head == Symbol("'") && return "$(args[1])'"

    ## Enable the parsing of kwargs in a function definition
    ex.head == :kw && return "$(args[1]) = $(args[2])"
    ex.head == :parameters && return join(args, ", ")

    ## Use the last expression in a block.
    ## This is somewhat shady but it helps with latexifying functions.
    ex.head == :block && return args[end]

    ## Sort out type annotations. Mainly for function arguments.
    ex.head == :(::) && length(args) == 1 && return "::$(args[1])"
    ex.head == :(::) && length(args) == 2 && return "$(args[1])::$(args[2])"

    ## Pass back values that were explicitly returned.
    ex.head == :return && length(args) == 1 && return args[1]

    ## Case enviroment for if statements and ternary ifs.
    if ex.head in (:if, :elseif)
        textif::String = "\\text{if }"
        begincases::String = ex.head == :if ? "\\begin{cases}\n" : ""
        endcases::String = ex.head == :if ? "\n\\end{cases}" : ""
        if length(args) == 3
            # Check if already parsed elseif as args[3]
            haselseif::Bool = occursin(Regex("\\$textif"), args[3])
            otherwise::String = haselseif ? "" : " & \\text{otherwise}"
            return """$begincases$(args[2]) & $textif $(args[1])\\\\
                      $(args[3])$otherwise$endcases"""
        elseif length(args) == 2
            return "$begincases$(args[2]) & $textif $(args[1])$endcases"
        end
    end

    ## Conditional operators converted to logical operators.
    ex.head == :(&&) && length(args) == 2 && return "$(args[1]) \\wedge $(args[2])"
    ex.head == :(||) && length(args) == 2 && return "$(args[1]) \\vee $(args[2])"



    ## if we have reached this far without a return, then error.
    error("Latexify.jl's latexoperation does not know what to do with one of the
          expressions provided ($ex).")
    return ""
end

latexoperation(sym::Symbol, prevOp::AbstractArray; kwargs...) = "$sym"


function convertSubscript!(ex::Expr)
    for i in 1:length(ex.args)
        arg = ex.args[i]
        if arg isa Symbol
            ex.args[i] = convertSubscript(arg)
        end
    end
    return nothing
end

function convertSubscript(str::String)
    if occursin("_", str)
        subscriptList = split(str, "_")
        subscript = join(subscriptList[2:end], "\\_")
        result = "$(subscriptList[1])_{$subscript}"
    else
        result = str
    end
    return result
end

convertSubscript(sym::Symbol) = convertSubscript(string(sym))
