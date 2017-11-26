latexify(x) = latexstring( latexraw(x) )
latexify(x::AbstractArray) = [ latexify(i) for i in x]
