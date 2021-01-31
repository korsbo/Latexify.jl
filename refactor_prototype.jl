using Latexify
using LaTeXStrings

nested(::Any) = false
arguments(::Any) = nothing
operation(::Any) = nothing
head(::Any) = nothing

nested(::Expr) = true
arguments(ex::Expr) = ex.args[2:end]
operation(ex::Expr) = ex.args[1]
head(ex::Expr) = ex.head

### Ninja functions
value(::Val{T}) where T = T
isiterable(x) = hasmethod(iterate, (typeof(x),))
ValUnion(x) = isiterable(x) ? Union{typeof.(Val.(x))...} : Val{x}
ValUnion(a, b, c...) = ValUnion((a, b, c...))

### Overloadable formatting functions
surround(x) = "\\left( $x \\right)"

#### Automatic argument conversion for convenience

# Reached the end of the tree? 
lf(ex, prevop=nothing) = nested(ex) ? lf(head(ex), operation(ex), prevop, arguments(ex)) : string(ex)

# Let three-argument with omitted head imply that head == :call. 
# This reduces verbosity of a bunch of calls.
lf(::Val{:call}, op, prevop, args) = lf(op, prevop, args)

lf(head::Symbol, op::Symbol, prevop::Symbol, args) = lf(Val{head}(), Val{op}(), Val{prevop}(), args)
# Allows prevopts like `nothing` or just passing through `Val`'s
lf(head::Symbol, op::Symbol, prevop, args) = lf(Val{head}(), Val{op}(), prevop, args)

#### :call functions
# Fallback method for functions of type f(x...)
lf(op, ::Any, args) = "$(value(op))\\left($(join(lf.(args, op), ", "))\\right)"

function lf(op::ValUnion(Latexify.trigonometric_functions), ::Any, args) 
    fstr = get(Latexify.function2latex, value(op), "\\$(value(op))")
    return "$fstr\\left($(join(lf.(args, op), ", "))\\right)"
end

lf(op::Val{:+}, prevop, args) = join(lf.(args, op), " + ")
function lf(op::Val{:+}, ::ValUnion(:*, :^), args) 
    surround(join(lf.(args, op), " $(value(op)) "))
end

lf(op::Val{:-}, prevop, args; kw...) = 
    length(args) == 1 ? "- $(lf(args[1], op))" : join(lf.(args, op), " - ")
    
lf(op::Val{:*}, prevop, args; mul_symb=" \\cdot ", kw...) = 
    join(lf.(args, op), string(mul_symb))

lf(op::Val{:/}, prevop, args; kw...) = 
    "\\frac{$(lf(args[1], op))}{$(lf(args[2], op))}"

function lf(op::Val{:^}, ::Any, args; kw...) 
    if operation(args[1]) in Latexify.trigonometric_functions
        fsym = args[1]
        fstring = get(Latexify.function2latex, fsym, "\\$(fsym)")
        "$fstring^{$(lf(args[2], op))}\\left( $(join(lf.(arguments(args[1]), operation(args[1])), ", ")) \\right)"
    else
        "$(lf(args[1], op))^{$(lf(args[2], Val{:NoSurround}()))}"
    end
end

# ### non :call functions
lf(::Val{:ref}, op, prevop, args; kw...) = "$(value(op))\\left[$(join(lf.(args, op), ", "))\\right]"
lf(::Val{:(=)}, op, prevop, args) = "$(lf(value(op), Val{:NoSurround}())) = $(lf(args[1], Val{:NoSurround}()))"

##### Latexify special commands
lf(::Val{:showargs}, prevop, args; kw...) = string(args)
lf(::Val{:showprevop}, prevop, args; kw...) = string(prevop)
lf(::Val{:textcolor}, prevop, args) = "\\textcolor{$(args[2])}{$(lf(args[1], prevop))}"
lf(::Val{:mathrm}, prevop, args) = "\\mathrm{$(lf(args[1], prevop))}"
lf(::Val{:merge}, prevop, args; kw...) = join(lf.(args, prevop), "") 



function latexdive(x)
    str = lf(x)
    return LaTeXString(str) 
end



