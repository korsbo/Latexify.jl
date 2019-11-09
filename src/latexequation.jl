
function latexequation end

function latexequation(eq; starred=false, kwargs...)
    latexstr = latexraw(eq; kwargs...)

    str = "\\begin{equation$(starred ? "*" : "")}\n"
    str *= latexstr
    str *= "\n"
    str *= "\\end{equation$(starred ? "*" : "")}\n"
    return output(str; kwargs...)
end

