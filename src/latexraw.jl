doc"""
    latexraw(arg)

Generate LaTeX equations from `arg`.

Parses expressions, ParameterizedFunctions, SymEngine.Base and arrays thereof.
Returns a string formatted for LaTeX.

# Examples

## using expressions
```jldoctest
expr = :(x/(y+x))
latexraw(expr)

# output

"\\frac{x}{y + x}"
```

```jldoctest
expr = Meta.parse("x/(y+x)")
latexraw(expr)

# output

"\\frac{x}{y + x}"
```

## using ParameterizedFunctions
```julia
using DifferentialEquations;
f = @ode_def feedback begin
         dx = y/c_1 - x
         dy = x^c_2 - y
       end c_1=>1.0 c_2=>1.0
latexraw(f)

# output

2-element Array{String,1}:
 "dx/dt = \\frac{y}{c_{1}} - x"
 "dy/dt = x^{c_{2}} - y"
```

## using SymEngine
```jldoctest
using SymEngine
@vars x y
symExpr = x + x + x*y*y
latexraw(symExpr)

# output

"2 \\cdot x + x \\cdot y^{2}"
```
"""
function latexraw end


function latexraw(inputex::Expr)
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
    LaTeXString(recurseexp!(ex))
end


latexraw(arr::AbstractArray) = [latexraw(i) for i in arr]
latexraw(i::Number) = string(i)
latexraw(i::Void) = ""
latexraw(i::Symbol) = convertSubscript(i)
latexraw(i::SubString) = latexraw(parse(i))
latexraw(i::SubString{LaTeXStrings.LaTeXString}) = i
latexraw(i::Rational) = latexraw( i.den == 1 ? i.num : :($(i.num)/$(i.den)))
latexraw(z::Complex) = "$(z.re)$(z.im < 0 ? "" : "+" )$(z.im)\\textit{i}"
#latexraw(i::DataFrames.DataArrays.NAtype) = "\\textrm{NA}"
latexraw(str::LaTeXStrings.LaTeXString) = str

function latexraw(i::String)
    try
        ex = parse(i)
        return latexraw(ex)
    catch ParseError
        error("Error in Latexify.jl: You are trying to create latex-maths from a string that cannot be parsed as an expression. If you are trying to make a table or an array with plain text, try passing the keyword argument `latex=false`.")
    end
end

@require Missings latexraw(i::Missings.Missing) = "\\textrm{NA}"


@require SymEngine begin
    function latexraw(x::SymEngine.Basic)
        str = string(x)
        ex = parse(str)
        latexraw(ex)
    end
end


@require DiffEqBase begin
    function latexraw(ode::DiffEqBase.AbstractParameterizedFunction)
        lhs = ["\\frac{d$x}{dt} = " for x in ode.syms]
        rhs = latexraw(ode.funcs)
        return lhs .* rhs
    end
end
