function latexify(args...; kwargs...)

    ## Let potential recipes transform the arguments.
    args, kwargs = apply_recipe(args...; merge(default_kwargs, kwargs)...)

    ## If the environment is unspecified, use auto inference.
    env = haskey(kwargs, :env) ? kwargs[:env] : :auto

    latex_function = infer_output(env, args...)

    result = latex_function(args...; kwargs...)

    COPY_TO_CLIPBOARD && clipboard(result)
    AUTO_DISPLAY && display(result)
    return result
end

apply_recipe(args...; kwargs...) = (args, kwargs)

function infer_output(env, args...)
    if env != :auto
        env == :inline && return latexinline
        env in [:tabular, :table] && return latextabular
        env == :raw && return latexraw
        env == :array && return (args...; kwargs...) -> latexequation(latexarray(args...; kwargs...); kwargs...)
        env == :align && return latexalign
        env == :aligned && return (args...; kwargs...) -> latexbracket(latexalign(args...; kwargs..., aligned=true, starred=false); kwargs...)
        env in [:eq, :equation] && return latexequation
        env == :bracket && return latexbracket
        env == :mdtable && return mdtable
        env == :mdtext && return mdtext
        env in [:arrows, :chem, :chemical, :arrow] && return chemical_arrows

        error("The environment $env is not defined.")
    end

    latex_function = get_latex_function(args...)

    return latex_function
end

"""
    get_latex_function(args...)

Use overloading to determine which latex environment to output.

This determines the default behaviour of `latexify()` for different inputs.
"""
get_latex_function(args...) = latexinline
get_latex_function(args::AbstractArray...) = (args...; kwargs...) -> latexequation(latexarray(args...; kwargs...); kwargs...)
get_latex_function(args::AbstractDict) = (args...; kwargs...) -> latexequation(latexarray(args...; kwargs...); kwargs...)
get_latex_function(args::Tuple...) = (args...; kwargs...) -> latexequation(latexarray(args...; kwargs...); kwargs...)
get_latex_function(arg::LaTeXString) = (arg; kwargs...) -> arg

function get_latex_function(x::AbstractArray{T}) where T <: AbstractArray
    try
        x = hcat(x...)
        return (args...; kwargs...) -> latexequation(latexarray(args...; kwargs...); kwargs...)
    catch
        return latexinline
    end
end

get_latex_function(lhs::AbstractVector, rhs::AbstractVector) = latexalign
