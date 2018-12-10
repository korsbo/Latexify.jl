function latexinline(x; kwargs...)
    latexstr = latexstring( latexraw(x; kwargs...) )
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end

latexinline(x::AbstractArray; kwargs...) = [ latexinline(i; kwargs...) for i in x]
