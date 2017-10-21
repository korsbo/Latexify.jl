
"""
    latexarray{T}(arr::AbstractArray{T, 2})
Create a LaTeX array environment using [`latexify`](@ref).
"""
function latexarray{T}(arr::AbstractArray{T, 2}; adjustment::Symbol=:c)
    (rows, columns) = size(arr)
    str = "\\begin{equation}\n"
    str *= "\\left[\n"
    str *= "\\begin{array}{" * "$(adjustment)"^columns * "}\n"

    isa(arr, Matrix{String}) || (arr = latexify(arr))
    for i=1:rows, j=1:columns
        str *= arr[i,j]
        j==rows ? (str *= "\\\\ \n") : (str *= " & ")
    end

    str *= "\\end{array}\n"
    str *= "\\right]\n"
    str *= "\\end{equation}\n"
end
