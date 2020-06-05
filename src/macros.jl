macro latexrun(expr)
    return quote
        $(esc(expr))
        latexify($(string(expr)))
    end
end


macro latexify(expr)
    return quote
        latexify($(string(expr)))
    end
end
