# Use with @reaction_network from DiffEqBiological.jl.

Latexify.jl has methods for dealing with AbstractReactionNetworks. For more information regarding this DSL, turn to its [docs](http://docs.juliadiffeq.org/latest/models/biological.html). The latexify end of things are pretty simple: feed a reaction network to `latexify()` and let it do its magic.

```julia
using DiffEqBiological
using Latexify
copy_to_clipboard(true)

@reaction_func hill2(x, v, k) = v*x^2/(k^2 + x^2)

rn = @reaction_network MyRnType begin
  hill2(y, v_x, k_x), 0 --> x
  p_y, 0 --> y
  (d_x, d_y), (x, y) --> 0
  (r_b, r_u), x ↔ y
end v_x k_x p_y d_x d_y r_b r_u

latexify(rn)
```
```math
\begin{align}
\frac{dx}{dt} =& \frac{v_{x} \cdot y^{2}}{k_{x}^{2} + y^{2}} - d_{x} \cdot x - r_{b} \cdot x + r_{u} \cdot y \\
\frac{dy}{dt} =& p_{y} - d_{y} \cdot y + r_{b} \cdot x - r_{u} \cdot y \\
\end{align}
```

The method has a keyword for choosing between outputting the ODE or the noise term. While it is not obvious from the latexify output, the noise in the reaction network is correlated.

```julia
latexify(rn; noise=true)
```

```math
\begin{align}
\frac{dx}{dt} =& \sqrt{\frac{v_{x} \cdot y^{2}}{k_{x}^{2} + y^{2}}} - \sqrt{d_{x} \cdot x} - \sqrt{r_{b} \cdot x} + \sqrt{r_{u} \cdot y} \\
\frac{dy}{dt} =& \sqrt{p_{y}} - \sqrt{d_{y} \cdot y} + \sqrt{r_{b} \cdot x} - \sqrt{r_{u} \cdot y} \\
\end{align}
```


## Chemical arrow notation

DiffEqBiologicals reaction network is all about chemical arrow notation, so why should we not be able to render arrows?

Use `latexify`'s `env` keyword argument to specify that you want `:chemical` (or the equivalent `:arrow`, `:arrows` or `:chem`).

```julia
latexify(rn; env=:chemical)
```
\begin{align}
\require{mhchem}
\ce{ \varnothing &->[\frac{v_{x} \cdot y^{2}}{k_{x}^{2} + y^{2}}] x}\\\\
\ce{ \varnothing &->[p_{y}] y}\\\\
\ce{ x &->[d_{x}] \varnothing}\\\\
\ce{ y &->[d_{y}] \varnothing}\\\\
\ce{ x &<=>[{r_{b}}][{r_{u}}] y}\\\\
\end{align}

The default output is meant to be rendered directly on the screen. This rendering is typically done by MathJax. To get the chemical arrow notation to render automatically, I have included a MathJax command (`\require{mhchem}`) in the output string. If you want to use the output in a real LaTeX document, you can pass the keyword argument `mathjax=false` and this extra command will be omitted. In such case you should also add `\usepackage{mhchem}` to the preamble of your latex document.

Another keyword argument that may be of use is `expand=false` (defaults to `true`).
This determines whether your functions should be expanded or not.
Also, `starred=true` will change the outputted latex environment from `align` to `align*`. This results in the equations not being numbered.

```julia
latexify(rn; env=:chemical, expand=false, starred=true)
```

```math
\begin{align*}
\require{mhchem}
\ce{ \varnothing &->[\mathrm{hill2}\left( y, v_{x}, k_{x} \right)] x}\\
\ce{ \varnothing &->[p_{y}] y}\\
\ce{ x &->[d_{x}] \varnothing}\\
\ce{ y &->[d_{y}] \varnothing}\\
\ce{ x &<=>[{r_{b}}][{r_{u}}] y}\\
\end{align*}
```

## Available options
### Align
```@eval
include("src/table_generator.jl")
args = [arg for arg in keyword_arguments if (:ReactionNetwork in arg.types || :Any in arg.types) && :align in arg.env]
latexify(args, env=:mdtable, types=false)
```

### Arrow notation
```@eval
include("src/table_generator.jl")
args = [arg for arg in keyword_arguments if (:ReactionNetwork in arg.types || :Any in arg.types) && :arrow in arg.env]
latexify(args, env=:mdtable, types=false)
```
