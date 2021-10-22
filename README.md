[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://korsbo.github.io/Latexify.jl/stable)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://korsbo.github.io/Latexify.jl/latest)
[![codecov](https://codecov.io/gh/korsbo/Latexify.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/korsbo/Latexify.jl)
[![Coverage Status](https://coveralls.io/repos/github/korsbo/Latexify.jl/badge.svg)](https://coveralls.io/github/korsbo/Latexify.jl)

# Latexify.jl
This is a package for generating LaTeX maths from julia objects.

This package utilises Julias
[homoiconicity](https://en.wikipedia.org/wiki/Homoiconicity) to convert
expressions to LaTeX-formatted strings.  Latexify.jl supplies functionalities
for converting a range of different Julia objects, including:

- Expressions,
- Strings,
- Numbers (including rationals and complex),
- Symbolic expressions from SymEngine.jl,
- ParameterizedFunctions and ReactionNetworks from DifferentialEquations.jl,
- Other types for which a user recipe has been defined

as well as arrays or dicts of supported types.


## Recipes
To extend Latexify to work with your own type, you define a recipe using the
`@latexrecipe` macro. See the documentation.

### Examples
#### latexifying expressions
```julia
using Latexify
ex = :(x/(y+x)^2)
latexify(ex)
```
This generates a LaTeXString (from
[LaTeXStrings.jl](https://github.com/stevengj/LaTeXStrings.jl)) which, when
printed looks like:
```LaTeX
$\frac{x}{\left( y + x \right)^{2}}$
```

And when this LaTeXString is displayed in an environment which supports the
tex/latex MIME type (Jupyter notebooks, Jupyterlab and Hydrogen for Atom) it
will automatically render as:

![fraction](/assets/demo_fraction.png)


#### latexifying other things

Latexify.jl is equipped to convert a whole range of types to latex formatted
maths. This includes primitive types such as `Symbol`s and `Complex`, but also
of containers such as `Array`s and `Dict`s.


```julia
using Latexify
print(latexify("x+y/(b-2)^2"))
```
outputs:
```LaTeX
$x + \frac{y}{\left( b - 2 \right)^{2}}$
```

```julia
arr = ["x/y" 3//7 2+3im; 1 :P_x :(gamma(3))]
latexify(arr)
```
![matrix](/assets/demo_matrix.png)

The GitHub website does not really support rendering of equations in the README
file, so I therefore refer you to the documentation for more info/examples.

#### latexifying custom types

You can add support for a type via `@latexrecipe`
```julia
using Latexify
struct Ket{T}
    x::T
end
@latexrecipe function f(x::Ket)
    return Expr(:latexifymerge, "\\left|", x.x, "\\right>")
end
latexify(:($(Ket(:a)) + $(Ket(:b))))
```

![ket](/assets/demo_ket.png)

### Use with DifferentialEquations.jl
The [DifferentialEquations.jl](http://docs.juliadiffeq.org/stable/index.html)
suite has some nifty tools for generating differential equations.
One of them is
[ParameterizedFunctions](https://github.com/JuliaDiffEq/ParameterizedFunctions.jl)
which allows you to type in an ODE in something which looks very much like just
plain mathematics.
The ability to latexify such ODEs is pretty much what lured me to create this
package.

```julia
using ParameterizedFunctions
using Latexify

f = @ode_def positiveFeedback begin
    dx = v*y^n/(k^n+y^n) - x
    dy = x/(k_2+x) - y
end v n k k_2

latexify(f)
```
outputs:

![positiveFeedback](/assets/ode_positive_feedback.png)


[DiffEqBiological.jl](https://github.com/JuliaDiffEq/DiffEqBiological.jl)
provides another cool domain-specific language which allows you to generate
equations using a chemical arrow notation.


```julia
using DiffEqBiological
using Latexify

rn = @reaction_network demoNetwork begin
  (r_bind, r_unbind), A + B ↔ C
  Hill(C, v, k, n), 0 --> X
  d_x, X --> 0
end r_bind r_unbind v k n d_x

latexify(rn)
```
![positiveFeedback](/assets/demo_rn.png)

Or you can output the arrow notation directly to latex:

```julia
latexify(rn; env=:arrow)
```
![positiveFeedback](/assets/demo_rn_arrow.png)

There are more stuff that you can do, but for that I will refer you to the
[docs](https://korsbo.github.io/Latexify.jl/stable).


## Convenience functions

- `copy_to_clipboard(::Bool)`, toggle automatic copying of the resulting LaTeX
  code to the clipboard (default is false).
- `auto_display(::Bool)` toggles automatic display of your output, even if it
  is not the last command to have run.
- `set_default(; kwargs...)`, set your own default kwargs for your Julia
  session. This is not to be used within a package since the effect is global.
- `reset_default(; kwargs...)`, reset the changes you made with the above
  command.
- `get_default(; kwargs...)`, view the changes you have made to the default
  kwargs.


## Installation
This package is registered in the Julia registry, so to install it you can just
run

```julia
Pkg.add("Latexify")
```

## Further information
For further information see the
[docs](https://korsbo.github.io/Latexify.jl/stable).

## Contributing
I would be happy to receive feedback, suggestions, and help with improving this
package. Please feel free to open an issue or a PR.

If you want to add support for types defined in another package, primarily
create a PR in that package with a recipe. Latexify.jl is not intended to be a
collection of recipes for different types. The exceptions are the few types
which were included before the recipe system was finished. If the other package
is hesitant to pull in Latexify as a dependency, you can either use
Requires.jl, or create a separate glue package. If you do add support for
another package, please help update the list below:

### Supported types and packages
* Many base types
* LaTeXStrings.jl
* DifferentialEquations.jl
* DiffEqBiological.jl
* ParametrizedFunctions.jl
* DataFrames.jl
* Symbolics.jl
* Unitful.jl (via UnitfulLatexify.jl)

And more ...
