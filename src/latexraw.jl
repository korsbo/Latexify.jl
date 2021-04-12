function latexraw(expr; kwargs...)
  empty!(CONFIG)
  merge!(CONFIG, DEFAULT_CONFIG, kwargs)
  io = IOBuffer(; append=true)
  decend(io, expr)
  str = String(take!(io))
#   CONFIG[:convert_unicode] && (str = unicode2latex(str))
  return LaTeXString(str)
end

add_matcher(f) = push!(MATCHING_FUNCTIONS, f)

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

function decend(io::IO, e, prevop=Val(:_nothing))::Nothing
    for f in MATCHING_FUNCTIONS_TEST[end:-1:1]
        call_result = f(io, e, prevop, CONFIG) 
        if !(call_result === nothing)
            return nothing
            break
        end
    end
    throw(ArgumentError("No matching expression conversion function for $e"))
end

surround(x) = "\\left( $x \\right)"

function join_decend(io::IO, args, delim; prevop=nothing) 
  for arg in args[1:end-1]
    decend(io, arg, prevop)
    write(io, delim)
  end
  decend(io, args[end], prevop)
end