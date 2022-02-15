macro latexrun(expr)
    return esc(
        Expr(
            :block,
            postwalk(expr) do ex
                if ex isa Expr && ex.head == :$
                    return ex.args[1]
                end
                return ex
            end,
            :(latexify($(Meta.quot(expr)))),
        )
    )
end

macro latexify(expr)
    return esc(:(latexify($(Meta.quot(expr)))))
end
