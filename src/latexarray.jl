
"""
    latexarray{T}(arr::AbstractArray{T, 2})
Create a LaTeX array environment using [`latexraw`](@ref).

# Examples
```julia
arr = [1 2; 3 4]
latexarray(arr)
```
```math
"\\begin{equation}\n\\left[\n\\begin{array}{cc}\n1 & 2\\\\ \n3 & 4\\\\ \n\\end{array}\n\\right]\n\\end{equation}\n"
```
"""
function latexarray{T}(arr::AbstractArray{T, 2}; adjustment::Symbol=:c)
    (rows, columns) = size(arr)
    str = "\\begin{equation}\n"
    str *= "\\left[\n"
    str *= "\\begin{array}{" * "$(adjustment)"^columns * "}\n"

    T == LaTeXStrings.LaTeXString || (arr = latexraw(arr))
    for i=1:rows, j=1:columns
        str *= arr[i,j]
        j==columns ? (str *= "\\\\ \n") : (str *= " & ")
    end

    str *= "\\end{array}\n"
    str *= "\\right]\n"
    str *= "\\end{equation}\n"
    latexstr = LaTeXString(str)
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end

function latexarray{T}(arr::AbstractArray{T, 1}; adjustment::Symbol=:c, transpose=false)
    rows = length(arr)
    str = "\\begin{equation}\n"
    str *= "\\left[\n"
    str *= "\\begin{array}{" * "$(adjustment)" * "}\n"

    T == LaTeXStrings.LaTeXString || (arr = latexraw(arr))
    for i=1:rows
        str *= arr[i]
        transpose ?  i != rows && (str *= " & ") : (str *= "\\\\ \n")
    end
    transpose && (str *= " \n")

    str *= "\\end{array}\n"
    str *= "\\right]\n"
    str *= "\\end{equation}\n"
    latexstr = LaTeXString(str)
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end
