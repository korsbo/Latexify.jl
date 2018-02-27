


function mdtable(header::AbstractVector, M::AbstractMatrix; kwargs...)
    @assert length(header) == size(M, 1) "The length of the header does not match the shape of the input matrix."
    return mdtable(hcat(header, M); kwargs...)
end

mdtable(M::AbstractArray; head=error("Header kwarg has no default."), kwargs...) = mdtable(head, M; kwargs...)

mdtable(vec::AbstractVector; kwargs...) = mdtable(hcat(vec); kwargs...)

mdtable(vecs::AbstractVector...; kwargs...) = mdtable(hcat(vecs...); kwargs...)

function mdtable(M::AbstractMatrix; math::Bool=true, head=[])
    math && (M = latexify.(M))
    isempty(head) || (M = hcat(head, M))
    t = "| " * join(M[:,1], " | ") * " |\n"
    t *= "| ---  "^(size(M,1)-1) * "| --- |\n"
    for i in 2:size(M,2)
        t *= "| " * join(M[:,i], " | ") * " |\n"
    end
    return Markdown.parse(t)
end
