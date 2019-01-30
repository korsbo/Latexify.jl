
function mdtext(s::String; escape_underscores = false, kwargs...)
    escape_underscores && (s = replace(s, "_"=>"\\_"))
    m = Markdown.parse(s)
    return m
end
