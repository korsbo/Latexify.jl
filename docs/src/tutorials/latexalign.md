
# [`latexalign`](@id latexalign_tutorial)

This function converts its input to ``\LaTeX`` align environments.
One way of using the function is to pass it two vectors, one which holds the left-hand-side of the equations and the other which holds the right. For example:


```julia
lhs = ["dx/dt", "dy/dt"]
rhs = ["y^2 - x", "x/y - y"]
print(latexalign(lhs, rhs))
```
outputs:

```maths
\begin{align}
\frac{dx}{dt} =& y^{2} - x \\
\frac{dy}{dt} =& \frac{x}{y} - y \\
\end{align}
```

In Jupyter, this can be rendered by:
```julia
display( latexalign(lhs, rhs))
```

\begin{align\*}
\frac{dx}{dt} =& y^{2} - x \\\\
\frac{dy}{dt} =& \frac{x}{y} - y \\\\
\end{align\*}


## Using DifferentialEquations.jl

The motivation for creating this function was mainly to be able to render ODEs.
In my own work, I tend to use [DifferentialEquations.jl](http://docs.juliadiffeq.org/stable/index.html) to define ODEs as [ParameterizedFunctions](http://docs.juliadiffeq.org/stable/analysis/parameterized_functions.html#Function-Definition-Macros-1).
Therefore, I found it useful to create a method which simply takes the ParameterizedFunction as input:

```julia
using Latexify
using DifferentialEquations
ode = @ode_def positiveFeedback begin
    dx = y/(k_y + y) - x
    dy = x^n_x/(k_x^n_x + x^n_x) - y
end k_y k_x n_x

latexalign(ode)
```

\begin{align}
\frac{dx}{dt} =& \frac{y}{k_{y} + y} - x \\\\
\frac{dy}{dt} =& \frac{x^{n_{x}}}{k_{x}^{n_{x}} + x^{n_{x}}} - y \\\\
\end{align}
