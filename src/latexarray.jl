
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
latexarray(args...; kwargs...) = process_latexify(args...;kwargs...,env=:array)

function _latexarray(arr::AbstractArray; adjustment::Symbol=:c, transpose=false, double_linebreak=false,
    starred=false, kwargs...)
    transpose && (arr = permutedims(arr))
    rows, columns = axes(arr, 1), axes(arr, 2)

    eol = double_linebreak ? " \\\\\\\\\n" : " \\\\\n"

    str = "\\left[\n"
    str *= "\\begin{array}{" * "$(adjustment)"^length(columns) * "}\n"

    arr = latexraw.(arr; kwargs...)
    for i in rows, j in columns
        str *= arr[i,j]
        j == last(columns) ? (str *= eol) : (str *= " & ")
    end

    str *= "\\end{array}\n"
    str *= "\\right]"
    latexstr = LaTeXString(str)
    # COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end


_latexarray(args::AbstractArray...; kwargs...) = _latexarray(safereduce(hcat, args); kwargs...)
_latexarray(arg::AbstractDict; kwargs...) = _latexarray(collect(keys(arg)), collect(values(arg)); kwargs...)
_latexarray(arg::Tuple...; kwargs...) = _latexarray([collect(i) for i in arg]...; kwargs...)

function _latexarray(arg::Tuple; kwargs...)
    if first(arg) isa Tuple || first(arg) isa AbstractArray
        return _latexarray([collect(i) for i in arg]...; kwargs...)
    end
    return _latexarray(collect(arg); kwargs...)
end
