
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

function _latexarray(
        arr::AbstractArray; adjustment=:c, transpose=false,
        double_linebreak=false, starred=false, arraystyle=:square, kwargs...
    )
    if !(0 < ndims(arr) < 3)
        sentinel = get(kwargs, :sentinel, nothing)
        isnothing(sentinel) && throw(UnrepresentableException("n-dimensional tensors with n≠1,2"))
        return sentinel
    end
    transpose && (arr = permutedims(arr))
    rows, columns = axes(arr, 1), axes(arr, 2)

    eol = double_linebreak ? " \\\\\\\\\n" : " \\\\\n"

    if adjustment isa AbstractArray
        adjustmentstring = join(adjustment)
    else
        adjustmentstring = string(adjustment)^length(columns)
    end

    need_adjustmentstring = true
    if arraystyle in AMSMATH_MATRICES ||
        arraystyle isa NTuple{3,String} && arraystyle[3] == "matrix"
        need_adjustmentstring = false
    end
    if arraystyle isa String
        arraystyle = ("", "", arraystyle)
    elseif arraystyle isa Symbol
        arraystyle = ARRAYSTYLES[arraystyle]
    end

    str = string(arraystyle[1], "\\begin{", arraystyle[3], "}")
    if need_adjustmentstring
        str = str * string("{", adjustmentstring, "}\n")
    else
        str = str * "\n"
    end

    for i in rows, j in columns
        if isassigned(arr, i, j)
            str *= latexraw(arr[i,j]; kwargs...)
        else
            str *= raw"\cdot"
        end
        j == last(columns) ? (str *= eol) : (str *= " & ")
    end

    str *= string("\\end{", arraystyle[3], '}', arraystyle[2])
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

const ARRAYSTYLES = Dict{Symbol, NTuple{3, String}}(
                                                                         :array=>("", "", "array"),
                                        :square=>("\\left[\n", "\n\\right]", "array"),
                                        :round=>("\\left(\n", "\n\\right)", "array"),
                                        :curly=>("\\left\\{\n", "\n\\right\\}", "array"),
                                        :matrix=>("","","matrix"),
                                        :pmatrix=>("","","pmatrix"),
                                        :bmatrix=>("","","bmatrix"),
                                        :Bmatrix=>("","","Bmatrix"),
                                        :vmatrix=>("","","vmatrix"),
                                        :Vmatrix=>("","","Vmatrix"),
                                       )
const AMSMATH_MATRICES = [:matrix, :pmatrix, :bmatrix, :Bmatrix, :vmatrix, :Vmatrix]
