# `latextabular`

```julia
using Latexify
copy_to_clipboard(true)
arr = ["x/y" :(y^n); 1.0 :(alpha(x))]
latextabular(arr) |> println
```

outputs:
```LaTeX
\begin{tabular}{cc}
$\frac{x}{y}$ & $y^{n}$\\
$1.0$ & $\alpha\left( x \right)$\\
\end{tabular}
```
Unfortunately, this does not render nicely in Markdown. But you get the point.


`latextabular` takes two keywords, one for changing the adjustment of the columns (centered by default), and one for transposing the whole thing.
```julia
latextabular(arr; adjustment=:l, transpose=true) |> println
```

```LaTeX
\begin{tabular}{ll}
$\frac{x}{y}$ & $1.0$\\
$y^{n}$ & $\alpha\left( x \right)$\\
\end{tabular}
```

The adjustments can be set per column by providing a vector like `[:c, :l, :r]`.
If you want to use the `S` column type from `siunitx`, set `latex=false, adjustment=:S`.
Some post-adjustment may be necessary.
