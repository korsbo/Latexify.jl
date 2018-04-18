

function md(args...; env=:auto, kwargs...)
    md_function = infer_md_output(env, args...)

    m = md_function(args...; kwargs...)
    COPY_TO_CLIPBOARD && clipboard(m)
    AUTO_DISPLAY && display(m)
    return m
end


function infer_md_output(env, args...)
    if env != :auto
        env == :table && return mdtable
        env == :text && return mdtext
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
