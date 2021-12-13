
DEFAULT_INSTRUCTIONS = [
  function report_bad_call(io::IO, config, expr, rules, prevop)
     println("""
     Unsupported input with
     expr=$expr
     prevop=$prevop
     and config=$config
     """)
     return false
  return false
  end,
  # function _unpack_args(io::IO, config, args, rules, prevop)
  # ### If no function has claimed the tuple, unpack it and try again. 
  # ### This is mainly to unpack the args to `latexify(args...)`. 
  # if args isa Tuple && length(args) == 1
  #   descend(io, config, args[1], prevop)
  #   return true
  # end
  # return false
  # end,
  function call(io::IO, config, expr, rules, prevop)
    if expr isa Expr && head(expr) == :call 
      h, op, args = unpack(expr)

      if op isa Symbol
        funcname = string(get(Latexify.function2latex, op, replace(string(op), "_"=>"\\_")))
        write(io, funcname)
      else
        descend(io, config, op, rules)
      end
      if length(args) >= 1 && head(args[1]) == :parameters
        write(io, "\\left( ")
        join_descend(io, config, args[2:end], rules, ", ")
        write(io, "; ")
        descend(io, config, args[1], rules)
        write(io, " \\right)")
        # _arg = "\\left( $(join(descend.(args[2:end]), ", ")); $(descend(args[1])) \\right)"
      else
        write(io, "\\left( ")
        join_descend(io, config, args, rules, ", ")
        write(io, " \\right)")
        # _arg = "\\left( " * join(descend.(args), ", ") * " \\right)"
      end
        return  true
    end
  return false
  end,
  function _aligned(io::IO, config, expr, rules, prevop)
    expr isa Tuple{T, T} where T <: AbstractArray || return false
    display("here")
    return false
  end,
  # function _sqrt(io::IO, config, ex, rules, prevop)
  #   operation(ex) == :sqrt ? "\\$(operation(ex)){$(arguments(ex)[1])}" : nothing
  # return false
  # end,
  # function _abs(io::IO, config, ex, rules, prevop)
  #   operation(ex) == :abs ? "\\left\\|$(arguments(ex)[1])\\right\\|" : nothing
  # return false
  # end,
  # function _single_comparison(io::IO, config, ex, args...)
  #   if operation(ex) ∈ keys(comparison_operators) && length(arguments(ex)) == 2
  #       str = "$(arguments(ex)[1]) $(comparison_operators[operation(ex)]) $(arguments(ex)[2])"
  #       str = "\\left( $str \\right)"
  #       return str
  #   end
  # return false
  # end,
  # function _if(io::IO, config, ex, rules, prevop)
  #   if ex isa Expr && head(ex) == :if
  #     str = build_if_else_body(
  #       ex.args,
  #       config[:ifstr],
  #       config[:elseifstr],
  #       config[:elsestr]
  #     )
  #     return """
  #       \\begin{cases}
  #       $str
  #       \\end{cases}"""
  #   end
  # return false
  # end,
  # function _elseif(io::IO, config, ex, rules, prevop)
  #   if ex isa Expr && head(ex) == :elseif
  #     str = build_if_else_body(
  #       ex.args,
  #       config[:elseifstr],
  #       config[:elseifstr],
  #       config[:elsestr]
  #     )
  #   end
  # return false
  # end,
  # function _oneline_function(io::IO, config, ex, rules, prevop)
  #   if head(ex) == :function && length(arguments(ex)) == 1
  #     return "$(descend(operation(ex), head(ex))) = $(descend(arguments(ex)[1], head(ex)))"
  #   end
  # return false
  # end,
  # function _return(io::IO, config, ex, rules, prevop)
  #   head(ex) == :return && length(arguments(ex)) == 0 ? descend(operation(ex)) : nothing
  # return false
  # end,
  # function _chained_comparisons(io::IO, config, ex, _...)
  #   if head(ex) == :comparison && Symbol.(arguments(ex)[1:2:end]) ⊆ keys(comparison_operators)
  #       str = join([isodd(i) ? "$var" : comparison_operators[Symbol(var)] for (i, var) in enumerate(descend.(vcat(operation(ex), arguments(ex))))], " ")
  #       str = "\\left( $str \\right)"
  #       return str
  #   end
  # return false
  # end,
  # function _type_annotation(io::IO, config, ex, rules, prevop)
  #   if head(ex) == :(::)
  #     if length(arguments(ex)) == 0 
  #       return "::$(operation(ex))"
  #     elseif length(arguments(ex)) == 1 
  #      return "$(operation(ex))::$(arguments(ex)[1])" 
  #     end
  #   end
  # return false
  # end,
  # function _wedge(io::IO, config, ex, rules, prevop)
  #   head(ex) == :(&&) && length(arguments(ex)) == 1 ? "$(descend(operation(ex))) \\wedge $(descend(arguments(ex)[1]))" : nothing
  # return false
  # end,
  # function _vee(io::IO, config, ex, rules, prevop)
  #   head(ex) == :(||) && length(arguments(ex)) == 1 ? "$(descend(operation(ex))) \\vee $(descend(arguments(ex)[1]))" : nothing
  # return false
  # end,
  # function _negation(io::IO, config, ex, rules, prevop)
  #   operation(ex) == :(!) ? "\\neg $(arguments(ex)[1])" : nothing
  # return false
  # end,
  # function _kw(io::IO, config, x, args...)
  #   head(x) == :kw ? "$(descend(operation(x))) = $(descend(arguments(x)[1]))" : nothing
  # return false
  # end,
  # function _parameters(io::IO, config, x, args...)
  #   head(x) == :parameters ? join(descend.(vcat(operation(x), arguments(x))), ", ") : nothing
  # return false
  # end,
  # function _indexing(io::IO, config, x, rules, prevop)
  #   if head(x) == :ref
  #       if config[:index] == :subscript
  #           return "$(operation(x))_{$(join(arguments(x), ","))}"
  #       elseif config[:index] == :bracket
  #           argstring = join(descend.(arguments(x)), ", ")
  #           return "$(descend(operation(x)))\\left[$argstring\\right]"
  #       else
  #           throw(ArgumentError("Incorrect `index` keyword argument to latexify. Valid values are :subscript and :bracket"))
  #       end
  #   end
  # return false
  # end,
  # function _broadcast_macro(io::IO, config, ex, rules, prevop)
  #   if head(ex) == :macrocall && operation(ex) == Symbol("@__dot__")
  #       return descend(arguments(ex)[end])
  #   end
  # return false
  # end,
  # function _block(io::IO, config, x, args...)
  #   if head(x) == :block 
  #     return descend(vcat(operation(x), arguments(x))[end])
  #   end
  # return false
  # end,
  function number(io::IO, config, x, rules, prevop) 
    if x isa Number
      try isinf(x) && write(io, "\\infty") && return true; catch; end
      fmt = config[:fmt]
      fmt isa String && (fmt = PrintfNumberFormatter(fmt))
      str = string(fmt(x))
      sign(x) == -1 && prevop == :^ && (str = surround(str))
      write(io, str)
      return true
    end
  return false
  end,
  function rational_expr(io::IO, config, x, rules, prevop) 
    if operation(x) == ://
      if arguments(x)[2] == 1 
        descend(io, config, arguments(x)[1], rules, prevop)
        return true
      else
        descend(io, config, :($(arguments(x)[1])/$(arguments(x)[2])), rules, prevop)
        return true
      end
    end
  return false
  end,
  function rational(io::IO, config, x, rules, prevop) 
    if x isa Rational
      prevop ∈ [:*, :^] && write(io, "\\left( ")
      x.den == 1 ? descend(io, config, x.num, rules, prevop) : descend(io, config, :($(x.num)/$(x.den)), rules, prevop)
      prevop ∈ [:*, :^] && write(io, " \\right)")
      return true
    end
  return false
  end,
  # function complex(io::IO, config, z, rules, prevop) 
  #   if z isa Complex
  #     str = "$(descend(z.re))$(z.im < 0 ? "-" : "+" )$(descend(abs(z.im)))\\textit{i}"
  #     prevop ∈ [:*, :^] && (str = surround(str))
  #     return str
  #   end
  # return false
  # end,
  # function _missing(io::IO, config, x, rules, prevop) 
  #   if ismissing(x)
  #     "\\textrm{NA}"
  #   end
  # return false
  # end,
  # function _nothing(io::IO, config, x, rules, prevop)
  #   x === nothing ? "" : nothing
  # return false
  # end,
  function symbol(io::IO, config, sym, rules, _)
    if sym isa Symbol
      str = string(sym == :Inf ? :∞ : sym)
      str = convert_subscript(str)
      config[:convert_unicode] && (str = unicode2latex(str))
      write(io, str)
      return true
    end
  return false
  end,
  # function _char(io::IO, config, c, rules, args...)
  #   c isa Char ? string(c) : nothing
  # return false
  # end,
  # function array(io::IO, config, x, args...) 
  #   x isa AbstractArray ? _latexarray(x) : nothing
  # return false
  # end,
  # function tuple(io::IO, config, x, args...) 
  #   x isa Tuple ? _latexarray(x) : nothing
  # return false
  # end,
  # function vect_exp(io::IO, config, x, args...) 
  #   head(x) ∈ [:vect, :vcat] ? _latexarray(expr_to_array(x)) : nothing
  # return false
  # end,
  # function hcat_exp(io::IO, config, x, args...) 
  #   # head(x)==:hcat ? _latexarray(permutedims(vcat(operation(x), arguments(x)))) : nothing
  #   head(x)==:hcat ? _latexarray(expr_to_array(x)) : nothing
  # return false
  # end,
  #  (expr, prevop, config) -> begin
  #  h, op, args = unpack(expr)
  # #  if (expr isa LatexifyOperation || h == :LatexifyOperation) && op == :merge
  #  if h == :call && op == :latexifymerge
  #    join(descend.(args), "")
  #  end
  # return false
  # end,
  # function parse_string(io::IO, config, str, rules, prevop)
  #   if str isa AbstractString
  #     try
  #         ex = Meta.parse(str)
  #         return descend(ex, prevop)
  #     catch ParseError
  #         error("""
  #           in Latexify.jl:
  #           You are trying to create latex-maths from a `String` that cannot be parsed as
  #           an expression.

  #           `latexify` will, by default, try to parse any string inputs into expressions
  #           and this parsing has just failed.

  #           If you are passing strings that you want returned verbatim as part of your input,
  #           try making them `LaTeXString`s first.

  #           If you are trying to make a table with plain text, try passing the keyword
  #           argument `latex=false`. You should also ensure that you have chosen an output
  #           environment that is capable of displaying not-maths objects. Try for example
  #           `env=:table` for a latex table or `env=:mdtable` for a markdown table.
  #           """)
  #     end
  #   end
  # return false
  # end,
  # function _pass_through_LaTeXString_substrings(io::IO, config, str, args...)
  #   str isa SubString{LaTeXString} ? String(str) : nothing
  # return false
  # end,
  # function _pass_through_LaTeXString(io::IO, config, str, args...)
  #   str isa LaTeXString  ? str.s : nothing
  # return false
  # end,
  # function _tuple_expr(io::IO, config, expr, rules, prevop)
  #   head(expr) == :tuple ? join(vcat(operation(expr), arguments(expr)), ", ") : nothing
  # return false
  # end,
  # function strip_broadcast_dot(io::IO, config, expr, rules, prevop)
  #   h, op, args = unpack(expr)
  #   if expr isa Expr && config[:strip_broadcast] && h == :call && startswith(string(op), '.')
  #     return string(descend(Expr(h, Symbol(string(op)[2:end]), args...), prevop))
  #   end
  # return false
  # end,
  # function strip_broadcast_dot_call(io::IO, config, expr, rules, prevop)
  #   h, op, args = unpack(expr)
  #   if expr isa Expr && config[:strip_broadcast] && h == :. 
  #     return descend(Expr(:call, op, args[1].args...), prevop)
  #   end
  # return false
  # end,
  # function plusminus(io::IO, config, expr, rules, prevop)
  #   h, op, args = unpack(expr)
  #   if h == :call && op == :±
  #     return "$(descend(args[1], op)) \\pm $(descend(args[2], op))"
  #   end
  # return false
  # end,
  function division(io::IO, config, expr, rules, prevop)
    h, op, args = unpack(expr)
    if h == :call && op == :/
      write(io, "\\frac{")
      descend(io, config, args[1], rules, op)
      write(io, "}{")
      descend(io, config, args[2], rules, op)
      write(io, "}")
      # "\\frac{$(descend(args[1], op))}{$(descend(args[2], op))}"
      return true
    end
  return false
  end,
  function multiplication(io::IO, config, expr, rules, prevop)
    h, op, args = unpack(expr)
    if h == :call && op == :*
      # join(descend.(args, op), "$(config[:mulsym])")
      join_descend(io, config, args, rules, config[:mulsym])
      return true
    end
  return false
  end,
  function addition(io::IO, config, expr, rules, prevop)
    h, op, args = unpack(expr)
    if h == :call && op == :+
      prevop ∈ [:*, :^] && write(io, "\\left( ")
      str = join_descend(io, config, args, rules, " + ") 
      # str = replace(str, "+ -"=>"-")
      # prevop ∈ [:*, :^] && (str = surround(str))
      prevop ∈ [:*, :^] && write(io, " \\right)")
      # write()
      return true
    end
  return false
  end,
  # function subtraction(io::IO, config, expr, rules, prevop)
  #   # this one is so gnarly because it tries to fix stuff like - - or -(-(x-y))
  #   # -(x) is also a bit different to -(x, y) which does not make things simpler
  #   h, op, args = unpack(expr)
  #   if h == :call && op == :-
  #     if length(args) == 1
  #       if operation(args[1]) == :- && length(arguments(args[1])) == 1
  #         return descend(arguments(args[1])[1], prevop)
  #       elseif args[1] isa Number && sign(args[1]) == -1
  #         # return _latexraw(-args[1]; config...)
  #         return descend(-args[1], op)
  #       else
  #         _arg = operation(args[1]) ∈ [:-, :+, :±] ? surround(args[1]) : args[1]
  #         return prevop == :^ ? surround("$op$_arg") : "$op$_arg"
  #       end
        
  #     elseif length(args) == 2
  #       if args[2] isa Number && sign(args[2]) == -1
  #         return "$(descend(args[1], :+)) + $(descend(-args[2], :+))"
  #       end
  #       if operation(args[2]) == :- && length(arguments(args[2])) == 1
  #         return "$(descend(args[1], :+)) + $(descend(arguments(args[2])[1], :+))"
  #       end
  #       if operation(args[2]) ∈ [:-, :.-, :+, :.+]
  #         return "$(descend(args[1], op)) - $(surround(descend(args[2], op)))"
  #       end
  #       str = join(descend.(args, op), " - ") 
  #       prevop ∈ [:*, :^] && (str = surround(str))
  #       return str
  #     end
  #   end
  # return false
  # end,
  # function pow(io::IO, config, expr, rules, prevop)
  #   h, op, args = unpack(expr)
  #   if h == :call && op == :^
  #       if operation(args[1]) in Latexify.trigonometric_functions
  #           fsym = operation(args[1])
  #           fstring = get(Latexify.function2latex, fsym, "\\$(fsym)")
  #           "$fstring^{$(descend(args[2], op))}\\left( $(join(descend.(arguments(args[1]), operation(args[1])), ", ")) \\right)"
  #       else
  #           "$(descend(args[1], op))^{$(descend(args[2], Val{:NoSurround}()))}"
  #       end
  #   end
  # return false
  # end,
  #     write(io, " = ")
  #     descend(io, config, args[1], h)
  #     return true
  #   end
  #   return false
  # end, 
  # function l_funcs(io::IO, config, ex, rules, prevop)
  #   if head(ex) == :call && startswith(string(operation(ex)), "l_")
  #     l_func = string(operation(ex))[3:end]
  #     return "\\$(l_func){$(join(descend.(arguments(ex), prevop), "}{"))}"
  #   end
  # return false
  # end,
]

function build_if_else_body(io::IO, config, args, ifstr, elseifstr, elsestr)
      _args = filter(x -> !(x isa LineNumberNode), args)
      dargs = descend.(_args)
      str = if length(_args) == 2
        """
        $(dargs[2]) & $ifstr $(dargs[1])"""
      elseif length(_args) == 3 && head(_args[end]) == :elseif
        """
        $(dargs[2]) & $ifstr $(dargs[1])\\\\
        $(dargs[3])"""
      elseif length(_args) == 3 
        """
        $(dargs[2]) & $ifstr $(dargs[1])\\\\
        $(dargs[3]) & $elsestr"""
      else 
        throw(ArgumentError("Unexpected if/elseif/else statement to latexify. This could well be a Latexify.jl bug."))
      end
      return str
end