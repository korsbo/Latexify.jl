

function md(s::String)
    m = Markdown.parse(s)
    COPY_TO_CLIPBOARD && clipboard(m)
    return m
end

md(v::AbstractArray...; kwargs...) = mdtable(v...; kwargs...)
md(d::Associative; kwargs...) = mdtable(d; kwargs...)
