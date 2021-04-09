latexarray(args...; kwargs...) = latexify(args...;kwargs...,env=:array)

function _latexarray(arr::AbstractArray; adjustment::Symbol=:c, transpose=false, double_linebreak=false,
    starred=false, kwargs...)
    transpose && (arr = permutedims(arr))
    rows = first(size(arr))
    columns = length(size(arr)) > 1 ? size(arr)[2] : 1

    eol = double_linebreak ? " \\\\\\\\\n" : " \\\\\n"

    str = "\\left[\n"
    str *= "\\begin{array}{" * "$(adjustment)"^columns * "}\n"

    arr = decend.(arr)
    for i=1:rows, j=1:columns
        str *= arr[i,j]
        j==columns ? (str *= eol) : (str *= " & ")
    end

    str *= "\\end{array}\n"
    str *= "\\right]"
    latexstr = LaTeXString(str)
    # COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end


_latexarray(args::AbstractArray...; kwargs...) = _latexarray(reduce(hcat, args); kwargs...)
_latexarray(arg::AbstractDict; kwargs...) = _latexarray(collect(keys(arg)), collect(values(arg)); kwargs...)
_latexarray(arg::Tuple...; kwargs...) = _latexarray([collect(i) for i in arg]...; kwargs...)

function _latexarray(arg::Tuple; kwargs...)
    if first(arg) isa Tuple || first(arg) isa AbstractArray
        return _latexarray([collect(i) for i in arg]...; kwargs...)
    end
    return _latexarray(collect(arg); kwargs...)
end
