const default_kwargs = Dict{Symbol, Any}()

"""
    set_default(; kwargs...)

Set default kwarg values for latexify. 

This works for all keyword arguments except `:env`. It is additive such that if
you call it multiple times, defaults will be added or replaced, but not reset.

Example: 
```julia
set_default(mult_symbol = "", transpose = true)
```

To reset the defaults that you have set, use `reset_default`.
To see your specified defaults, use `get_default`.
"""
function set_default(; kwargs...)
    for key in keys(kwargs)
        default_kwargs[key] = kwargs[key]
    end
end

"""
    reset_default()

Reset user-specified default kwargs for latexify, set by `set_default`.
"""
reset_default() = empty!(default_kwargs)

"""
    get_default

Get a Dict with the user-specified default kwargs for latexify, set by `set_default`.
"""
function get_default end
get_default() = default_kwargs
get_default(arg::Symbol) = default_kwargs[arg]
get_default(args::AbstractArray) =  map(x->default_kwargs[x], args)
get_default(args...) = Tuple(get_default(arg) for arg in args)
