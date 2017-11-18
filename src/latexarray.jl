
"""
    latexarray{T}(arr::AbstractArray{T, 2})
Create a LaTeX array environment using [`latexify`](@ref).

# Examples
```
arr = [1 2; 3 4]
latexarray(arr)
# output
"\\begin{equation}\n\\left[\n\\begin{array}{cc}\n1 & 2\\\\ \n3 & 4\\\\ \n\\end{array}\n\\right]\n\\end{equation}\n"
```
"""
function latexarray{T}(arr::AbstractArray{T, 2}; adjustment::Symbol=:c)
    (rows, columns) = size(arr)
    str = "\\begin{equation}\n"
    str *= "\\left[\n"
    str *= "\\begin{array}{" * "$(adjustment)"^columns * "}\n"

    isa(arr, Matrix{String}) || (arr = latexify(arr))
    for i=1:rows, j=1:columns
        str *= arr[i,j]
        j==columns ? (str *= "\\\\ \n") : (str *= " & ")
    end

    str *= "\\end{array}\n"
    str *= "\\right]\n"
    str *= "\\end{equation}\n"
end

function latexarray{T}(arr::AbstractArray{T, 1}; adjustment::Symbol=:c)
    rows = length(arr)
    columns = (1)
    str = "\\begin{equation}\n"
    str *= "\\left[\n"
    str *= "\\begin{array}{" * "$(adjustment)"^columns * "}\n"

    isa(arr, Matrix{String}) || (arr = latexify(arr))
    for i=1:rows, j=1:columns
        str *= arr[i,j]
        j==columns ? (str *= "\\\\ \n") : (str *= " & ")
    end

    str *= "\\end{array}\n"
    str *= "\\right]\n"
    str *= "\\end{equation}\n"
end
