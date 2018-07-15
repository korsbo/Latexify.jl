

function md(args...; env=:auto, kwargs...)
    md_function = infer_md_output(env, args...)

    m = md_function(args...; kwargs...)
    COPY_TO_CLIPBOARD && clipboard(m)
    AUTO_DISPLAY && display(m)
    return m
end

mdalign(args...; kwargs...) = latexalign(args...; kwargs...)
mdarray(args...; kwargs...) = latexarray(args...; kwargs...)
md_chemical_arrows(args...; kwargs...) = chemical_arrows(args...; kwargs...)

function infer_md_output(env, args...)
    if env != :auto
        env == :table && return mdtable
        env == :text && return mdtext
        env == :align && return mdalign
        env == :array && return mdarray
        env == :inline && return latexinline
        env in [:arrows, :chem, :chemical, :arrow] && return md_chemical_arrows
        error("The MD environment $env is not defined.")
    end

    md_function = get_md_function(args...)

    return md_function
end

"""
    get_md_function(args...)

Use overloading to determine what MD output to generate.

This determines the default behaviour of `md()` for different inputs.
"""
get_md_function(args...) = mdtext
get_md_function(args::AbstractArray...) = mdtable
get_md_function(args::Associative) = mdtable

@require DiffEqBase begin
    get_md_function(args::DiffEqBase.AbstractParameterizedFunction) = mdalign
    get_md_function(args::DiffEqBase.AbstractReactionNetwork) = mdalign
    function get_md_function(x::AbstractArray{T}) where T <: DiffEqBase.AbstractParameterizedFunction
        return mdalign
    end
end

@require DataFrames begin
    get_md_function(args::DataFrames.DataFrame) = mdtable
end
