macro latexify(oneliner)
    rhs = oneliner.args[1]
    lhs = oneliner.args[2].args[end]
    return quote
        $(esc(oneliner))
        latexify($(string(rhs) * " = " * string(lhs)))
    end
end
