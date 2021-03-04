latexinline(args...;kwargs...) = latexify(args...;kwargs...,env=:inline)

function _latexinline(x; kwargs...)
    latexstr = latexstring( latexify(x; kwargs...,env=:raw) )
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end

_latexinline(x::Union{AbstractArray, Tuple}; kwargs...) = [ _latexinline(i; kwargs...) for i in x ]
_latexinline(args...; kwargs...) = _latexinline(args; kwargs...)
