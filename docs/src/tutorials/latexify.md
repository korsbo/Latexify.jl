# `latexify`
takes a Julia object `x` and returns a ``\LaTeX`` formatted string. This works for `x` of many types, including expressions, which returns ``\LaTeX`` code for an equation.

```julia-repl
julia> ex = :(x-y/z)
julia> latexify(ex)
L"$x - \frac{y}{z}$"
```
In Jupyter or Hydrogen this automatically renders as:

$x - \frac{y}{z}$

Among the supported types are:
- Expressions,
- Strings,
- Numbers (including rational and complex),
- Symbols,
- Symbolic expressions from SymEngine.jl.
- ParameterizedFunctions.

It can also take arrays, which it recurses and latexifies the elements, returning an array of latex strings.
