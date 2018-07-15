
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
function latexarray(arr::AbstractMatrix; adjustment::Symbol=:c, transpose=false, double_linebreak=false,
    starred=false)
    transpose && (arr = permutedims(arr, [2,1]))
    (rows, columns) = size(arr)
    eol = double_linebreak ? " \\\\\\\\ \n" : " \\\\ \n"

    str = "\\begin{equation$(starred ? "*" : "")}\n"
    str *= "\\left[\n"
    str *= "\\begin{array}{" * "$(adjustment)"^columns * "}\n"

    arr = latexraw(arr)
    for i=1:rows, j=1:columns
        str *= arr[i,j]
        j==columns ? (str *= eol) : (str *= " & ")
    end

    str *= "\\end{array}\n"
    str *= "\\right]\n"
    str *= "\\end{equation$(starred ? "*" : "")}\n"
    latexstr = LaTeXString(str)
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end


latexarray(vec::AbstractVector; kwargs...) = latexarray(hcat(vec...); kwargs...)
latexarray(args::AbstractArray...; kwargs...) = latexarray(hcat(args...); kwargs...)
latexarray(ass::Associative; kwargs...) = latexarray(collect(keys(ass)), collect(values(ass)); kwargs...)
