function latexify(args...; env::Symbol=:auto, kwargs...)
    latex_function = infer_output(env, args...)

    result = latex_function(args...; kwargs...)
    COPY_TO_CLIPBOARD && clipboard(result)
    return result
end


function infer_output(env, args...)
    if env != :auto
        funcname = Symbol("latex$env")
        isdefined(funcname) || error("The environment $env is not defined.")
        return eval(:($funcname))
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


function get_latex_function(x::AbstractArray{T}) where T <: AbstractArray
    try
        x = hcat(x...)
        return latexarray
    catch
        return latexinline
    end
end

get_latex_function(lhs::AbstractVector, rhs::AbstractVector) = latexalign


@require DiffEqBase begin
    get_latex_function(ode::DiffEqBase.AbstractParameterizedFunction) = latexalign
    get_latex_function(r::DiffEqBase.AbstractReactionNetwork; kwargs...) = latexalign

    function get_latex_function(x::AbstractArray{T}) where T <: DiffEqBase.AbstractParameterizedFunction
        return latexalign
    end
end
