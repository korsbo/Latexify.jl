function latexinline(x; kwargs...)
    latexstr = latexstring( latexraw(x; kwargs...) )
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end

latexinline(x::Union{AbstractArray, Tuple}; kwargs...) = [ latexinline(i; kwargs...) for i in x]
latexinline(args...; kwargs...) = latexinline(args; kwargs...)
