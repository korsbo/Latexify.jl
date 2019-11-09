function latexinline(x; kwargs...)
    latexstr = latexstring( latexraw(x; kwargs...) )
    return output(latexstr.s; kwargs...)
end

latexinline(x::Union{AbstractArray, Tuple}; kwargs...) = [ latexinline(i; kwargs...) for i in x]
latexinline(args...; kwargs...) = latexinline(args; kwargs...)
