doc"""
    latexify(arg)

Generate LaTeX equations from `arg`.

Parses expressions, ParameterizedFunctions, SymEngine.Base and arrays thereof.
Returns a string formatted for LaTeX.

# Examples

## using expressions
```jldoctest
expr = :(x/(y+x))
latexify(expr)

# output

"\\frac{x}{y + x}"
```

```jldoctest
expr = parse("x/(y+x)")
latexify(expr)

# output

"\\frac{x}{y + x}"
```

## using ParameterizedFunctions
```jldoctest
using DifferentialEquations
f = @ode_def feedback begin
         dx = y/c_1 - x
         dy = x^c_2 - y
       end c_1=>1.0 c_2=>1.0
latexify(f)

# output

"\\begin{align}\n\\frac{dx}{dt} =&  \\frac{y}{c_1} - x \\\\ \n\\frac{dy}{dt} =&  x^{c_2} - y \\\\ \n\\end{align}\n"
```

## using SymEngine
```jldoctest
using SymEngine
@vars x y
symExpr = x + x + x*y*y
latexify(symExpr)

# output

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
latexify(i::Symbol) = convertSubscript(i)
latexify(i::String) = latexify(parse(i))
latexify(i::Rational) = latexify(:($(i.num)/$(i.den)))


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
