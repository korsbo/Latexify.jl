function latexify(args...; kwargs...)
  io = IOBuffer(; append=true)
  config = (; DEFAULT_CONFIG..., MODULE_CONFIG..., USER_CONFIG..., default_kwargs..., kwargs...)
  latexify(io, args...; kwargs...)
  call_result = LaTeXString(String(take!(io)))
  COPY_TO_CLIPBOARD && clipboard(call_result)
  AUTO_DISPLAY && display(call_result)
  get(config, :render, false) && render(call_result)
  return call_result
end

function latextrace(args...; kwargs...)
  tio = TracedIO(Function[], IOBuffer(; append=true, read=true))
  config = (; DEFAULT_CONFIG..., MODULE_CONFIG..., USER_CONFIG..., default_kwargs..., kwargs...)
  latexify(tio, args...; kwargs...)
  call_result = LaTeXString(read(tio.io, String))
  COPY_TO_CLIPBOARD && clipboard(call_result)
  AUTO_DISPLAY && display(call_result)
  get(config, :render, false) && render(call_result)
  return TracedResult(tio.trace, call_result)
end

function latexify(io::IO, args...; rules = vcat(DEFAULT_INSTRUCTIONS, USER_INSTRUCTIONS, ENV_INSTRUCTIONS, USER_INSTRUCTIONS), kwargs...)
    config = (; descend_counter = [0], DEFAULT_CONFIG..., MODULE_CONFIG..., USER_CONFIG..., default_kwargs..., kwargs...)
    descend(io, config, args, rules)
end

function iterate_top_matcher(io, config, args, prevop=:_nothing)
    env_instructions = vcat(ENV_INSTRUCTIONS, USER_ENV_INSTRUCTIONS)
    for f in env_instructions[end:-1:1]
        call_result = f(io, config, args, prevop)
        if call_result
            return call_result
        end
    end
    throw(ArgumentError("No top-level matching expression for \a$args \n$kwargs"))
end

apply_recipe(args...; kwargs...) = (args, kwargs)


abstract type AbstractLatexifyEnvironment end
abstract type AbstractLatexEnvironment <: AbstractLatexifyEnvironment end
for T in [:Inline, :Equation, :Align, :Bracket, :Table, :NoEnv, :Aligned, :Array]
  @eval(struct $T <: AbstractLatexEnvironment
    args
  end)
end
struct AutoEnv <: AbstractLatexEnvironment
  args
  env::Symbol
end
AutoEnv(args; default=:auto) = AutoEnv(args, default)

abstract type AbstractMarkdownEnvironment <: AbstractLatexifyEnvironment end
for T in [:MDTable, :MDText]
  @eval(struct $T <: AbstractMarkdownEnvironment
    args
  end)
end


wrap_env(x) = AutoEnv(x)
wrap_end(x::AbstractLatexifyEnvironment) = x


const OUTPUTFUNCTIONS = (;
                             :inline    => Inline,
                             :tabular   => Table,
                             :table     => Table,
                             :raw       => NoEnv,
                             :none      => NoEnv,
                             :noenv     => NoEnv,
                             :align     => Align,
                             :eq        => Equation,
                             :equation  => Equation,
                             :bracket   => Bracket,
                             :mdtable   => MDTable,
                             :mdtext    => MDText,
                            )
                            
const ENV_INSTRUCTIONS = [
  function _auto_environment(io::IO, config, x, rules, prevop)
    if x isa Tuple{AutoEnv} || (x isa Tuple && config[:descend_counter] == [1])
      args = x isa Tuple{AutoEnv} ? x[1].args : x
      _default_env = x isa Tuple{AutoEnv} ? x[1].env : :_nothing
      env = get(config, :env, _default_env)
      if haskey(OUTPUTFUNCTIONS, env) 
        descend(io, config, (OUTPUTFUNCTIONS[env](args),), rules, prevop) 
      elseif args isa Tuple{Vector, Vector}
        descend(io, config, (Align(hcat(args[1], args[2])),), rules)
      elseif length(args) == 1
        descend(io, config, (Inline(args[1]),), rules)
      else
        throw(MethodError("Unspported argument to `latexify`: $args"))
      end
      return true
    end
    return false
  end,
  function _no_env(io::IO, config, x, rules, prevop)
    if x isa Tuple{NoEnv}
      descend(io, config, x[1].args, rules, prevop)
      return true
    end
    return false
  end,
  function _inline(io::IO, config, x, rules, prevop)
    if x isa Tuple{Inline}
      write(io, "\$")
      descend(io, config, x[1].args, rules, prevop)
      write(io, "\$")
      return true
    end
    return false
  end,
  function _align(io::IO, config, x, rules, prevop)
    if x isa Tuple{Align}
      write(io, "\\begin{align}\n")
      join_matrix(io, config, x[1].args, " &= ", rules)
      write(io, "\n\\end{align}")
      return true
    end
    return false
  end,
  function _equation(io::IO, config, x, rules, prevop)
    if x isa Tuple{Equation}
      write(io, "\\begin{equation}\n")
      descend(io, config, x[1].args, rules, prevop)
      write(io, "\n\\end{equation}")
      return true
    end
    return false
  end,
]

function join_matrix(io, config, m, rules, delim = " & ", eol="\\\\\n")
   nrows, ncols = size(m)
   mime = MIME("text/latexify")
   for (i, row) in enumerate(eachrow(m))
       for x in row[1:end-1]
            descend(io, config, x, rules)
            write(io, delim)
       end
       descend(io, config, row[end], rules)
       i != nrows ? write(io, eol) : write(io, "\n")
    end
    return nothing
end