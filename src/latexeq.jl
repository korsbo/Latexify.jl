latexeq(x) = "\$" * latexify(x) * "\$"
latexeq(x::AbstractArray) = [ latexeq(i) for i in x]
