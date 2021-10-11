
# Recipes

Recipes provides a concise means of extending Latexify.jl to work with types of your own making or of other packages. The `@latexrecipe` macro allows you to specify how a an argument type (or a set of types) should be pre-processed before they are passed to the standard `latexify` function. Also, it allows you to define both new keyword arguments as well as to set the defaults of pre-existing ones. The main power of this macro is that is defines the necessary functions *within* Latexify.jl itself, as opposed to within the module where it is called. 


The recipe syntax closely follow that of the [Plots.jl](https://github.com/JuliaPlots/Plots.jl) [recipes](https://github.com/JuliaPlots/RecipesBase.jl) and, indeed, most of the code is copied and adapted from them (cred to the authors!). 



So. The easiest way to explain it is by showing an example where we define a recipe for our type `MyType`. 

```julia
using Latexify

struct MyType 
   vector::Vector
end
```

```julia
@latexrecipe function f(x::MyType; reverse=false)
    ## we can access the input object and perform operations like in a normal function.
    vec = x.vector
    if reverse
        vec = vec[end:-1:1]
    end

    ## we can define defult keyword arguments to be passed along to latexify 
    ## using an arrow notation, --> 
    env --> :array
    transpose --> true
    ## These can be overridden by the keyword arguments passed to the latexify function.

    ## If you use the := operator to specify a value it cannot be overridden.
    fmt := "%.2f"

    ## The return value should be something that latexify already knows how to work with.
    ## In this case, we have a simple vector which is fine!
    return vec
end
```

```julia
mytype = MyType([1, 2, 3])

latexify(mytype; reverse=true)
```

```math
\begin{equation}
\left[
\begin{array}{c}
3.00 \\
2.00 \\
1.00 \\
\end{array}
\right]
\end{equation}
```

The required signature of the macro is
```julia
@latexrecipe function f(x::MyType, ...; ...)
    return something
end
```

Here, the function name is unimportant, but the type signature is key. 
There must also be an explicit `return` statement which returns something that 
base Latexify already works with (Arrays, Tuples, Numbers, Symbols, Strings, etc.).
In particular, you can not rely on Julia's default to return the value of the 
last expression evaluated in a function body.

The special notation `kwarg --> value` resets the default value of a keyword argument for your specific inputs. This will be overridden if the keyword argument in quesion is specified in a call to `latexify`. 
To disallow this overriding, use `kwarg := value` instead.

The use of `@latexrecipe` to redefine how an already supported type should be interpreted is highly discouraged. There is (currently) nothing in place to forbid this but it could mess up how latexify works with other packages. Disregarding this in your own sessions is one thing, but doing it in a package could cause very difficult issues for the users of your package. 


If a recipe is defined within a module, everything should just work without the need to export anything. 
