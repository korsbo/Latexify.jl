# Use with @reaction_network from DiffEqBiological.jl.

Latexify.jl has methods for dealing with AbstractReactionNetworks. For more information regarding this DSL, turn to its [docs](http://docs.juliadiffeq.org/latest/models/biological.html). The latexify end of things are pretty simple: feed a reaction network to the `latexify` or `latexalign` functions (they do the same thing in this case) and let them do their magic.

```julia
using DifferentialEquations
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
\begin{align}
\frac{dx}{dt} =& - x \cdot d_{x} - x \cdot r_{b} + y \cdot r_{u} + \frac{y^{2} \cdot v_{x}}{k_{x}^{2} + y^{2}} \\\\
\frac{dy}{dt} =& p_{y} + x \cdot r_{b} - y \cdot d_{y} - y \cdot r_{u} \\\\
\end{align}

The method has a keyword for choosing between outputting the ODE or the noise term. While it is not obvious from the latexify output, the noise in the reaction network is correlated.

```julia
latexify(rn; noise=true)
```
\begin{align}
\frac{dx}{dt} =& - \sqrt{x \cdot d_{x}} - \sqrt{x \cdot r_{b}} + \sqrt{y \cdot r_{u}} + \sqrt{\frac{y^{2} \cdot v_{x}}{k_{x}^{2} + y^{2}}} \\\\
\frac{dy}{dt} =& \sqrt{p_{y}} + \sqrt{x \cdot r_{b}} - \sqrt{y \cdot d_{y}} - \sqrt{y \cdot r_{u}} \\\\
\end{align}


### Turning off the SymEngine magic

SymEngine will be used by default to clean up the expressions. A disadvantage of this is that the order of the terms and the operations within the terms becomes unpredictable. You can therefore turn this symbolic magic off. The result has some ugly issues with $+ -1$, but the option is there, and here is how to use it:  
```julia
latexify(rn; symbolic=false)
```
\begin{align}
\frac{dx}{dt} =& \frac{v_{x} \cdot y^{2}}{k_{x}^{2} + y^{2}} + -1 \cdot d_{x} \cdot x + -1 \cdot r_{b} \cdot x + r_{u} \cdot y \\\\
\frac{dy}{dt} =& p_{y} + -1 \cdot d_{y} \cdot y + r_{b} \cdot x + -1 \cdot r_{u} \cdot y \\\\
\end{align}

```julia
latexify(rn; noise=true, symbolic=false)
```
\begin{align}
\frac{dx}{dt} =& \sqrt{\frac{v_{x} \cdot y^{2}}{k_{x}^{2} + y^{2}}} + - \sqrt{d_{x} \cdot x} + - \sqrt{r_{b} \cdot x} + \sqrt{r_{u} \cdot y} \\\\
\frac{dy}{dt} =& \sqrt{p_{y}} + - \sqrt{d_{y} \cdot y} + \sqrt{r_{b} \cdot x} + - \sqrt{r_{u} \cdot y} \\\\
\end{align}

### Getting the jacobian.

The ReactionNetwork type has a field for a symbolically calculated jacobian. This can be rendered by:

```julia
latexarray(rn.symjac)
```
\begin{equation}
\left[
\begin{array}{cc}
- d_{x} - r_{b} & r_{u} + \frac{2 \cdot y \cdot v_{x}}{k_{x}^{2} + y^{2}} - \frac{2 \cdot y^{3} \cdot v_{x}}{\left( k_{x}^{2} + y^{2} \right)^{2}}\\\\
r_{b} & - d_{y} - r_{u}\\\\
\end{array}
\right]
\end{equation}


The DiffEqBiological package is currently undergoing development, but when the reaction network type gets extended with invers Jacobians, Hessians, etc, latexarray will be able to latexify them.
