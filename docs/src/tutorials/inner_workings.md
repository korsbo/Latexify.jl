# Inner workings

This package contains a large number of methods, but two of these are of special importance.
These are:

- `latexraw(ex::Expr)`

and

- `latexoperation(ex::Expr, prevOp::AbstractArray)`

These two methods are involved with all conversions to ``\LaTeX`` equations.

`latexraw(ex::Expr)` utilises Julias homoiconicity to infer the correct latexification of an expression by recursing through the expression tree. Whenever it hits the end of a recursion it passes the last expression to `latexoperation()`.
By the nature of this recursion, this expression is one which only contains symbols or strings.

## Explanation by example

Let's define a variable of the expression type:
```julia-repl
julia> ex = :(x + y/z)
```

This expression has a field which contains the first operation which must be done, along with the objects that this operation will operate on:
```julia-repl
julia> ex.args

3-element Array{Any,1}:
 :+
 :x
 :(y / z)
```

The first two element are both Symbols, while the third one is an expression:
```julia-repl
julia> typeof.(ex.args)

3-element Array{DataType,1}:
 Symbol
 Symbol
 Expr
```

Since at least one of these elements is an expression, the next step of the recursive algorithm is to dive into that expression:

```julia-repl
julia> newEX = ex.args[3]
julia> newEx.args

3-element Array{Any,1}:
 :/
 :y
 :z
```

Since none of these arguments is another expression, `newEx` will be passed to `latexoperation()`.
This function checks which mathematical operation is being done and converts newEx to an appropriately formatted string.
In this case, that string will be "\\\\frac{y}{z}" (and yes, a double slash is needed).

`newEx` is now a string (despite its name):


```julia
julia> newEx

"\\frac{y}{z}"
```

The recursive `latexraw()` pulls this value back to the original expression `ex`, such that:

```julia-repl
julia> ex.args

3-element Array{Any,1}:
 :+
 :x
 :"\\frac{y}{z}"
```

Now, since this expression does not consist of any further expressions, it is passed to `latexoperation()`.
The operator is now "+", and it should be applied on the second and third element of the expression, resulting in:

```julia
"x + \\frac{y}{z}"
```

using the print function you get:

```julia-repl
julia> print(latexraw(ex))

"x + \frac{y}{z}"
```

which in a ``\LaTeX`` maths environment renders as:

```math
x + \frac{y}{z}
```



## Extended functionality


With the above example we can understand how an expression is converted to a ``\LaTeX`` formatted string (unless my pedagogical skills are worse than I fear).

So, anything which can be converted to a Julia expression of the Expr type can be latexified.
Luckily, since Julia needs to convert your code to expressions before it can be evaluated, Julia is already great at doing this.

There are already some methods for converting other types to expressions and passing them to the core method, for example:
```julia
latexraw(str::AbstractString) = latexraw(parse(str))
```
but if you find yourself wanting to parse some other type, it is often easy to overload the `latexraw` function.


## Latexifying Arrays
Also, if you pass an array to `latexraw`, it will recursively try to convert the elements of that array to ``\LaTeX`` formatted strings.


```julia-repl
julia> arr = [:(x-y/(k_10+z)), "x*y*z/3"]
julia> latexraw(arr)
2-element Array{String,1}:
 "x - \\frac{y}{k_{10} + z}"
 "\\frac{x \\cdot y \\cdot z}{3}"

julia> println.(latexraw(arr))
x - \frac{y}{k_{10} + z}
\frac{x \cdot y \cdot z}{3}
```
