macro latexify(oneliner)
    return quote
        $(esc(oneliner))
        latexify($(string(oneliner)))
    end
end

