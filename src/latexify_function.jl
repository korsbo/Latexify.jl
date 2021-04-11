function latexify(args...; env=:auto, kwargs...)
    ## Let potential recipes transform the arguments.
    # kwargs = merge(default_kwargs, kwargs)

    empty!(CONFIG)
    merge!(CONFIG, DEFAULT_CONFIG, default_kwargs, kwargs)
  
  if env==:auto
    call_result = iterate_top_matcher(args, CONFIG)
  else
    func = OUTPUTFUNCTIONS[env]
    call_result = func(args...; CONFIG...)
  end
    COPY_TO_CLIPBOARD && clipboard(call_result)
    AUTO_DISPLAY && display(call_result)
    get(CONFIG, :render, false) && render(call_result)
    return call_result
end

function iterate_top_matcher(args, kwargs)
    for f in TOP_LEVEL_MATCHERS[end:-1:1]
        call_result = f(args, kwargs)
        if !(call_result === nothing)
            return call_result
        end
    end
    throw(ArgumentError("No top-level matching expression for \a$args \n$kwargs"))
end

apply_recipe(args...; kwargs...) = (args, kwargs)

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

const TOP_LEVEL_MATCHERS = [
    function _inline_fallback(args, kwargs)
      return latexstring(latexraw(args...; kwargs...))
    end,
    function _equation_array(args, kwargs)
      if eltype(args) <: AbstractArray || eltype(args) <: Tuple
          return _latexequation(args...; kwargs...)
      end
    end,
    function _align(args, kwargs)
      if length(args) == 2 && (eltype(args) <: AbstractVector)
          return _latexalign(args...; kwargs...)
      end
    end,
    function _dicts(args, kwargs)
      if length(args) == 1 && (args[1] isa AbstractDict || args[1] isa NamedTuple)
        _latexalign(collect(keys(args[1])), collect(values(args[1])); kwargs...)
      end
    end,
    function _equation(args, kwargs)
      if length(args) == 1 && args[1] isa AbstractArray && eltype(args[1]) <: AbstractArray
        try
            x = reduce(hcat, args[1])
            return _latexequation(args...; kwargs...)
        catch
            return _latexinline(args...; kwargs...)
        end
      end
    end,
    function _latexstring_passthrough(args, kwargs)
      if length(args) == 1 && args[1] isa LaTeXString
          return args[1]
      end
    end,
]