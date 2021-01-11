
function latexbracket(x; kwargs...)
    latexstr = LaTeXString( "\\[\n" * latexraw(x; kwargs...) * "\\]\n")
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end

latexbracket(x::Union{AbstractArray, Tuple}; kwargs...) = [latexbracket(i; kwargs...) for i in x]
latexbracket(args...; kwargs...) = latexbracket(args; kwargs...)