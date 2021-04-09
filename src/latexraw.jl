function latexraw(expr; kwargs...)
  empty!(CONFIG)
  merge!(CONFIG, DEFAULT_CONFIG, kwargs)
  str = decend(expr)
  CONFIG[:convert_unicode] && (str = unicode2latex(str))
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

function decend(e, prevop=Val(:_nothing))::String
    for f in MATCHING_FUNCTIONS[end:-1:1]
        call_result = f(e, prevop, CONFIG) 
        if !(call_result === nothing)
            return call_result
            break
        end
    end
    throw(ArgumentError("No matching expression conversion function for $e"))
end

surround(x) = "\\left( $x \\right)"