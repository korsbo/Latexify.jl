# latexarray(args...; kwargs...) = latexify(args...;kwargs...,env=:array)
latexarray(args...; kwargs...) = _latexarray(args...;kwargs...)

function _latexarray(arr::AbstractArray)
    adjustment = getconfig(:adjustment)
    transpose = getconfig(:transpose)
    double_linebreak = getconfig(:double_linebreak)
    starred = getconfig(:starred)

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


_latexarray(args::AbstractArray...) = _latexarray(reduce(hcat, args))
_latexarray(arg::AbstractDict) = _latexarray(collect(keys(arg)), collect(values(arg)))
_latexarray(arg::Tuple...) = _latexarray([collect(i) for i in arg]...)

function _latexarray(arg::Tuple)
    if first(arg) isa Tuple || first(arg) isa AbstractArray
        return _latexarray([collect(i) for i in arg]...)
    end
    return _latexarray(collect(arg))
end
