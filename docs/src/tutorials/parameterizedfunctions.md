# Use with ParameterizedFunctions

In the [latexalign tutorial](tutorials/latexalign) I mentioned that one can use `latexalign` directly on a [ParameterizedFunction](http://docs.juliadiffeq.org/stable/analysis/parameterized_functions.html#Function-Definition-Macros-1).
Here, I make a somewhat more convoluted and hard-to-read example (you'll soon se why):

```julia
using Latexify
using DifferentialEquations
ode = @ode_def positiveFeedback begin
    dx = y*y*y/(k_y_x + y) - x - x
    dy = x^n_x/(k_x^n_x + x^n_x) - y
end k_y=>1.0 k_x=>1.0 n_x=>1

latexalign(ode)
print(latexalign(ode))
```
This generates ``\LaTeX`` code that renders as:

\begin{align}
\frac{dx}{dt} =& \frac{y \cdot y \cdot y}{k_{y\_x} + y} - x - x \\\\
\frac{dy}{dt} =& \frac{x^{n_{x}}}{k_{x}^{n_{x}} + x^{n_{x}}} - y \\\\
\end{align}

This is pretty nice, but there are a few parts of the equation which could be reduced.
Using a keyword argument, you can utilise the SymEngine.jl to reduce the expression before printing.

```julia
latexalign(ode, field=:symfuncs)
```
\begin{align}
\frac{dx}{dt} =& -2 \cdot x + \frac{y^{3}}{k_{y\_x} + y} \\\\
\frac{dy}{dt} =& - y + \frac{x^{n_{x}}}{k_{x}^{n_{x}} + x^{n_{x}}} \\\\
\end{align}



ParameterizedFunctions symbolically calculates the jacobian, inverse jacobian, hessian, and all kinds of goodness. Since they are available as arrays of symbolic expressions, which are latexifyable, you can render pretty much all of them.

```julia
latexarray(ode.symjac)
```
\begin{equation}
\left[
\begin{array}{cc}
-2 & \frac{3 \cdot y^{2}}{k_{y\_x} + y} - \frac{y^{3}}{\left( k_{y\_x} + y \right)^{2}}\\\\
\frac{x^{-1 + n_{x}} \cdot n_{x}}{k_{x}^{n_{x}} + x^{n_{x}}} - \frac{x^{-1 + 2 \cdot n_{x}} \cdot n_{x}}{\left( k_{x}^{n_{x}} + x^{n_{x}} \right)^{2}} & -1\\\\
\end{array}
\right]
\end{equation}

Pretty neat huh? And if you learn how to use `latexify`, `latexalign`, `latexraw` and `latexarray` you can really format the output in pretty much any way you want.
