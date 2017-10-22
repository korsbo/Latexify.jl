[![Build Status](https://travis-ci.org/korsbo/Latexify.jl.svg?branch=master)](https://travis-ci.org/korsbo/Latexify.jl)

# Latexify.jl
This is a package for generating LaTeX maths from either julia expressions or ParameterizedFunctions.

This is done using the function latexify.
latexify has methods for handling expressions, arrays of expressions, or ParameterizedFunctions.


### use with Expr
```
using Latexify

ex = :(x/(y+x)^2)
latexstring = latexify(ex)
print(latexstring)
```
results in:
```
\frac{x}{(y+x)^{2}}
```

### use with ParameterizedFunctions
ParameterizedFunctions is a part of the DifferentialEquations.jl suite.
The ability to latexify an ODE is pretty much what lured me to create this package.

```
using DifferentialEquations
using Latexify

f = @ode_def positiveFeedback begin
    dx = v*y^n/(k^n+y^n) - x
    dy = x/(k_2+x) - y
end v=>1.0 n=>1.0 k=>1.0 k_2=>1.0

print( latexify(f) )
```
outputs:
```
\begin{align}
\frac{dx}{dt} =&  \frac{v \cdot y^{n}}{k^{n} + y^{n}} - x \\
\frac{dy}{dt} =&  \frac{x}{k_2 + x} - y \\
 \end{align}
```

This can be useful for lazy people, like me, who don't want to type out equations.
But if you use Jupyter, it can also be useful to get a more clear view of your equations.
Latex can be rendered using:
```
display("text/latex", latexify(f))
```
I find this to be more readable than the ODE definition, and I'm therefore more likely to spot errors.
