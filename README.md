[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://korsbo.github.io/Latexify.jl/stable)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://korsbo.github.io/Latexify.jl/latest)
[![Build Status](https://travis-ci.org/korsbo/Latexify.jl.svg?branch=master)](https://travis-ci.org/korsbo/Latexify.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/f72vlmuvlpux7x6p?svg=true)](https://ci.appveyor.com/project/korsbo/latexify-jl)
[![codecov](https://codecov.io/gh/korsbo/Latexify.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/korsbo/Latexify.jl)
[![Coverage Status](https://coveralls.io/repos/github/korsbo/Latexify.jl/badge.svg)](https://coveralls.io/github/korsbo/Latexify.jl)

# Latexify.jl
This is a package for generating LaTeX maths from julia objects.

This package utilises Julias [homoiconicity](https://en.wikipedia.org/wiki/Homoiconicity) to convert expressions to LaTeX-formatted strings.
This package supplies functionalities for converting a range of different Julia objects, including:

- Expressions,
- Strings,
- Numbers (including rationals and complex),
- Symbolic expressions from SymEngine.jl,
- ParameterizedFunctions from DifferentialEquations.jl

as well as arrays of any supported types.

Latexify.jl supplies a few functions:
- `latexraw`, a function that all other eventually uses. This latexifies objects and returns a string which does not contain a surrounding `\LaTeX` environment.
- `latexify`, calls `latexraw` but converts the output to a LaTeXString which is automatically rendered in Jupyter or Hydrogen, and which surrounds the output string with $$.
- 'latexalign', generates a latex align environment.
- 'latexarray', generates a latex array.

### Examples
#### latexifying expressions
```julia
julia> using Latexify
julia> ex = :(x/(y+x)^2)
julia> latexstring = latexify(ex)
julia> print(latexstring)
```
results in:
```LaTeX
\frac{x}{(y+x)^{2}}
```

#### latexifying strings
```julia-repl
julia> using Latexify
julia> print(latexraw("x+y/(b-2)^2"))
x + \frac{y}{\left( b - 2 \right)^{2}}
```

### use with ParameterizedFunctions
ParameterizedFunctions is a part of the [DifferentialEquations.jl](http://docs.juliadiffeq.org/stable/index.html) suite.
The ability to latexify an ODE is pretty much what lured me to create this package.

```julia
using DifferentialEquations
using Latexify

f = @ode_def positiveFeedback begin
    dx = v*y^n/(k^n+y^n) - x
    dy = x/(k_2+x) - y
end v=>1.0 n=>1.0 k=>1.0 k_2=>1.0

print( latexalign(f) )
```
outputs:
```LaTeX
\begin{align}
\frac{dx}{dt} =&  \frac{v \cdot y^{n}}{k^{n} + y^{n}} - x \\
\frac{dy}{dt} =&  \frac{x}{k_2 + x} - y \\
\end{align}
```

This can be useful for lazy people, like me, who don't want to type out equations.
But if you use Jupyter (or Atom with Hydrogen), it can also be useful to get a more clear view of your equations.
By using a string type supplied by [LaTeXStrings.jl](https://github.com/stevengj/LaTeXStrings.jl) the output of all functions except `latexraw` is automatically rendered. I cannot demonstrate this in the README, since github markdown does not support rendering, but for some examples you can see the [docs](https://korsbo.github.io/Latexify.jl/stable).


## Installation
This package is registered with METADATA.jl, so to install it you can just run

```julia
Pkg.add("Latexify")
```

You can access the functions by
```julia
using Latexify
```

## Further information
For further information see the [docs](https://korsbo.github.io/Latexify.jl/stable).

## Contributing
I would be happy to receive feedback, suggestions, and help with improving this package.
Please feel free to open an issue.
