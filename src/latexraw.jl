const INSTRUCTIONS = Function[]
const USER_INSTRUCTIONS = Function[]
const USER_ENV_INSTRUCTIONS = Function[]

# function latexraw(io::IO, config::NamedTuple, expr)
#   # empty!(CONFIG)
#   # merge!(CONFIG, DEFAULT_CONFIG, kwargs)
#   empty!(INSTRUCTIONS)
#   append!(INSTRUCTIONS, DEFAULT_INSTRUCTIONS, USER_INSTRUCTIONS, ENV_INSTRUCTIONS)
#   descend(io, config, expr)
# #   CONFIG[:convert_unicode] && (str = unicode2latex(str))
#   return nothing
# end


function capture_function_signature(ex)
  ex.head ∉ [:function, :(=)] && throw(ArgumentError("Malformed function signature to latexify recipe macro."))
  annotated_args = ex.args[1].args[2:end]
  types = Tuple(getindex.(getfield.(annotated_args, :args), 2))
  vars = Tuple(getindex.(getfield.(annotated_args, :args), 1))
  return vars, types
end

function capture_function_body(ex)
    if ex.head == :function
    elseif ex.head == :(=)
       return ex.args[2]
    else
      throw(ArgumentError("Malformed function signature to latexify recipe macro."))
    end
end

macro latextype(expr)
  vars, types = capture_function_signature(expr)
  body = esc(capture_function_body(expr))
  io, x, prevop, config = gensym(:io), gensym(:x), gensym(:prevop), gensym(:config)
  body = MacroTools.postwalk(x -> x isa Expr && x.head == :call && x.args[1] == :descend ? Expr(x.head, x.args[1], io, x.args[2], prevop, config) : x, body)

  fname = gensym(:recipe_fn)
  return esc(quote
    push!(USER_INSTRUCTIONS, 
       function $(fname)($io, $x, $prevop, $config)
         $x isa Tuple && length($x) == $(length(vars)) || return false
         types = $types
        for i in $(eachindex(vars))
          typeof($x[i]) <: types[i] || return false 
        end
         $(vars) = $x
         $x[1] isa $(types[1]) || return false
         $body
         return true
       end
    )
  end)
end
# add_matcher(f) = push!(MATCHING_FUNCTIONS, f)

# _check_call_match(e, op::Symbol) = e isa Expr && e.head === :call && e.args[1] === op
# _check_call_match(e, op::AbstractArray) = e isa Expr && e.head === :call && e.args[1] ∈ op

# # User would write:
# #   text_color_latexify(e) = "\\textcolor{$(args[1])}{$(latexify(args[2]))}"
# #   add_call_matcher(text_color_latexify, :textcolor)
# function add_call_matcher(op, f::Function)
#     push!(MATCHING_FUNCTIONS, (expr, prevop, config) -> _check_call_match(expr, op) ? f(expr, prevop, config) : nothing)
# end


nested(::Any) = false
arguments(::Any) = nothing
operation(::Any) = nothing
head(::Any) = nothing

nested(::Expr) = true
arguments(ex::Expr) = ex.args[2:end]
operation(ex::Expr) = ex.args[1]
head(ex::Expr) = ex.head

unpack(x) = (head(x), operation(x), arguments(x))

function descend(io::IO, config::NamedTuple, e, prevop=:(_nothing))::Nothing
    config[:descend_counter][1] += 1
    for f in INSTRUCTIONS[end:-1:1]
        call_matched = f(io, config, e, prevop)::Bool
        if call_matched
            return nothing
            break
        end
    end
    throw(ArgumentError("No matching expression conversion function for $e"))
end

surround(x) = "\\left( $x \\right)"

function join_descend(io::IO, config, args, delim; prevop=nothing) 
  for arg in args[1:end-1]
    descend(io, config, arg, prevop)
    write(io, delim)
  end
  descend(io, config, args[end], prevop)
end