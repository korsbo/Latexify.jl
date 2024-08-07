# `latexify`

This is a wrapper of some of the other `latexXXX` functions. It tries to infer a suitable output mode for the given input. If the environment you are using supports the MIME type "text/latex", then the output will be rendered nicely.


```julia
using Latexify
copy_to_clipboard(true)

ex = :(x/y)
latexify(ex)

```
$\frac{x}{y}$

If you `print` the output rather than `display`, then you will enforce the print-out of a string which is ready for some copy-pasting into your LaTeX document.

```julia
println(latexify(ex))

## or the equivalent:
latexify(ex) |> println
```
```LaTeX
$\frac{x}{y}$
```

A matrix, or a single vector, is turned into an array.
```julia
M = signif.(rand(3,4), 2)

latexify(M)
```

\begin{equation}
\left[
\begin{array}{cccc}
0.85 & 0.99 & 0.85 & 0.5\\\\
0.59 & 0.061 & 0.77 & 0.48\\\\
0.7 & 0.17 & 0.7 & 0.82\\\\
\end{array}
\right]
\end{equation}

You can transpose the output using the keyword argument `transpose=true`.


If you give two vectors as an argument, they will be displayed as the left-hand-side and right-hand-side of an align environment:
```julia
latexify(["x/y", :z], Any[2.3, 1//2])
```
\begin{align}
\frac{x}{y} &= 2.3 \\\\
z &= \frac{1}{2} \\\\
\end{align}


If you input a ParameterizedFunction or a ReactionNetwork from DifferentialEquations.jl you will also get an align environment. For more on this, have a look on their respective sections.
