# `latexify`
takes a Julia object `x` and returns a ``\LaTeX`` formatted string. This works for `x` of many types, including expressions, which returns ``\LaTeX`` code for an equation.

```julia
julia> ex = :(x-y/z)
julia> latexify(ex)
"x - \\frac{y}{z}"
```

Among the supported types are:
- Expressions,
- Strings,
- Numbers (including rational and complex),
- DataFrames' NA type,
- Symbols,
- Symbolic expressions from SymEngine.jl.

It can also take arrays, which it recurses and latexifies the elements, returning an array of latex strings.
