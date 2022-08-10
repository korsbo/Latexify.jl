@doc doc"""
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
latexraw(args...; kwargs...) = process_latexify(args...; kwargs..., env=:raw)

function _latexraw(inputex::Expr; convert_unicode=true, kwargs...)
    ## Pass all arrays or matrices in the expr to latexarray
    inputex = postwalk(x -> Meta.isexpr(x, [:hcat, :vcat, :vect, :typed_vcat, :typed_hcat]) ?
                       latexarray(expr_to_array(x); kwargs...)
                       : x,
                       inputex)

    recurseexp!(lstr::LaTeXString) = lstr.s
    function recurseexp!(ex)
        prevOp = Vector{Symbol}(undef, length(ex.args))
        fill!(prevOp, :none)
        if Meta.isexpr(ex, :call) && ex.args[1] in (:sum, :prod) && Meta.isexpr(ex.args[2], :generator)
            op = ex.args[1]
            term = latexraw(ex.args[2].args[1])
            gen = ex.args[2].args[2]
            itervar = latexraw(gen.args[1])
            if Meta.isexpr(gen.args[2], :call) && gen.args[2].args[1] == :(:)
                # sum(x_n for n in n_0:N) => \sum_{n=n_0}^{N} x_n
                lower = latexraw(gen.args[2].args[2])
                upper = latexraw(gen.args[2].args[end])
                return "\\$(op)_{$(itervar) = $(lower)}^{$(upper)} $term"
            elseif gen.args[2] in (:_, :(:))
                # sum(x_n for n in :) => \sum_{n} x_n
                return "\\$(op)_{$(itervar)} $term"
            else
                # sum(x_n for n in N) => \sum_{n \in N} x_n
                set = latexraw(gen.args[2])
                return "\\$(op)_{$(itervar) \\in $set} $term"
            end
        else
            for i in 1:length(ex.args)
                if isa(ex.args[i], Expr)
                    length(ex.args[i].args) > 1 && ex.args[i].args[1] isa Symbol && (prevOp[i] = ex.args[i].args[1])
                    ex.args[i] = recurseexp!(ex.args[i])
                elseif ex.args[i] isa AbstractArray
                    ex.args[i] = latexraw(ex.args[i]; kwargs...)
                end
            end
            return latexoperation(ex, prevOp; convert_unicode=convert_unicode, kwargs...)
        end
    end
    ex = deepcopy(inputex)
    str = recurseexp!(ex)
    convert_unicode && (str = unicode2latex(str))
    return LaTeXString(str)
end


function _latexraw(args...; kwargs...)
    @assert length(args) > 1 "latexify does not support objects of type $(typeof(args[1]))."
    _latexraw(args; kwargs...)
end
_latexraw(arr::Union{AbstractArray, Tuple}; kwargs...) = _latexarray(arr; kwargs...)
_latexraw(i::Nothing; kwargs...) = ""
_latexraw(i::SubString; parse=true, kwargs...) = latexraw(parse ? Meta.parse(i) : i; kwargs...)
_latexraw(i::SubString{LaTeXStrings.LaTeXString}; kwargs...) = i
_latexraw(i::Rational; kwargs...) = i.den == 1 ? latexraw(i.num; kwargs...) : latexraw(:($(i.num)/$(i.den)); kwargs...)
_latexraw(i::QuoteNode; kwargs...) = _latexraw(i.value)

function _latexraw(z::Complex; kwargs...)
    if iszero(z.re)
        isone(z.im) && return LaTeXString(get(kwargs, :imaginary_unit, "\\mathit{i}"))
        isone(-z.im) && return LaTeXString("-$(get(kwargs, :imaginary_unit, "\\mathit{i}"))")
        return LaTeXString("$(latexraw(z.im))$(get(kwargs, :imaginary_unit, "\\mathit{i}"))")
    end
    return LaTeXString("$(latexraw(z.re;kwargs...))$(z.im < 0 ? "-" : "+" )$(latexraw(abs(z.im);kwargs...))$(get(kwargs, :imaginary_unit, "\\mathit{i}"))")
end
#latexraw(i::DataFrames.DataArrays.NAtype) = "\\textrm{NA}"
_latexraw(str::LaTeXStrings.LaTeXString; kwargs...) = str

function _latexraw(i::Number; fmt=PlainNumberFormatter(), kwargs...)
    try isinf(i) && return LaTeXString("$(sign(i) == -1 ? "-" : "")\\infty") catch; end
    fmt isa String && (fmt = PrintfNumberFormatter(fmt))
    return fmt(i)
end

function _latexraw(i::Char; convert_unicode=true, kwargs...)
    LaTeXString(convert_unicode ? unicode2latex(string(i)) : string(i))
end

function _latexraw(i::Symbol; convert_unicode=true, snakecase=false, safescripts=false, kwargs...)
    str = string(i == :Inf ? :∞ : i)
    str = convert_subscript(str; snakecase=snakecase)
    convert_unicode && (str = unicode2latex(str; safescripts=safescripts))
    return LaTeXString(str)
end

_latexraw(i::String; parse=true, kwargs...) = _latexraw(Val(parse), i; kwargs...)

_latexraw(::Val{false}, i::String; convert_unicode=true, kwargs...) =
    LaTeXString(convert_unicode ? unicode2latex(i) : i)

function _latexraw(::Val{true}, i::String; kwargs...)
    try
        ex = Meta.parse(i)
        return latexraw(ex; kwargs...)
    catch ParseError
        error("""
in Latexify.jl:
You are trying to create latex-maths from a `String` that cannot be parsed as
an expression: `$i`.

`latexify` will, by default, try to parse any string inputs into expressions
and this parsing has just failed.

If you are passing strings that you want returned verbatim as part of your input,
try making them `LaTeXString`s first.

If you are trying to make a table with plain text, try passing the keyword
argument `latex=false`. You should also ensure that you have chosen an output
environment that is capable of displaying not-maths objects. Try for example
`env=:table` for a latex table or `env=:mdtable` for a markdown table.
""")
    end
end

_latexraw(i::Missing; kwargs...) = "\\textrm{NA}"
