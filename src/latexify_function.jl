@doc doc"""
    latexify(args...; kwargs...)

Latexify a string, an expression, an array or other complex types.

```julia-repl
julia> latexify("x+y/(b-2)^2")
L"$x + \frac{y}{\left( b - 2 \right)^{2}}$"

julia> latexify(:(x/(y+x)^2))
L"$\frac{x}{\left( y + x \right)^{2}}$"

julia> latexify(["x/y" 3//7 2+3im; 1 :P_x :(gamma(3))])
L"\begin{equation}
\left[
\begin{array}{ccc}
\frac{x}{y} & \frac{3}{7} & 2+3\mathit{i} \\
1 & P_{x} & \Gamma\left( 3 \right) \\
\end{array}
\right]
\end{equation}
"
```
"""
function latexify(args...; kwargs...)
    kwargs = merge(default_kwargs, kwargs)
    result = process_latexify(args...; kwargs...)

    should_render = get(kwargs, :render, false)
    should_render isa Bool || throw(ArgumentError(
        "The keyword argument `render` must be either `true` or `false`. Got $should_render"
        ))

    should_render && render(result)
    COPY_TO_CLIPBOARD && clipboard(result)
    AUTO_DISPLAY && display(result)
    return result
end

function process_latexify(args...; kwargs...)
    ## Let potential recipes transform the arguments.
    args, kwargs = apply_recipe(args...; kwargs...)

    ## If the environment is unspecified, use auto inference.
    env = get(kwargs, :env, :auto)

    latex_function = infer_output(env, args...)

    result = latex_function(args...; kwargs...)
end

apply_recipe(args...; kwargs...) = (args, kwargs)

# These functions should only be called from inside `latexify()`, so that
# `apply_recipe` gets a chance to change args
const OUTPUTFUNCTIONS = Dict(
                             :inline    => _latexinline,
                             :tabular   => _latextabular,
                             :table     => _latextabular,
                             :raw       => _latexraw,
                             :array     => _latexarray,
                             :align     => _latexalign,
                             :aligned   => (args...; kwargs...) -> _latexbracket(_latexalign(args...; kwargs..., aligned=true, starred=false); kwargs...),
                             :eq        => _latexequation,
                             :equation  => _latexequation,
                             :bracket   => _latexbracket,
                             :mdtable   => mdtable,
                             :mdtext    => mdtext,
                            )
function infer_output(env, args...)
    env === :auto && return get_latex_function(args...)
    # Must be like this, because items in OUTPUTFUNCTIONS must be defined
    env in [:arrows, :chem, :chemical, :arrow] && return _chemical_arrows
    return OUTPUTFUNCTIONS[env]
end

"""
    get_latex_function(args...)

Use overloading to determine which latex environment to output.

This determines the default behaviour of `latexify()` for different inputs.
"""
get_latex_function(args...) = _latexinline
get_latex_function(args::AbstractArray...) = _latexequation
get_latex_function(args::AbstractDict) = (args...; kwargs...) -> _latexequation(_latexarray(args...; kwargs...); kwargs...)
get_latex_function(args::Tuple...) = (args...; kwargs...) -> _latexequation(_latexarray(args...; kwargs...); kwargs...)
get_latex_function(arg::LaTeXString) = (arg; kwargs...) -> arg

function get_latex_function(x::AbstractArray{T}) where T <: AbstractArray
    try
        x = safereduce(hcat, x)
        return (args...; kwargs...) -> _latexequation(_latexarray(args...; kwargs...); kwargs...)
    catch
        return _latexinline
    end
end

get_latex_function(lhs::AbstractVector, rhs::AbstractVector) = _latexalign
