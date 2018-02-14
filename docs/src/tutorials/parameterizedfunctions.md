# Use with ParameterizedFunctions

In the [latexalign tutorial](tutorials/latexalign) I mentioned that one can use `latexalign` directly on a [ParameterizedFunction](http://docs.juliadiffeq.org/stable/analysis/parameterized_functions.html#Function-Definition-Macros-1).
Here, I make a somewhat more convoluted and hard-to-read example (you'll soon se why):

```julia
using Latexify
using DifferentialEquations
copy_to_clipboard(true)

ode = @ode_def positiveFeedback begin
    dx = y*y*y/(k_y_x + y) - x - x
    dy = x^n_x/(k_x^n_x + x^n_x) - y
end k_y k_x n_x

latexalign(ode)
```

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

### Side-by-side rendering of multiple system.

A vector of ParameterizedFunctions will be rendered side-by-side:

```julia
ode2 = @ode_def negativeFeedback begin
    dx = y/(k_y + y) - x
    dy = k_x^n_x/(k_x^n_x + x^n_x) - y
end k_y k_x n_x

latexalign([ode, ode2])
```

\begin{align}
\frac{dx}{dt}  &=  \frac{y}{k_{y} + y} - x  &  \frac{dx}{dt}  &=  \frac{y}{k_{y} + y} - x  &  \\\\
\frac{dy}{dt}  &=  \frac{x^{n_{x}}}{k_{x}^{n_{x}} + x^{n_{x}}} - y  &  \frac{dy}{dt}  &=  \frac{k_{x}^{n_{x}}}{k_{x}^{n_{x}} + x^{n_{x}}} - y  &  \\\\
\end{align}


### Visualise your parameters.

Another thing that I have found useful is to display the parameters of these functions. The parameters are usually in a vector, and if it is somewhat long, then it can be annoying to try to figure out which element belongs to which parameter. There are several ways to solve this. Here are two:
```julia
## lets say that we have some parameters
param = [3.4,5.2,1e-2]
latexify(ode.params, param)
```
\begin{align}
k_{y} =& 3.4 \\\\
k_{x} =& 5.2 \\\\
n_{x} =& 0.01 \\\\
\end{align}

or

```julia
latexarray([ode.params, param]; transpose=true)
```
\begin{equation}
\left[
\begin{array}{ccc}
k_{y} & k_{x} & n_{x}\\\\
3.4 & 5.2 & 0.01\\\\
\end{array}
\right]
\end{equation}

### Get the jacobian, hessian, etc.

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
