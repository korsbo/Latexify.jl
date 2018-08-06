

function latextabular(arr::AbstractMatrix; latex::Bool=true, head=[], side=[], adjustment::Symbol=:c, transpose=false)
    transpose && (arr = permutedims(arr, [2,1]))

    if !isempty(head)
        arr = vcat(hcat(head...), arr)
        @assert length(head) == size(arr, 2) "The length of the head does not match the shape of the input matrix."
    end
    if !isempty(side)
        length(side) == size(arr, 1) - 1 && (side = ["."; side]) ## why is empty not allowed?
        @assert length(side) == size(arr, 1) "The length of the side does not match the shape of the input matrix."
        arr = hcat(side, arr)
    end

    (rows, columns) = size(arr)
    str = "\\begin{tabular}{" * "$(adjustment)"^columns * "}\n"

    arr =  latex ? latexinline(arr) : string.(arr)
    for i in 1:size(arr, 1)
        str *= join(arr[i,:], " & ")
        str *= "\\\\\n"
    end

    str *= "\\end{tabular}\n"
    latexstr = LaTeXString(str)
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end


latextabular(vec::AbstractVector; kwargs...) = latextabular(hcat(vec...); kwargs...)
latextabular(vectors::AbstractVector...; kwargs...) = latextabular(hcat(vectors...); kwargs...)
latextabular(dict::AbstractDict; kwargs...) = latextabular(hcat(collect(keys(dict)), collect(values(dict))); kwargs...)

@require DataFrames begin
    latextabular(d::DataFrames.DataFrame; kwargs...) =latextabular(hcat(d.columns...); head=keys(d.colindex), kwargs...)
end
