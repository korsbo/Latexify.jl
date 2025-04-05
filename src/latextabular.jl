latextabular(args...; kwargs...) = process_latexify(args...; kwargs..., env=:tabular)

function _latextabular(arr::AbstractMatrix; latex::Bool=true, booktabs::Bool=false, head=[], side=[], adjustment=:c, transpose=false, kwargs...)
    transpose && (arr = permutedims(arr, [2,1]))

    if !isempty(head)
        arr = vcat(safereduce(hcat, head), arr)
        @assert length(head) == size(arr, 2) "The length of the head does not match the shape of the input matrix."
    end
    if !isempty(side)
        length(side) == size(arr, 1) - 1 && (side = [""; side])
        @assert length(side) == size(arr, 1) "The length of the side does not match the shape of the input matrix."
        arr = hcat(side, arr)
    end

    (rows, columns) = size(arr)

    if ~isa(adjustment, AbstractArray)
        adjustment = fill(adjustment, columns)
    end
    adjustmentstring = join(adjustment)
    str = "\\begin{tabular}{$adjustmentstring}\n"

    if booktabs
        str *= "\\toprule\n"
    end

    formatter = get(kwargs, :fmt, nothing)
    if formatter isa String
        formatter = PrintfNumberFormatter(formatter)
    end
    if formatter isa SiunitxNumberFormatter && any(==(:S), adjustment)
        # Do not format cell contents, "S" column type handles it
        formatter = string
    end

    if latex
        arr = latexinline.(arr; kwargs...)
    elseif ~isnothing(formatter)
        arr = map(x -> x isa Number ? formatter(x) : x, arr)
    end

    # print first row
    str *= join(arr[1,:], " & ")
    str *= "\\\\\n"

    if booktabs && !isempty(head)
        str *= "\\midrule\n"
    end

    for i in 2:size(arr, 1)
        str *= join(arr[i,:], " & ")
        str *= "\\\\\n"
    end

    if booktabs
        str *= "\\bottomrule\n"
    end

    str *= "\\end{tabular}\n"
    latexstr = LaTeXString(str)
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end


_latextabular(vec::AbstractVector; kwargs...) = latextabular(safereduce(hcat, vec); kwargs...)
_latextabular(vectors::AbstractVector...; kwargs...) = latextabular(safereduce(hcat, vectors); kwargs...)
_latextabular(dict::AbstractDict; kwargs...) = latextabular(hcat(collect(keys(dict)), collect(values(dict))); kwargs...)
