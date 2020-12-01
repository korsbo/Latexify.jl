# Use with Unitful.jl (units and quantities)

Latexify.jl can latexify Unitful's `FreeUnits` and `Quantity` objects. There are (essentially) two different ways of writing units in LaTeX, either with `\mathrm` (this is a more portable option, but less fancy and customizeable, this is the default) or with the siunitx package (the prettiest way to print units, but less likely to work in axis labels etc.)

```julia
using Unitful
using Latexify

u = u"kg * m / s^2"
q = 612.2u"nm"

latexify(u) # or equivalently latexify(u,unitformat=:mathrm)
latexify(q) # or latexify(q,unitformat=:mathrm)

latexify(u,unitformat=:siunitx)
latexify(q,unitformat=:siunitx)
```

```latex
$\mathrm{kg}\mathrm{m}\mathrm{s}^{-2}$
$612.2\;\mathrm{nm}$

$\si{\kilo\gram\per\second\tothe{2}}$
$\SI{612.2}{\nano\meter}$
```

```math
\require{siunitx}
\begin{gather}
\mathrm{kg}\mathrm{m}\mathrm{s}^{-2} \\
612.2\;\mathrm{nm} \\
\si{\kilo\gram\per\meter\tothe{2}}\\
\SI{612.2}{\nano\meter}
\end{gather}
```
