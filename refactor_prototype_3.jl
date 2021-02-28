const MATCHING_FUNCTIONS = Function[]

add_matcher(f) = push!(MATCHING_FUNCTIONS, f)

_check_call_match(e, op::Symbol) = e isa Expr && e.head === :call && e.args[1] === op

# User would write:
#   text_color_latexify(e) = "\\textcolor{$(args[1])}{$(latexify(args[2]))}"
#   add_call_matcher(text_color_latexify, :textcolor)
function add_call_matcher(op::Symbol, f::Function)
    push!(MATCHING_FUNCTIONS, (e, p) -> _check_call_match(e, op) ? f(e, p) : nothing)
end


nested(::Any) = false
arguments(::Any) = nothing
operation(::Any) = nothing
head(::Any) = nothing

nested(::Expr) = true
arguments(ex::Expr) = ex.args[2:end]
operation(ex::Expr) = ex.args[1]
head(ex::Expr) = ex.head


surround(x) = "\\left( $x \\right)"

function dive(x, prevop=nothing)
   args = map(arg -> nested(arg) ? dive(arg, operation(x)) : arg, arguments(x))
#    latexterminal(head(x), operation(x), args, prevop)
    for f in MATCHING_FUNCTIONS[end:-1:1]
        if f(head(x), operation(x), args, prevop) !== nothing
            return f(head(x), operation(x), args, prevop)
            break
        end
    end
    return "Caught nothing!!"
end


if false 
func(x, prevop) = string(x)
# func(x::Expr, prevop::Symbol) = func(x, Val{prevop}())
function func(e::Expr, prevop=Val(:_nothing))
    for f in MATCHING_FUNCTIONS[end:-1:1]
        if f(e, prevop) !== nothing
            return f(e, prevop)
            break
        end
    end
    return "Caught nothing!!"
end


### Overloadable formatting functions

# match_equals(e) = (e isa Expr && e.head === :=) ? 
    # "$(latexify(value(lhs_val))) = $(latexify(first(rhs_array)))" :
    # nothing



match_addition(e, prevop) = (e isa Expr && e.head==:call && e.args[1] == :+) ? join(func.(e.args[2:end], e.args[1]), " + ") : nothing
match_addition(e, prevop::Val{:*}) = (e isa Expr && e.head==:call && e.args[1] == :+) ? surround(join(func.(e.args[2:end], e.args[1]), " + ")) : nothing

match_division(e, prevop) =  (e isa Expr && e.head==:call && e.args[1] == :/) ? "\\frac{$(func(e.args[2], e.args[1]))}{$(func(e.args[3], e.args[1]))}" : nothing

match_mul(e, prevop) = (e isa Expr && e.head==:call && e.args[1] == :*) ? join(func.(e.args[2:end], Val{:*}()), " \\cdot ") : nothing

struct Operation{T}
    head::Symbol
    op::Symbol
    args::T
    prevop::Union{Symbol, Nothing}
end
Operation(ex::Expr, prevop) = Operation(ex.head, ex.args[1], ex.args[2:end], prevop)
end