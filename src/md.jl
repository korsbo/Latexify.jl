

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

const MDOUTPUTS = Dict(
                       :table => mdtable,
                       :text => mdtext,
                       :align => mdalign,
                       :array => mdarray,
                       :inline => latexinline
                      )
function infer_md_output(env, args...)
    env === :auto && return get_md_function(args...)
    env in [:arrows, :chem, :chemical, :arrow] && return md_chemical_arrows
    return MDOUTPUTS[env]
end

"""
    get_md_function(args...)

Use overloading to determine what MD output to generate.

This determines the default behaviour of `md()` for different inputs.
"""
get_md_function(args...) = mdtext
get_md_function(args::AbstractArray...) = mdtable
get_md_function(args::AbstractDict) = mdtable
get_md_function(args::Tuple) = mdtable
