
DEFAULT_INSTRUCTIONS = Function[
  function report_bad_call(io::IO,  expr, config, rules, prevop)
     println("""
     Unsupported input with
     expr=$expr
     prevop=$prevop
     and config=$config
     """)
     return false
  return false
  end,
  function _unpack_args(io::IO,  args, config, rules, prevop)
  ### If no function has claimed the tuple, unpack it and try again. 
  ### This is mainly to unpack the args to `latexify(args...)`. 
  if args isa Tuple && length(args) == 1
    descend(io, args[1], config, rules, prevop)
    return true
  end
  return false
  end,
  function call(io::IO,  expr, config, rules, prevop)
    if expr isa Expr && head(expr) == :call 
      h, op, args = unpack(expr)

      if op isa Symbol
        funcname = string(get(Latexify.function2latex, op, replace(string(op), "_"=>"\\_")))
        write(io, funcname)
      else
        descend(io,  op, config, rules)
      end
      if length(args) >= 1 && head(args[1]) == :parameters
        write(io, "\\left( ")
        join_descend(io,  args[2:end], config, rules, ", ")
        write(io, "; ")
        descend(io,  args[1], config, rules)
        write(io, " \\right)")
        # _arg = "\\left( $(join(descend.(args[2:end]), ", ")); $(descend(args[1])) \\right)"
      else
        write(io, "\\left( ")
        !isempty(args) && join_descend(io,  args, config, rules, ", ")
        write(io, " \\right)")
        # _arg = "\\left( " * join(descend.(args), ", ") * " \\right)"
      end
        return  true
    end
  return false
  end,
  function _infix_operator(io, ex, config, rules, prevop)
    ex isa Expr && head(ex) == :call && operation(ex) isa Symbol && Base.isbinaryoperator(operation(ex)) || return false
    descend(io, arguments(ex)[1], config, rules, operation(ex))
    write(io, " ")
    descend(io, operation(ex), config, rules, operation(ex))
    write(io, " ")
    descend(io, arguments(ex)[2], config, rules, operation(ex))
    return true
  end,
  function _aligned_tuple(io::IO,  expr, config, rules, prevop)
    expr isa Tuple{Vararg{Pair}} || return false
    descend(io,  NamedTuple(expr), config, rules, prevop)
    return true
  end,
  function _aligned(io::IO,  expr, config, rules, prevop)
    # expr isa Tuple{T, T} where T <: AbstractArray || return false
    # expr isa Tuple{Pair} || return false
    expr isa NamedTuple || return false
    write(io, "\\begin{aligned}\n")
    p_expr = pairs(expr)
    for p in p_expr[1:end-1]
      descend(io,  p, config, rules, nothing)
      write(io, " \\\\\n")
    end
    descend(io,  p_expr[end], config, rules, nothing)
    write(io, "\n")
    write(io, "\\end{aligned}\n")
    return true
  end,
  function _pair(io::IO,  expr, config, rules, prevop)
    expr isa Pair || return false
    descend(io,  expr.first, config, rules, :(=))
    write(io, get(config, :separator, " =& "))
    descend(io,  expr.second, config, rules, :(=))
    return true
  end,
  function _sqrt(io::IO,  ex, config, rules, prevop)
    operation(ex) == :sqrt || return false
    write(io, "\\$(operation(ex)){")
    descend(io, arguments(ex)[1], config, rules, :sqrt)
    write(io, "}")
    return true
  return false
  end,
  function _abs(io::IO,  ex, config, rules, prevop)
    operation(ex) == :abs || return false
    write(io, "\\left\\| ")
    descend(io, arguments(ex)[1], config, rules, :abs)
    write(io, " \\right\\|")
  return true
  end,
  function _single_comparison(io::IO, ex, config, rules, prevop)
    operation(ex) ∈ keys(comparison_operators) && length(arguments(ex)) == 2 || return false
    # write(io, "\\left( ")
    join_descend(io, [arguments(ex)[1], operation(ex), arguments(ex)[2]], config, rules, " "; prevop)
    # write(io, " \\right)")
    return true
  end,
  function _if(io::IO, ex, config, rules, prevop)
    ex isa Expr && head(ex) == :if || return false
    write(io, "\n\\begin{cases}")
    build_if_else_body(io, ex.args, config, rules, nothing)
    write(io, "\n\\end{cases}\n")
    return true
  end,
  function _elseif(io::IO,  ex, config, rules, prevop)
    ex isa Expr && head(ex) == :elseif || return false
    build_if_else_body(io, ex.args, config, rules, prevop; ifstr=get(config, :elseifstr, "elseif"))
    return true
  end,
  function _oneline_function(io::IO,  ex, config, rules, prevop)
    head(ex) == :function && length(arguments(ex)) == 1 || return false
    join_descend(io, [operation(ex), :(=), arguments(ex)[1]], config, rules, " ")
  return true
  end,
  function _return(io::IO,  ex, config, rules, prevop)
    head(ex) == :return && length(arguments(ex)) == 0 || return false
    descend(io, operation(ex), config, rules, nothing) 
  return true
  end,
  function _chained_comparisons(io::IO, ex, config, rules, prevop)
    head(ex) == :comparison && Symbol.(arguments(ex)[1:2:end]) ⊆ keys(comparison_operators) || return false
    prevop ∈ [:*, :^, :+, :-] && write(io, "\\left( ")
    join_descend(io, ex.args, config, rules, " "; prevop=nothing)
    prevop ∈ [:*, :^, :+, :-] && write(io, " \\right)")
    return true
  end,
  function _type_annotation(io::IO,  ex, config, rules, prevop)
    head(ex) == :(::) || return false
    if length(arguments(ex)) == 0 
      write(io, "::")
      descend(io, :(l_mathrm($(operation(ex)))), config, rules, nothing)
    elseif length(arguments(ex)) == 1 
      descend(io, operation(ex), config, rules, nothing)
      write(io, "::")
      descend(io, :(l_mathrm($(arguments(ex)[1]))), config, rules, nothing)
    end
  return true
  end,
  function _wedge(io::IO,  ex, config, rules, prevop)
    head(ex) == :(&&) && length(arguments(ex)) == 1 || return false
    descend(io, operation(ex), config, rules, nothing)
    write(io, " \\wedge ")
    descend(io, arguments(ex)[1], config, rules, nothing)
  return true
  end,
  function _vee(io::IO,  ex, config, rules, prevop)
    head(ex) == :(||) && length(arguments(ex)) == 1 || return false
    descend(io, operation(ex), config, rules, nothing)
    write(io, " \\vee ")
    descend(io, arguments(ex)[1], config, rules, nothing)
  return true
  end,
  function _negation(io::IO,  ex, config, rules, prevop)
    operation(ex) == :(!) || return false
    write(io, "\\neg ")
    descend(io, arguments(ex)[1], config, rules, nothing)
  return true
  end,
  function _kw(io::IO, ex, config, rules, prevop)
    head(ex) == :kw || return false
    descend(io, operation(ex), config, rules, nothing)
    write(io, " = ")
    descend(io, arguments(ex)[1], config, rules, nothing)
  return true
  end,
  function _parameters(io::IO, x, config, rules, prevop)
    head(x) == :parameters || return false
    join_descend(io, vcat(operation(x), arguments(x)), config, rules, ", ")
    # join(descend.(vcat(operation(x), arguments(x))), ", ") : nothing
  return true
  end,
  function _indexing(io::IO,  x, config, rules, prevop)
    head(x) == :ref || return false
    if config[:index] == :subscript
        descend(io, operation(x), config, rules, nothing)
        write(io, "_{")
        join_descend(io, arguments(x), config, rules, ",")
        write(io, "}")
    elseif config[:index] == :bracket
        descend(io, operation(x), config, rules, nothing)
        write(io, "\\left[")
        join_descend(io, arguments(x), config, rules, ", ")
        write(io, "\\right]")
    else
        throw(ArgumentError("Incorrect `index` keyword argument to latexify. Valid values are :subscript and :bracket"))
    end
    return true
  end,
  function _broadcast_macro(io::IO,  ex, config, rules, prevop)
    head(ex) == :macrocall && operation(ex) == Symbol("@__dot__") || return false
    descend(io, arguments(ex)[end], config, rules, prevop)
    return true
  end,
  function _block(io::IO, x, config, rules, prevop)
    head(x) == :block || return false
    descend(io, vcat(operation(x), arguments(x))[end], config, rules, prevop)
    # _args = filter(x -> !(x isa LineNumberNode), x.args)
    # # write(io, "\\left\\{")
    # write(io, "\\begin{array}{c}")
    # join_descend(io, _args, config, rules, "\\\\\n"; prevop)
    # write(io, "\\end{array}")
  return true
  end,
  function number(io::IO,  x, config, rules, prevop) 
    if x isa Number
      if hasmethod(isinf, Tuple{typeof(x)}) && isinf(x)
        write(io, "\\infty")
        return true
      end
      fmt = config[:fmt]
      fmt isa String && (fmt = PrintfNumberFormatter(fmt))
      str = string(fmt(x))
      write(io, str)
      return true
    end
  return false
  end,
  function rational_expr(io::IO,  x, config, rules, prevop) 
    if operation(x) == ://
      if arguments(x)[2] == 1 
        descend(io,  arguments(x)[1], config, rules, prevop)
        return true
      else
        descend(io,  :($(arguments(x)[1])/$(arguments(x)[2])), config, rules, prevop)
        return true
      end
    end
  return false
  end,
  function rational(io::IO,  x, config, rules, prevop) 
    if x isa Rational
      prevop ∈ [:*, :^] && write(io, "\\left( ")
      x.den == 1 ? descend(io, x.num, config, rules, nothing) : descend(io, :($(x.num)/$(x.den)), config, rules, nothing)
      prevop ∈ [:*, :^] && write(io, " \\right)")
      return true
    end
  return false
  end,
  function complex(io::IO,  z, config, rules, prevop) 
    if z isa Complex
      prevop ∈ [:*, :^] && write(io, "\\left( ")
      descend(io, z.re, config, rules, nothing)
      write(io, z.im < 0 ? "-" : "+")
      descend(io, abs(z.im), config, rules, nothing)
      write(io, "\\textit{i}")
      prevop ∈ [:*, :^] && write(io, " \\right)")
      return true
    end
  return false
  end,
  function _missing(io::IO,  x, config, rules, prevop) 
    ismissing(x) || return false
    write(io, get(config, :missingstring, "\\textrm{NA}"))
    return true
  end,
  function _nothing(io::IO,  x, config, rules, prevop)
    x === nothing || return false 
    return true
  end,
  function symbol(io::IO,  sym, config, rules, _)
    if sym isa Symbol
      sym = sym ∈ keys(comparison_operators) ? comparison_operators[sym] : sym
      str = string(sym == :Inf ? :∞ : sym)
      str = convert_subscript(str)
      config[:convert_unicode] && (str = unicode2latex(str))
      write(io, str)
      return true
    end
  return false
  end,
  function _char(io::IO,  c, config, rules, prevop)
    c isa Char || return false 
    descend(io, Symbol(c), config, rules, prevop)
    return true
  end,
  function array(io::IO,  arr, config, rules, prevop) 
    if arr isa AbstractArray
      adjustment = get(config, :adjustment, "c")
      transpose = get(config, :transpose, false)
      double_linebreak = get(config, :double_linebreak, false)
      starred = get(config, :starred, false)

      transpose && (arr = permutedims(arr))
      rows = first(size(arr))
      columns = length(size(arr)) > 1 ? size(arr)[2] : 1

      eol = double_linebreak ? " \\\\\\\\\n" : " \\\\\n"
      write(io, get(config, :array_left, "\\left[\n"))
      write(io, "\\begin{array}{" * "$(adjustment)"^columns * "}\n")
      
      for i=1:rows, j=1:columns
          descend(io,  arr[i,j], config, rules, nothing)
          write(io, j==columns ? eol : " & ")
      end

      write(io, "\\end{array}")
      write(io, get(config, :array_right, "\n\\right]"))
      return true
    end
    return false
  end,
  function _pair_container(io::IO,  expr, config, rules, prevop)
    expr isa AbstractVector && eltype(expr) <: Pair || expr isa Tuple{Vararg{Pair}} || return false
    write(io, "\\begin{aligned}\n")
    for p in expr[1:end-1]
      descend(io,  p, config, rules, nothing)
      write(io, " \\\\\n")
    end
    descend(io,  expr[end], config, rules, nothing)
    write(io, "\n")
    write(io, "\\end{aligned}")
    return true
  end,
  function tuple(io::IO,  arg, config, rules, prevop)
    if arg isa Tuple
      if first(arg) isa Tuple || first(arg) isa AbstractArray
        descend(io,  reduce(hcat, [collect(i) for i in arg]), config, rules, nothing)
        return true
      end
        descend(io,  collect(arg), config, rules, nothing)
        return true
      end
    return false
  end,
  function vect_exp(io::IO,  x, config, rules, prevop)
    if head(x) ∈ [:vect, :vcat, :hcat] 
      descend(io,  expr_to_array(x), config, rules, prevop)
      return true
    end
  return false
  end,
  #  (expr, prevop, config) -> begin
  #  h, op, args = unpack(expr)
  # #  if (expr isa LatexifyOperation || h == :LatexifyOperation) && op == :merge
  #  if h == :call && op == :latexifymerge
  #    join(descend.(args), "")
  #  end
  # return false
  # end,
  function parse_string(io::IO,  str, config, rules, prevop)
    str isa AbstractString || return false
    try
        ex = Meta.parse(str)
        descend(io, ex, config, rules, prevop)
    catch ParseError
        error("""
          in Latexify.jl:
          You are trying to create latex-maths from a `String` that cannot be parsed as
          an expression.

          `latexify` will, by default, try to parse any string inputs into expressions
          and this parsing has just failed.

          If you are passing strings that you want returned verbatim as part of your input,
          try making them `LaTeXString`s first.

          If you are trying to make a table with plain text, try passing the keyword
          argument `latex=false`. You should also ensure that you have chosen an output
          environment that is capable of displaying not-maths objects. Try for example
          `env=:table` for a latex table or `env=:mdtable` for a markdown table.
          """)
    end
  return true
  end,
  function _pass_through_LaTeXString_substrings(io::IO, str, config, rules, prevop)
    str isa SubString{LaTeXString} || return false
    write(io, String(str))
    return true
  end,
  function _pass_through_LaTeXString(io::IO, str, config, rules, prevop)
    str isa LaTeXString || return false
    write(io, str.s)
    return true
  end,
  function _tuple_expr(io::IO,  expr, config, rules, prevop)
    head(expr) == :tuple || return false 
    join_descend(io, vcat(operation(expr), arguments(expr)), config, rules, ", ")
    return true
  end,
  function strip_broadcast_dot(io::IO,  expr, config, rules, prevop)
    h, op, args = unpack(expr)
    if expr isa Expr && config[:strip_broadcast] && h == :call && startswith(string(op), '.')
      descend(io,  Expr(h, Symbol(string(op)[2:end]), args...), config, rules, prevop)
      return true
    end
  return false
  end,
  function strip_broadcast_dot_call(io::IO,  expr, config, rules, prevop)
    h, op, args = unpack(expr)
    if expr isa Expr && config[:strip_broadcast] && h == :. 
      descend(io,  Expr(:call, op, args[1].args...), config, rules, prevop)
      return true
    end
  return false
  end,
  function plusminus(io::IO,  expr, config, rules, prevop)
    h, op, args = unpack(expr)
    h == :call && op == :± || return false
    join_descend(io,  args, config, rules, " \\pm "; prevop=op)
  return true
  end,
  function division(io::IO,  expr, config, rules, prevop)
    h, op, args = unpack(expr)
    if h == :call && op == :/
      prevop ∈ [:^] && write(io, "\\left( ")
      write(io, "\\frac{")
      descend(io,  args[1], config, rules, op)
      write(io, "}{")
      descend(io,  args[2], config, rules, op)
      write(io, "}")
      prevop ∈ [:^] && write(io, "\\right) ")
      return true
    end
  return false
  end,
  function multiplication(io::IO,  expr, config, rules, prevop)
    h, op, args = unpack(expr)
    if h == :call && op == :*
      # join(descend.(args, op), "$(config[:mulsym])")
      join_descend(io,  args, config, rules, config[:mulsym]; prevop=op)
      return true
    end
  return false
  end,
  function addition(io::IO,  expr, config, rules, prevop)
    h, op, args = unpack(expr)
    if h == :call && op ∈ (:+, :.+)
      prevop ∈ [:*] && write(io, "\\left( ")
      for (i, arg) in enumerate(args)
        if i == 1 
          descend(io, arg, config, rules, :+)
        elseif is_first_minus(arg)
          write(io, " - ")
          descend(io, abs_first_minus(arg), config, rules, :+) 
        else
          write(io, " + ")
          descend(io, arg, config, rules, :+)
        end
      end
      prevop ∈ [:*] && write(io, " \\right)")
      return true
    end
  return false
  end,
  function subtraction(io::IO,  expr, config, rules, prevop)
    # this one is so gnarly because it tries to fix stuff like - - or -(-(x-y))
    # -(x) is also a bit different to -(x, y) which does not make things simpler
    h, op, args = unpack(expr)
    h == :call && op == :- || return false
    if length(args) == 1
      if operation(args[1]) == :- && length(arguments(args[1])) == 1 ## -(-x) -> x
        descend(io,  arguments(args[1])[1], config, rules, prevop)
      elseif args[1] isa Number && sign(args[1]) == -1 ## (-(-1)) -> 1
        descend(io,  -args[1], config, rules, op)
      else # -(expr)
        # _arg = operation(args[1]) ∈ [:-, :+, :±] ? surround(args[1]) : args[1]
        # prevop == :^ ? surround("$op$_arg") : "$op$_arg"
        if operation(only(args)) ∈ [:+, :.+, :-, :.-, :±, :.±]
          write(io, "$op")
          write(io, "\\left( ")
          descend(io,  only(args), config, rules, op)
          write(io, " \\right)")
        else
        write(io, "$op")
        descend(io, only(args), config, rules, op)
        end
      end
      return true
    elseif length(args) == 2
      if args[2] isa Number && sign(args[2]) == -1
        descend(io,  args[1], config, rules, :+) 
        write(io, " + ")
        descend(io,  -args[2], config, rules, :+)
        return true
      elseif operation(args[2]) == :- && length(arguments(args[2])) == 1
        descend(io,  args[1], config, rules, :+)
        write(io, " + ")
        descend(io,  arguments(args[2])[1], config, rules, :+)
        return true
      elseif operation(args[2]) ∈ [:-, :.-, :+, :.+]
        descend(io,  args[1], config, rules, op) 
        write(io, " - ")
        write(io, "\\left( ")
        descend(io,  args[2], config, rules, op)
        write(io, " \\right)")
        return true
      end

      prevop ∈ [:*, :^] && write(io, "\\left( ")
      join_descend(io,  args, config, rules, " - "; prevop = op)
      prevop ∈ [:*, :^] && write(io, " \\right)")
    end
  return true
  end,
  function pow(io::IO,  expr, config, rules, prevop)
    h, op, args = unpack(expr)
    h == :call && op == :^ || return false
    if operation(args[1]) in Latexify.trigonometric_functions
      fsym = operation(args[1])
      fstring = get(Latexify.function2latex, fsym, "\\$(fsym)")
      write(io, "$fstring^{")
      descend(io,  args[2], config, rules, op)
      write(io, "}")
      write(io, "\\left( ")
      join_descend(io,  arguments(args[1]), config, rules, ", "; prevop= operation(args[1]))
      write(io, " \\right)")
    else
      apply_surround = operation(args[1]) ∈ [:+, :.+] || (args[1] isa Number && sign(args[1])==-1)
      apply_surround && write(io, "\\left( ")
      descend(io,  args[1], config, rules, op)
      apply_surround && write(io, " \\right)")
      write(io, "^{")
      descend(io,  args[2], config, rules, op)
      write(io, "}")
    end
  return true
  end,
  function l_funcs(io::IO,  ex, config, rules, prevop)
    head(ex) == :call && startswith(string(operation(ex)), "l_") || return false
    l_func = string(operation(ex))[3:end]
    write(io, "\\$(l_func){")
    join_descend(io,  arguments(ex), config, rules, "}{"; prevop)
    write(io, "}")
    return true
  end,
  function equals(io,  expr, config, rules, prevop)
    if head(expr) == :(=)
      descend(io,  expr.args[1], config, rules, head(expr))
      write(io, " = ")
      descend(io,  expr.args[2], config, rules, head(expr))
      return true
    end
    return false
  end,
]

function build_if_else_body(io::IO, args, config, rules, prevop=nothing; ifstr =get(config, :ifstr, "if"), elsestr= get(config, :elsestr, "otherwise"))
      _args = filter(x -> !(x isa LineNumberNode), args)
      if length(_args) == 2
        write(io, "\n")
        descend(io, _args[2], config, rules, prevop)
        write(io, " & $ifstr \\quad ")
        descend(io, _args[1], config, rules, prevop)
      elseif length(_args) == 3 && head(_args[end]) == :elseif
        write(io, "\n")
        descend(io, _args[2], config, rules, prevop)
        write(io, " & $ifstr \\quad ")
        descend(io, _args[1], config, rules, prevop)
        write(io, " \\\\")
        descend(io, _args[3], config, rules, prevop)
      elseif length(_args) == 3 
        write(io, "\n")
        descend(io, _args[2], config, rules, prevop)
        write(io, " & $ifstr \\quad ")
        descend(io, _args[1], config, rules, prevop)
        write(io, " \\\\\n")
        descend(io, _args[3], config, rules, prevop)
        write(io, " & $elsestr")
      else 
        throw(ArgumentError("Unexpected if/elseif/else statement to latexify. This could well be a Latexify.jl bug."))
      end
      # return str
end


is_neg_term(x::Number) = sign(x) == -1
is_neg_term(x::Symbol) = false
is_neg_term(arg::Expr) = operation(arg) ∈ [:-, :.-] && !isempty(arguments(arg)) && length(arguments(arg)) == 1

is_first_minus(a::Number) = sign(a) == -1
is_first_minus(x) = false

function is_first_minus(ex::Expr)  
  length(ex.args) == 1 && return is_first_minus(ex.args[1])
  length(ex.args) == 2 && ex.args[1] == :- && return true
  return is_first_minus(ex.args[2])
end

function abs_first_minus(ex::Expr)  
  length(ex.args) == 1 && return Expr(ex.head, abs_first_minus(ex.args[1])) 
  length(ex.args) == 2 && ex.args[1] == :- && return ex.args[2]
  return Expr(ex.head, ex.args[1], abs_first_minus(ex.args[2]), ex.args[3:end]...)
end
abs_first_minus(x::Number) = abs(x)
abs_first_minus(x) = x