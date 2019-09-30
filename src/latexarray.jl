
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
function latexarray(arr::AbstractArray; adjustment::Symbol=:c, transpose=false, double_linebreak=false,
    starred=false, kwargs...)
    transpose && (arr = permutedims(arr))
    rows = first(size(arr))
    columns = length(size(arr)) > 1 ? size(arr)[2] : 1

    eol = double_linebreak ? " \\\\\\\\\n" : " \\\\\n"

    str = "\\begin{equation$(starred ? "*" : "")}\n"
    str *= "\\left[\n"
    str *= "\\begin{array}{" * "$(adjustment)"^columns * "}\n"

    arr = latexraw(arr; kwargs...)
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


latexarray(args::AbstractArray...; kwargs...) = latexarray(hcat(args...); kwargs...)
latexarray(arg::AbstractDict; kwargs...) = latexarray(collect(keys(arg)), collect(values(arg)); kwargs...)
latexarray(arg::Tuple...; kwargs...) = latexarray([collect(i) for i in arg]...; kwargs...)

function latexarray(arg::Tuple; kwargs...) 
    if first(arg) isa Tuple || first(arg) isa AbstractArray
        return latexarray([collect(i) for i in arg]...; kwargs...)
    end
    return latexarray(collect(arg); kwargs...)
end
