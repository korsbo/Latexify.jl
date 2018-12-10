
function mdtext(s::String; kwargs...)
    m = Markdown.Meta.parse(s)
    return m
end
