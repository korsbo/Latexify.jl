function latexify(args...; kwargs...)

    ## Let potential recipes transform the arguments.
    args, kwargs = apply_recipe(args...; default_kwargs..., kwargs...)

    ## If the environment is unspecified, use auto inference.
    env = get(kwargs, :env, :auto)

    latex_function = infer_output(env, args...)

    result = latex_function(args...; kwargs...)

    COPY_TO_CLIPBOARD && clipboard(result)
    AUTO_DISPLAY && display(result)
    get(kwargs, :render, false) && render(result)
    return result
end

apply_recipe(args...; kwargs...) = (args, kwargs)

# These functions should only be called from inside `latexify()`, so that
# `apply_recipe` gets a chance to change args
const OUTPUTFUNCTIONS = Dict(
                             :inline    => _latexinline,
                             :tabular   => _latextabular,
                             :table     => _latextabular,
                             :raw       => latexraw,
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
        x = reduce(hcat, x)
        return (args...; kwargs...) -> _latexequation(_latexarray(args...; kwargs...); kwargs...)
    catch
        return _latexinline
    end
end

get_latex_function(lhs::AbstractVector, rhs::AbstractVector) = _latexalign
