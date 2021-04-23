
latexequation(args...; kwargs...) = process_latexify(args...; kwargs..., env=:equation)

function _latexequation(eq; starred=false, kwargs...)
    latexstr = latexraw(eq; kwargs...)

    str = "\\begin{equation$(starred ? "*" : "")}\n"
    str *= latexstr
    str *= "\n"
    str *= "\\end{equation$(starred ? "*" : "")}\n"
    latexstr = LaTeXString(str)
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end

