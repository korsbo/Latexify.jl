"""
    latexify(arg)

Generate LaTeX equations from `arg`.

Parses expressions, ParameterizedFunctions, SymEngine.Base and arrays thereof.
Returns a string formatted for LaTeX.

# Examples

## using expressions
```jldoctest
julia> expr = :(x/(y+x))
julia> latexify(expr)
"\\frac{x}{y + x}"
```

```jldoctest
julia> expr = parse("x/(y+x)")
julia> latexify(expr)
"\\frac{x}{y + x}"
```

## using ParameterizedFunctions
```jldoctest
julia> using DifferentialEquations
julia> f = @ode_def feedback begin
         dx = y/c_1 - x
         dy = x^c_2 - y
       end c_1=>1.0 c_2=>1.0
julia> latexify(f)
"\\begin{align}\n\\frac{dx}{dt} =&  \\frac{y}{c_1} - x \\\\ \n\\frac{dy}{dt} =&  x^{c_2} - y \\\\ \n\\end{align}\n"
```

## using SymEngine
```jldoctest
julia> using SymEngine
julia> @vars x y
julia> symExpr = x + x + x*y*y
julia> latexify(symExpr)
"2 \\cdot x + x \\cdot y^{2}"
```
"""
function latexify end


function latexify(inputex::Expr)
    function recurseexp!(ex)
        prevOp = Vector{Symbol}(length(ex.args))
        fill!(prevOp, :none)
        for i in 1:length(ex.args)
            if isa(ex.args[i], Expr)
                length(ex.args[i].args) > 2 && (prevOp[i] = ex.args[i].args[1])
                ex.args[i] = recurseexp!(ex.args[i])
            end
        end
        return latexoperation(ex, prevOp)
    end
    ex = deepcopy(inputex)
    recurseexp!(ex)
end


latexify(arr::AbstractArray) = [latexify(i) for i in arr]
latexify(i::Number) = string(i)


function latexify(x::SymEngine.Basic)
    str = string(x)
    ex = parse(str)
    latexify(ex)
end


function latexify(ode::DiffEqBase.AbstractParameterizedFunction)
    str = "\\begin{align}\n"
    for i in 1:length(ode.syms)
        var = ode.syms[i]
        str = "$str\\frac{d$var}{dt} =& "
        lstr = latexify(ode.funcs[i])
        str = "$str $lstr \\\\ \n"
    end
    str = "$str\\end{align}\n"
end
