

add_matcher(f) = push!(MATCHING_FUNCTIONS, f)

_check_call_match(e, op::Symbol) = e isa Expr && e.head === :call && e.args[1] === op
_check_call_match(e, op::AbstractArray) = e isa Expr && e.head === :call && e.args[1] ∈ op

# User would write:
#   text_color_latexify(e) = "\\textcolor{$(args[1])}{$(latexify(args[2]))}"
#   add_call_matcher(text_color_latexify, :textcolor)
function add_call_matcher(op, f::Function)
    push!(MATCHING_FUNCTIONS, (expr, prevop, config) -> _check_call_match(expr, op) ? f(expr, prevop, config) : nothing)
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


const DEFAULT_CONFIG = Dict{Symbol, Any}(
  :mulsym => " \\cdot ",
  :convert_unicode => true,
  :strip_broadcast => true,
)
const CONFIG = Dict{Symbol, Any}()

getconfig(key::Symbol) = CONFIG[key]

function _latextree(expr; kwargs...)
  empty!(CONFIG)
  merge!(CONFIG, DEFAULT_CONFIG, kwargs)
  str = decend(expr)
  CONFIG[:convert_unicode] && (str = unicode2latex(str))
  return LaTeXString(str)
end
# decend(x, prevop) = string(x)
# decend(x::Expr, prevop::Symbol) = decend(x, Val{prevop}())
function decend(e, prevop=Val(:_nothing))::String
  if nested(e)
    # nested(e) || return Latexify.latexraw(e; kwargs...)
    for f in MATCHING_FUNCTIONS[end:-1:1]
        call_result = f(e, prevop, CONFIG) 
        if !isnothing(call_result) 
            return call_result
            break
        end
    end
    throw(ArgumentError("No matching expression conversion function for $e"))
  else
    return _latexraw(e; CONFIG...)
  end
end


### Overloadable formatting functions
surround(x) = "\\left( $x \\right)"

# match_equals(e) = (e isa Expr && e.head === :=) ? 
    # "$(latexify(value(lhs_val))) = $(latexify(first(rhs_array)))" :
    # nothing

function default_matcher()
return [
function report_bad_call(expr, prevop, config)
   println("Unsupported input with \nexpr=$expr\nand prevop=$prevop\n")
   return nothing
end,
   (expr, prevop, config) -> begin
   h, op, args = unpack(expr)
  #  if (expr isa LatexifyOperation || h == :LatexifyOperation) && op == :merge
   if h == :call && op == :latexifymerge
     join(decend.(args), "")
   end
  end,
  function call(expr, prevop, config)
    h, op, args = unpack(expr)
    if h == :call 
      string(get(Latexify.function2latex, op, op)) * "\\left( " * join(decend.(args, op), ",") * " \\right)"
    end
  end,
  function strip_broadcast_dot(expr, prevop, config)
    h, op, args = unpack(expr)
    if expr isa Expr && config[:strip_broadcast] && h == :call && startswith(string(op), '.')
      return string(decend(Expr(h, Symbol(string(op)[2:end]), args...), prevop))
    end
  end,
  function plusminus(expr, prevop, config)
    h, op, args = unpack(expr)
    if h == :call && op == :±
      return "$(args[1]) \\pm $(args[2])"
    end
  end,
  function division(expr, prevop, config)
    h, op, args = unpack(expr)
    if h == :call && op == :/
      "\\frac{$(decend(args[1], op))}{$(decend(args[2], op))}"
    end
  end,
  function multiplication(expr, prevop, config)
    h, op, args = unpack(expr)
    if h == :call && op == :*
      join(decend.(args, op), "$(config[:mulsym])")
    end
  end,
  function addition(expr, prevop, config)
    h, op, args = unpack(expr)
    if h == :call && op == :+
      str = join(decend.(args, op), " + ") 
      prevop ∈ [:*, :^] && (str = surround(str))
      return str
    end
  end,
  function subtraction(expr, prevop, config)
    h, op, args = unpack(expr)
    if h == :call && op == :-
      if length(args) == 1
        if operation(args[1]) == :- && length(arguments(args[1])) == 1
          return decend(arguments(args[1])[1], prevop)
        elseif args[1] isa Number && sign(args[1]) == -1
          return _latexraw(-args[1])
        else
          _arg = operation(args[1]) ∈ [:-, :+, :±] ? surround(args[1]) : args[1]
          return "$op$_arg"
        end
        
      elseif length(args) == 2
        if args[2] isa Number && sign(args[2]) == -1
          return "$(decend(args[1], :+)) + $(decend(-args[2], :+))"
        end
        if operation(args[2]) == :- && length(arguments(args[2])) == 1
          return "$(decend(args[1], :+)) + $(decend(arguments(args[2])[1], :+))"
        end
        str = join(decend.(args, op), " - ") 
        prevop ∈ [:*, :^] && (str = surround(str))
        return str
      end
    end
  end,
  function pow(expr, prevop, config)
    h, op, args = unpack(expr)
    if h == :call && op == :^
        if operation(args[1]) in Latexify.trigonometric_functions
            fsym = operation(args[1])
            fstring = get(Latexify.function2latex, fsym, "\\$(fsym)")
            "$fstring^{$(decend(args[2], op))}\\left( $(join(decend.(arguments(args[1]), operation(args[1])), ", ")) \\right)"
        else
            "$(decend(args[1], op))^{$(decend(args[2], Val{:NoSurround}()))}"
        end
    end
  end,
  function equals(expr, prevop, config)
    if expr.head == :(=) 
      return "$(decend(expr.args[1], expr.head)) = $(decend(expr.args[2], expr.head))"
    end
  end, 
  function l_funcs(ex, prevop, config)
    if head(ex) == :call && startswith(string(operation(ex)), "l_")
      l_func = string(operation(ex))[3:end]
      return "\\$(l_func){$(join(decend.(arguments(ex), prevop), "}{"))}"
    end
  end,
]
end

const MATCHING_FUNCTIONS = default_matcher()