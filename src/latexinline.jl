latexinline(args...;kwargs...) = process_latexify(args...;kwargs...,env=:inline)

function _latexinline(x; kwargs...)
    latexstr = latexstring( process_latexify(x; kwargs...,env=:raw) )
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end