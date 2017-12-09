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

### `latexraw(x)`

Latexifies an object `x` and returns a ``\LaTeX`` formatted string.
If the input is an array, `latexraw` recurses it and latexifies its elements.

This function does not surround the resulting string in any ``\LaTeX`` environments.

### `latexify(x)`
Passes `x` to `latexraw`, but converts the output to a LaTeXString and surrounds it with a simple \$\$ environment.

### `latexalign()`
Latexifies input and surrounds it with an align environment. Useful for systems of equations and such fun stuff.

### `latexarray()`
Latexifies a 1 or 2D array and generates a corresponding ``\LaTeX`` array.


## Automatic copying to clipboard
The strings that you would see when using print on any of the above functions can be automatically copied to the clipboard if you so specify.
Since I do not wish to mess with your clipboard without you knowing it, this feature must be activated by you.

To do so, run

'''julia
Latexify.copy_to_clipboard(true)
'''

To once again disable the feature, pass `false` to the same function.

The copying to the clipboard will now occur at every call to a Latexify.jl function, regardless of how you chose to display the output.
