latexbracket(args...; kwargs...) = latexify(args...; kwargs..., env=:bracket)

function _latexbracket(x; kwargs...)
    latexstr = LaTeXString( "\\[\n" * latexraw(x; kwargs...) * "\\]\n")
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end

_latexbracket(x::Union{AbstractArray, Tuple}; kwargs...) = [latexbracket(i; kwargs...) for i in x]
_latexbracket(args...; kwargs...) = latexbracket(args; kwargs...)
