

function latextabular(arr::AbstractMatrix; adjustment::Symbol=:c, transpose=false)
    transpose && (arr = permutedims(arr, [2,1]))
    (rows, columns) = size(arr)
    str = "\\begin{tabular}{" * "$(adjustment)"^columns * "}\n"

    arr = latexinline(arr)
    for i=1:rows, j=1:columns
        str *= arr[i,j]
        j==columns ? (str *= "\\\\ \n") : (str *= " & ")
    end

    str *= "\\end{tabular}\n"
    latexstr = LaTeXString(str)
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end


latextabular(vec::AbstractVector; kwargs...) = latextabular(hcat(vec...); kwargs...)
latextabular(vectors::AbstractVector...; kwargs...) = latextabular(hcat(vectors...); kwargs...)
