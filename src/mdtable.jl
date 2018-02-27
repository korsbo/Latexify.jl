


function mdtable(header::AbstractVector, M::AbstractMatrix; kwargs...)
    @assert length(header) == size(M, 1) "The length of the header does not match the shape of the input matrix."
    return mdtable(hcat(header, M); kwargs...)
end

mdtable(M::AbstractArray; head=error("Header kwarg has no default."), kwargs...) = mdtable(head, M; kwargs...)

mdtable(vec::AbstractVector; kwargs...) = mdtable(hcat(vec); kwargs...)

mdtable(vecs::AbstractVector...; kwargs...) = mdtable(hcat(vecs...); kwargs...)

function mdtable(M::AbstractMatrix; math::Bool=true, head=[], side=[])
    math && (M = latexinline(M))
    isempty(head) || (M = vcat(hcat(head...), M))
    if !isempty(side)
        length(side) == size(M, 1) - 1 && (side = ["."; side]) ## why is empty not allowed?
        @assert length(side) == size(M, 1) "The length of the side does not match the shape of the input matrix."
        M = hcat(side, M)
    end

    t = "| " * join(M[1,:], " | ") * " |\n"
    t *= "| ---  "^(size(M,2)-1) * "| --- |\n"
    for i in 2:size(M,1)
        t *= "| " * join(M[i,:], " | ") * " |\n"
    end
    return Markdown.parse(t)
end
