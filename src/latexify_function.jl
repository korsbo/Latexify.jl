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
        env == :array && return latexarray
        env == :align && return latexalign
        env in [:eq, :equation] && return latexequation
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
get_latex_function(args::AbstractArray...) = latexarray
get_latex_function(args::AbstractDict) = latexarray
get_latex_function(args::Tuple...) = latexarray


function get_latex_function(x::AbstractArray{T}) where T <: AbstractArray
    try
        x = hcat(x...)
        return latexarray
    catch
        return latexinline
    end
end

get_latex_function(lhs::AbstractVector, rhs::AbstractVector) = latexalign


function output(str; post_processing=x->x, escape_underscores=false, kwargs...)
    str = post_processing(str)
    str == nothing && return nothing
    escape_underscores && (str = replace(str, "_"=>"\\_"))
    latexstr = LaTeXString(str)
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end
