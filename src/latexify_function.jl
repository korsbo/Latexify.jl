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

function latexify(io::IO, args...; rules = vcat(DEFAULT_INSTRUCTIONS, reduce(vcat, values(MODULE_INSTRUCTIONS); init=Function[]), USER_INSTRUCTIONS, ENV_INSTRUCTIONS, USER_INSTRUCTIONS), kwargs...)
    config = (; descend_counter = [0], DEFAULT_CONFIG..., MODULE_CONFIG..., USER_CONFIG..., default_kwargs..., kwargs...)
    descend(io,  args, config, rules)
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
for T in [:Inline, :Equation, :Bracket, :Table, :NoEnv, :Aligned, :Array]
  @eval(struct $T <: AbstractLatexEnvironment
    args
  end)
end
for C in [:Inline, :Equation, :Bracket]
  @eval $C(x1, x2) = $C(x1 .=> x2)
end
Table(d::Dict) = Table(hcat(collect(keys(d)), collect(values(d))))
struct Align{T} <: AbstractLatexEnvironment
  args::Matrix{T}
end
Align(t1::Tuple, t2::Tuple) = Align(reduce(hcat, (collect(t1), collect(t2))))
Align(t::Tuple{Union{Tuple, Vector}, Union{Tuple, Vector}}) = Align(reduce(hcat, collect.(t)))
# Align(t::Tuple{Tuple}) = Align(first(t))
Align(v1::Vector, v2::Vector) = Align([v1 v2])
# Align(t::Tuple{Vector{<:AbstractString}}) = Align(first(t))
Align(v::Vector{<:AbstractString}) = Align(permutedims(reduce(hcat, split.(v, '='))))
Align(v::Vector{<:Pair}) = Align(hcat(first.(v), last.(v)))
Align(t::Tuple{T}) where T = Align(first(t))
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
  function _auto_environment(io::IO,  x, config, rules, prevop)
    if x isa Tuple{AutoEnv} || (x isa Tuple && config[:descend_counter] == [1])
      args = x isa Tuple{AutoEnv} ? x[1].args : x
      _default_env = x isa Tuple{AutoEnv} ? x[1].env : :_nothing
      if haskey(config, :env) && !haskey(OUTPUTFUNCTIONS, config.env)
        throw(ArgumentError("Unsupported env specification :$(config.env)\nSupported envs are $(keys(OUTPUTFUNCTIONS))"))
      end

      env = get(config, :env, _default_env)
      if haskey(OUTPUTFUNCTIONS, env) 
        descend(io,  (OUTPUTFUNCTIONS[env](args...),), config, rules, prevop) 
      elseif args isa Tuple{Vector, Vector}
        descend(io,  (Align(hcat(args[1], args[2])),), config, rules)
      elseif length(args) == 1
        descend(io,  (Inline(args[1]),), config, rules)
      else
        throw(MethodError("Unspported argument to `latexify`: $args"))
      end
      return true
    end
    return false
  end,
  function _no_env(io::IO,  x, config, rules, prevop)
    if x isa Tuple{NoEnv}
      # for arg in x[1].args
      descend(io,  x[1].args, config, rules, prevop)
        # descend(io,  arg, config, rules, prevop)
      # end
      return true
    end
    return false
  end,
  function _inline(io::IO,  x, config, rules, prevop)
    if x isa Tuple{Inline}
      write(io, "\$")
      descend(io,  x[1].args, config, rules, prevop)
      write(io, "\$")
      return true
    end
    return false
  end,
  function _table(io::IO,  x, config, rules, prevop)
    if x isa Tuple{Table}
      adjustment = get(config, :adjustment, "l")
      elements = get(config, :latex, true) ? map(y->(Inline(y),), x[1].args) : x[1].args
      get(config, :transpose, false) && (elements = permutedims(elements))
      if haskey(config, :head)
        elements=vcat(permutedims(vec(config[:head])), elements)
      end
      if haskey(config, :side)
        elements=hcat(vec(config[:side]), elements)
      end
      columns = size(elements, 2)
      write(io, "\\begin{tabular}{$(string(adjustment)^columns)}\n")
      get(config, :booktabs, false) && write(io, "\\toprule\n")
      join_matrix(io,  elements, config, rules, " & ")
      get(config, :booktabs, false) && write(io, "\\bottomrule\n")
      write(io, "\\end{tabular}")
      return true
    end
    return false
  end,
  function _align(io::IO,  x, config, rules, prevop)
    if x isa Tuple{Align}
      write(io, "\\begin{align$(get(config, :starred, false) ? '*' : "")}\n")
      join_matrix(io,  x[1].args, config, rules, get(config, :separator, " =& "))
      write(io, "\\end{align$(get(config, :starred, false) ? '*' : "")}\n")
      return true
    end
    return false
  end,
  function _bracket(io::IO,  x, config, rules, prevop)
    if x isa Tuple{Bracket}
      write(io, "\\[\n")
      descend(io,  x[1].args, config, rules, prevop)
      write(io, "\n\\]")
      return true
    end
    return false
  end,
  function _equation(io::IO,  x, config, rules, prevop)
    if x isa Tuple{Equation}
      write(io, "\\begin{equation$(get(config, :starred, false) ? '*' : "")}\n")
      descend(io,  x[1].args, config, rules, prevop)
      write(io, "\n\\end{equation$(get(config, :starred, false) ? '*' : "")}")
      return true
    end
    return false
  end,
  # function _mdtable(io::IO, x ,config, rules, prevop)
  #   if x isa Tuple{MDTable}

  #   end
  #   return false
  # end
]

join_matrix(io, m, config, rules, delim::Union{String, Char, Symbol}, eol) = join_matrix(io, m, config, rules, fill(delim, size(m,1))) 
function join_matrix(io,  m, config, rules, delim = fill(" & ", size(m, 1)), eol=" \\\\\n")
   nrows, ncols = size(m)
   for (i, row) in enumerate(eachrow(m))
       for x in row[1:end-1]
            descend(io,  x, config, rules)
            write(io, delim[i])
       end
       descend(io,  row[end], config, rules)
       i != nrows ? write(io, eol) : write(io, "\n")
    end
    return nothing
end