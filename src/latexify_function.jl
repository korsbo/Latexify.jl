function latexify(args...; env::Symbol=:auto, kwargs...)
    latex_function = infer_output(env, args...)

    result = latex_function(args...; kwargs...)

    COPY_TO_CLIPBOARD && clipboard(result)
    AUTO_DISPLAY && display(result)
    return result
end


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
