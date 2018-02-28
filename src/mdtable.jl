function mdtable(M::AbstractMatrix; latex::Bool=true, head=[], side=[], transpose=false)
    transpose && (M = permutedims(M, [2,1]))
    latex && (M = latexinline(M))
    if !isempty(head)
        M = vcat(hcat(head...), M)
        @assert length(head) == size(M, 2) "The length of the head does not match the shape of the input matrix."
    end
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
    t = Markdown.parse(t)
    COPY_TO_CLIPBOARD && clipboard(t)
    return t
end

mdtable(v::AbstractArray...; kwargs...) = mdtable(hcat(v...); kwargs...)
