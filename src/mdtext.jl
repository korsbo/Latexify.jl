
function mdtext(s::AbstractString; escape_underscores = false, kwargs...)
    escape_underscores && (s = replace(s, "_"=>"\\_"))
    m = Markdown.parse(s)
    return m
end
