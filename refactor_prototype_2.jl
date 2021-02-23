

add_matcher(f) = push!(MATCHING_FUNCTIONS, f)

_check_call_match(e, op::Symbol) = e isa Expr && e.head === :call && e.args[1] === op
_check_call_match(e, op::AbstractArray) = e isa Expr && e.head === :call && e.args[1] ∈ op

# User would write:
#   text_color_latexify(e) = "\\textcolor{$(args[1])}{$(latexify(args[2]))}"
#   add_call_matcher(text_color_latexify, :textcolor)
function add_call_matcher(op, f::Function)
    push!(MATCHING_FUNCTIONS, (e, p) -> _check_call_match(e, op) ? f(e, p) : nothing)
end


nested(::Any) = false
arguments(::Any) = nothing
operation(::Any) = nothing
head(::Any) = nothing

unpack(x) = (head(x), operation(x), arguments(x))

nested(::Expr) = true
arguments(ex::Expr) = ex.args[2:end]
operation(ex::Expr) = ex.args[1]
head(ex::Expr) = ex.head

# func(x, prevop) = string(x)
# func(x::Expr, prevop::Symbol) = func(x, Val{prevop}())
function func(e, prevop=Val(:_nothing); kwargs...)
    nested(e) || return Latexify.latexraw(e; kwargs...)
    for f in MATCHING_FUNCTIONS[end:-1:1]
        call_result = f(e, prevop) 
        if !isnothing(call_result) 
            return call_result
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

function default_matcher()
return [
  function call(expr, prevop)
    h, op, args = unpack(expr)
    if h == :call 
      string(get(Latexify.function2latex, op, op)) * "\\left( " * join(func.(args, op), ",") * " \\right)"
    end
  end,
  function division(expr, prevop)
    h, op, args = unpack(expr)
    if h == :call && op == :/
      "\\frac{$(func(args[1], op))}{$(func(args[2], op))}"
    end
  end,
  function multiplication(expr, prevop)
    h, op, args = unpack(expr)
    if h == :call && op == :*
      join(func.(args, op), " \\cdot ")
    end
  end,
  function addition(expr, prevop)
      h, op, args = unpack(expr)
      if h == :call && op == :+
        str = join(func.(args, op), " + ") 
        prevop ∈ [:*, :^] && (str = surround(str))
        return str
      end
    end,
  function pow(expr, prevop)
    h, op, args = unpack(expr)
    if h == :call && op == :^
        if operation(args[1]) in Latexify.trigonometric_functions
            fsym = operation(args[1])
            fstring = get(Latexify.function2latex, fsym, "\\$(fsym)")
            "$fstring^{$(func(args[2], op))}\\left( $(join(func.(arguments(args[1]), operation(args[1])), ", ")) \\right)"
        else
            "$(func(args[1], op))^{$(func(args[2], Val{:NoSurround}()))}"
        end
    end
  end
]
end

const MATCHING_FUNCTIONS = default_matcher()