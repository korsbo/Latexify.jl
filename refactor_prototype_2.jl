
const MATCHING_FUNCTIONS = Function[]

add_matcher(f) = push!(MATCHING_FUNCTIONS, f)

_check_call_match(e, op::Symbol) = e isa Expr && e.head === :call && e.args[1] === op

# User would write:
#   text_color_latexify(e) = "\\textcolor{$(args[1])}{$(latexify(args[2]))}"
#   add_call_matcher(text_color_latexify, :textcolor)
function add_call_matcher(f::Function, op::Symbol)
    push!(MATCHING_FUNCTIONS, (e, p) -> _check_call_match(e, op) ? f(e) : nothing)
end


nested(::Any) = false
arguments(::Any) = nothing
operation(::Any) = nothing
head(::Any) = nothing

nested(::Expr) = true
arguments(ex::Expr) = ex.args[2:end]
operation(ex::Expr) = ex.args[1]
head(ex::Expr) = ex.head

func(x, prevop) = string(x)
func(x::Expr, prevop::Symbol) = func(x, Val{prevop}())
function func(e::Expr, prevop=Val(:_nothing))
    for f in MATCHING_FUNCTIONS
        if f(e, prevop) !== nothing
            return f(e, prevop)
            break
        end
    end
    return "Caught nothing!!"
end


### Overloadable formatting functions
surround(x) = "\\left( $x \\right)"

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