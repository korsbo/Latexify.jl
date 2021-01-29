using Latexify
nested(ex::Expr) = true
args(ex::Expr) = ex.args[2:end]
op(ex::Expr) = ex.args[1]
head(ex::Expr) = ex.head

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
lf(func, ::Any, args) = "$(value(func))\\left($(join(args, ", "))\\right)"
lf(func::ValUnion(Latexify.trigonometric_functions), ::Any, args) = "\\$(value(func))\\left($(join(args, ", "))\\right)"
# lf(func::Val{:sin}, ::Any, args) = "$(value(func))\\left($(join(args, ", "))\\right)"


function lf(op::Val{:+}, ::ValUnion(:*, :^), args) 
    surround(join(args, " $(value(op)) "))
end

lf(op::Val{:+}, prevop, args) = join(args, " + ")

# ### router functions
lf(::Val{:call}, op, prevop, args) = lf(op, prevop, args)

# ### :call functions
lf(op::Val{:*}, prevop, args; mul_symb=" \\cdot ", kw...) = 
    join(args, string(mul_symb))
lf(op::Val{:-}, prevop, args; kw...) = 
    length(args) == 1 ? "- $(args[1])" : join(args, " - ")


function lf(op::Val{:^}, ::Any, args; kw...) 
    pattern = r"^\\(\w*)"
    m = match(pattern, args[1])
    if !isnothing(m) && Symbol(m.captures[1]) ∈ Latexify.trigonometric_functions
        replace(args[1], pattern=>"$(m.match)^{$(args[2])}" )
    else
        "$(args[1])^{$(strip_surround(args[2]))}"
    end
end

# # function lf(::Val{:^}, prevop::ValUnion(:sin, :cos), args; kw...)
# function lf(::T, prevop::Val{:^}, args; kw...) where T <: ValUnion(:sin, :cos)
# display(args)
# return "sin"
# end

lf(op::Val{:/}, prevop, args; kw...) = 
    "\\frac{$(args[1])}{$(args[2])}"
lf(op::Val{:revealargs}, prevop, args; kw...) = args


# ### non :call functions
lf(::Val{:ref}, op, prevop, args; kw...) = "$(value(op))\\left[$(join(args, ", "))\\right]"
lf(::Val{:latexifymerge}, op, prevop, args; kw...) = string(value(op)) * join(args, "") 


lf(head::Symbol, op::Symbol, prevop::Symbol, args) = lf(Val{head}(), Val{op}(), Val{prevop}(), args)
lf(head::Symbol, op::Symbol, prevop, args) = lf(Val{head}(), Val{op}(), prevop, args)
lf(ex, prevop) = lf(head(ex), op(ex), prevop, args(ex))


dive(ex, prevop=nothing) = dive(Val{nested(ex)}(), ex, prevop)
dive(::Val{false}, ex, prevop) = string(ex)
dive(::Val{true}, ex, prevop) = lf(head(ex), op(ex), prevop, dive.(args(ex), op(ex)))
