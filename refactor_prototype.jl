using Latexify
nested(ex::Expr) = true
args(ex::Expr) = ex.args[2:end]
op(ex::Expr) = ex.args[1]
head(ex::Expr) = ex.head


arguments(ex::Expr) = ex.args[2:end]
operation(ex::Expr) = ex.args[1]
head(ex::Expr) = ex.head
arguments(::Any) = nothing
operation(::Any) = nothing
head(::Any) = nothing


nested(::Any) = false


value(::Val{T}) where T = T
isiterable(x) = hasmethod(iterate, (typeof(x),))
ValUnion(x) = isiterable(x) ? Union{typeof.(Val.(x))...} : Val{x}
ValUnion(a, b, c...) = ValUnion((a, b, c...))


surround(x) = "\\left( $x \\right)"
function strip_surround(x)
    m = match(r"^\\left\( (.*) \\right\)$", x)
    return isnothing(m) ? x : m.captures[1]
end



### Fallback method for functions of type f(x...)
lf(op, ::Any, args) = "$(value(op))\\left($(join(lf.(args, op), ", "))\\right)"
lf(op::ValUnion(Latexify.trigonometric_functions), ::Any, args) = "\\$(value(func))\\left($(join(lf.(args, op), ", "))\\right)"
# lf(func::Val{:sin}, ::Any, args) = "$(value(func))\\left($(join(args, ", "))\\right)"


function lf(op::Val{:+}, ::ValUnion(:*, :^), args) 
    surround(join(lf.(args, op), " $(value(op)) "))
end

lf(op::Val{:+}, prevop, args) = join(lf.(args, op), " + ")

# ### router functions
lf(::Val{:call}, op, prevop, args) = lf(op, prevop, args)

# ### :call functions
lf(op::Val{:*}, prevop, args; mul_symb=" \\cdot ", kw...) = 
    join(lf.(args, op), string(mul_symb))
lf(op::Val{:-}, prevop, args; kw...) = 
    length(args) == 1 ? "- $(lf(args[1], op))" : join(lf.(args, op), " - ")


function lf(op::Val{:^}, ::Any, args; kw...) 
    if operation(args[1]) in Latexify.trigonometric_functions
        fsym = args[1]
        fstring = get(Latexify.function2latex, fsym, "\\$(fsym)")
        "$fstring^{$(lf(args[2], op))}\\left( $(join(lf.(arguments(args[1]), operation(args[1])), ", ")) \\right)"
    else
        "$(lf(args[1], op))^{$(lf(args[2], Val{:NoSurround}()))}"
    end
end

lf(op::Val{:/}, prevop, args; kw...) = 
    "\\frac{$(lf(args[1], op))}{$(lf(args[2], op))}"
lf(op::Val{:revealargs}, prevop, args; kw...) = args


# ### non :call functions
lf(::Val{:ref}, op, prevop, args; kw...) = "$(value(op))\\left[$(join(lf.(args, op), ", "))\\right]"
lf(::Val{:latexifymerge}, op, prevop, args; kw...) = string(value(op)) * join(lf.(args, op), "") 



lf(head::Symbol, op::Symbol, prevop::Symbol, args) = lf(Val{head}(), Val{op}(), Val{prevop}(), args)
lf(head::Symbol, op::Symbol, prevop, args) = lf(Val{head}(), Val{op}(), prevop, args)
lf(ex, prevop=nothing) = nested(ex) ? lf(head(ex), op(ex), prevop, args(ex)) : string(ex)





