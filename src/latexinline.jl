function latexinline(x)
    latexstr = latexstring( latexraw(x) )
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end

latexinline(x::AbstractArray) = [ latexinline(i) for i in x]
