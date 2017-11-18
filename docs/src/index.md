# Latexify.jl

Latexify.jl is a package which supplies functions for producing ``\LaTeX`` formatted strings from Julia objects. Among the supported input types are Julia Expressions, which gets converted to properly formatted ``\LaTeX`` maths.

## Supported objects
This package supplies functionality for latexifying objects of the following types:

- Expressions,
- Strings,
- Numbers (including rational and complex),
- DataFrames' NA type,
- Symbols,
- Symbolic expressions from SymEngine.jl.

Along with any shape of array which contains elements of the above types.

Example:
```julia-repl
julia> str = "x/(2*k_1+x^2)"
julia> print(latexify(str))

\frac{x}{2 \cdot k_{1} + x^{2}}
```

which renders as

\begin{equation\*}
\frac{x}{2 \cdot k_{1} + x^{2}}
\end{equation\*}

## Functions
