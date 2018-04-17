
function mdtext(s::String)
    m = Markdown.parse(s)
    return m
end
