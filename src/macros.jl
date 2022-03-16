"""
    @latexify expression

Create `LaTeXString` representing `expression`.
Variables and expressions can be interpolated with `\$`.
Keyword arguments can be supplied to `latexify` by appending to the argument.

# Examples
```julia-repl
julia> @latexify x^2 + 3/2
L"\$x^{2} + \\frac{3}{2}\$"

julia> @latexify x^2 + \$(3/2)
L"\$x^{2} + 1.5\$"

julia> @latexify x^2 + 3/2 env=:raw
L"x^{2} + \\frac{3}{2}"
```

See also [`latexify`](@ref), [`@latexrun`](@ref), [`@latexdefine`](@ref).
"""
macro latexify(expr, kwargs...)
    return esc(
        Expr(
            :call, :latexify, Expr(:parameters, _extractparam.(kwargs)...), Meta.quot(expr)
        ),
    )
end

"""
    @latexrun expression

Latexify and evaluate `expression`. Useful for expressions with side effects, like assignments.

# Examples
```julia-repl
julia> @latexrun y = 3/2 + \$(3/2)
L"\$y = \\frac{3}{2} + 1.5\$"

julia> y
3.0
```
See also [`@latexify`](@ref), [`@latexdefine`](@ref).
"""
macro latexrun(expr, kwargs...)
    return esc(
        Expr(
            :block,
            _executable(expr),
            Expr(
                :call,
                :latexify,
                Expr(:parameters, _extractparam.(kwargs)...),
                Meta.quot(expr),
            ),
        ),
    )
end

"""
    @latexdefine expression

Latexify `expression`, followed by an equals sign and the return value of its evaluation.
Any side effects of the expression, like assignments, are evaluated as well.

# Examples
```julia-repl
julia> @latexdefine y = 3/2 + \$(3/2) env=:equation
L"\\begin{equation}
y = \\frac{3}{2} + 1.5 = 3.0
\\end{equation}
"

julia> y
3.0
```
See also [`@latexify`](@ref), [`@latexrun`](@ref).
"""
macro latexdefine(expr, kwargs...)
    return esc(
        Expr(
            :call,
            :latexify,
            Expr(:parameters, _extractparam.(kwargs)...),
            Expr(:call, :Expr, QuoteNode(:(=)), Meta.quot(expr), _executable(expr)),
        ),
    )
end

function _executable(expr)
    return postwalk(expr) do ex
        if ex isa Expr && ex.head == :$
            return ex.args[1]
        end
        return ex
    end
end

_extractparam(arg::Symbol) = arg
_extractparam(arg::Expr) = Expr(:kw, arg.args[1], arg.args[2])
