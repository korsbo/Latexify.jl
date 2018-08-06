
function mdtext(s::String)
    m = Markdown.Meta.parse(s)
    return m
end
