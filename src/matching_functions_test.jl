
const MATCHING_FUNCTIONS_TEST = [
  function report_bad_call(io::IO, expr, prevop, config)
     println("""
     Unsupported input with
     expr=$expr
     prevop=$prevop
     and config=$config
     """)
     return nothing
  end,
  function call(io::IO, expr, prevop, config)
    if expr isa Expr && head(expr) == :call 
      h, op, args = unpack(expr)

      if op isa Symbol
        funcname = string(get(Latexify.function2latex, op, replace(string(op), "_"=>"\\_")))
        write(io, funcname)
      else
        decend(io, op)
      end
      if length(args) >= 1 && head(args[1]) == :parameters
        write(io, "\\left( ")
        join_decend(io, args[2:end], ", ")
        write(io, "; ")
        decend(io, args[1])
        write(io, " \\right)")
        # _arg = "\\left( $(join(decend.(args[2:end]), ", ")); $(decend(args[1])) \\right)"
      else
        write(io, "\\left( ")
        join_decend(io, args, ", ")
        write(io, " \\right)")
        # _arg = "\\left( " * join(decend.(args), ", ") * " \\right)"
      end
        return  true
    end
  end,
  # function _sqrt(io::IO, ex, prevop, config)
  #   operation(ex) == :sqrt ? "\\$(operation(ex)){$(arguments(ex)[1])}" : nothing
  # end,
  # function _abs(io::IO, ex, prevop, config)
  #   operation(ex) == :abs ? "\\left\\|$(arguments(ex)[1])\\right\\|" : nothing
  # end,
  # function _single_comparison(io::IO, ex, args...)
  #   if operation(ex) ∈ keys(comparison_operators) && length(arguments(ex)) == 2
  #       str = "$(arguments(ex)[1]) $(comparison_operators[operation(ex)]) $(arguments(ex)[2])"
  #       str = "\\left( $str \\right)"
  #       return str
  #   end
  # end,
  # function _if(io::IO, ex, prevop, config)
  #   if ex isa Expr && head(ex) == :if
  #     str = build_if_else_body(
  #       ex.args,
  #       getconfig(:ifstr),
  #       getconfig(:elseifstr),
  #       getconfig(:elsestr)
  #     )
  #     return """
  #       \\begin{cases}
  #       $str
  #       \\end{cases}"""
  #   end
  # end,
  # function _elseif(io::IO, ex, prevop, config)
  #   if ex isa Expr && head(ex) == :elseif
  #     str = build_if_else_body(
  #       ex.args,
  #       getconfig(:elseifstr),
  #       getconfig(:elseifstr),
  #       getconfig(:elsestr)
  #     )
  #   end
  # end,
  # function _oneline_function(io::IO, ex, prevop, config)
  #   if head(ex) == :function && length(arguments(ex)) == 1
  #     return "$(decend(operation(ex), head(ex))) = $(decend(arguments(ex)[1], head(ex)))"
  #   end
  # end,
  # function _return(io::IO, ex, prevop, config)
  #   head(ex) == :return && length(arguments(ex)) == 0 ? decend(operation(ex)) : nothing
  # end,
  # function _chained_comparisons(io::IO, ex, _...)
  #   if head(ex) == :comparison && Symbol.(arguments(ex)[1:2:end]) ⊆ keys(comparison_operators)
  #       str = join([isodd(i) ? "$var" : comparison_operators[Symbol(var)] for (i, var) in enumerate(decend.(vcat(operation(ex), arguments(ex))))], " ")
  #       str = "\\left( $str \\right)"
  #       return str
  #   end
  # end,
  # function _type_annotation(io::IO, ex, prevop, config)
  #   if head(ex) == :(::)
  #     if length(arguments(ex)) == 0 
  #       return "::$(operation(ex))"
  #     elseif length(arguments(ex)) == 1 
  #      return "$(operation(ex))::$(arguments(ex)[1])" 
  #     end
  #   end
  # end,
  # function _wedge(io::IO, ex, prevop, config)
  #   head(ex) == :(&&) && length(arguments(ex)) == 1 ? "$(decend(operation(ex))) \\wedge $(decend(arguments(ex)[1]))" : nothing
  # end,
  # function _vee(io::IO, ex, prevop, config)
  #   head(ex) == :(||) && length(arguments(ex)) == 1 ? "$(decend(operation(ex))) \\vee $(decend(arguments(ex)[1]))" : nothing
  # end,
  # function _negation(io::IO, ex, prevop, config)
  #   operation(ex) == :(!) ? "\\neg $(arguments(ex)[1])" : nothing
  # end,
  # function _kw(io::IO, x, args...)
  #   head(x) == :kw ? "$(decend(operation(x))) = $(decend(arguments(x)[1]))" : nothing
  # end,
  # function _parameters(io::IO, x, args...)
  #   head(x) == :parameters ? join(decend.(vcat(operation(x), arguments(x))), ", ") : nothing
  # end,
  # function _indexing(io::IO, x, prevop, config)
  #   if head(x) == :ref
  #       if getconfig(:index) == :subscript
  #           return "$(operation(x))_{$(join(arguments(x), ","))}"
  #       elseif getconfig(:index) == :bracket
  #           argstring = join(decend.(arguments(x)), ", ")
  #           return "$(decend(operation(x)))\\left[$argstring\\right]"
  #       else
  #           throw(ArgumentError("Incorrect `index` keyword argument to latexify. Valid values are :subscript and :bracket"))
  #       end
  #   end
  # end,
  # function _broadcast_macro(io::IO, ex, prevop, config)
  #   if head(ex) == :macrocall && operation(ex) == Symbol("@__dot__")
  #       return decend(arguments(ex)[end])
  #   end
  # end,
  # function _block(io::IO, x, args...)
  #   if head(x) == :block 
  #     return decend(vcat(operation(x), arguments(x))[end])
  #   end
  # end,
  function number(io::IO, x, prevop, config) 
    if x isa Number
      try isinf(x) && write(io, "\\infty") && return true; catch; end
      fmt = getconfig(:fmt)
      fmt isa String && (fmt = PrintfNumberFormatter(fmt))
      str = string(fmt(x))
      sign(x) == -1 && prevop == :^ && (str = surround(str))
      write(io, str)
      return true
    end
  end,
  # function rational_expr(io::IO, x, prevop, config) 
  #   if operation(x) == ://
  #     if arguments(x)[2] == 1 
  #       return decend(arguments[1], prevop)
  #     else
  #       decend:($(arguments(x)[1])/$(arguments(x)[2])), prevop)
  #     end
  #   end
  # end,
  # function rational(io::IO, x, prevop, config) 
  #   if x isa Rational
  #     str = x.den == 1 ? decend(x.num, prevop) : decend(:($(x.num)/$(x.den)), prevop)
  #     prevop ∈ [:*, :^] && (str = surround(str))
  #     return str
  #   end
  # end,
  # function complex(io::IO, z, prevop, config) 
  #   if z isa Complex
  #     str = "$(decend(z.re))$(z.im < 0 ? "-" : "+" )$(decend(abs(z.im)))\\textit{i}"
  #     prevop ∈ [:*, :^] && (str = surround(str))
  #     return str
  #   end
  # end,
  # function _missing(io::IO, x, prevop, config) 
  #   if ismissing(x)
  #     "\\textrm{NA}"
  #   end
  # end,
  # function _nothing(io::IO, x, prevop, config)
  #   x === nothing ? "" : nothing
  # end,
  function symbol(io::IO, sym, _, config)
    if sym isa Symbol
      str = string(sym == :Inf ? :∞ : sym)
      str = convert_subscript(str)
      getconfig(:convert_unicode) && (str = unicode2latex(str))
      write(io, str)
      return true
    end
  end,
  # function _char(io::IO, c, args...)
  #   c isa Char ? string(c) : nothing
  # end,
  # function array(io::IO, x, args...) 
  #   x isa AbstractArray ? _latexarray(x) : nothing
  # end,
  # function tuple(io::IO, x, args...) 
  #   x isa Tuple ? _latexarray(x) : nothing
  # end,
  # function vect_exp(io::IO, x, args...) 
  #   head(x) ∈ [:vect, :vcat] ? _latexarray(expr_to_array(x)) : nothing
  # end,
  # function hcat_exp(io::IO, x, args...) 
  #   # head(x)==:hcat ? _latexarray(permutedims(vcat(operation(x), arguments(x)))) : nothing
  #   head(x)==:hcat ? _latexarray(expr_to_array(x)) : nothing
  # end,
  #  (expr, prevop, config) -> begin
  #  h, op, args = unpack(expr)
  # #  if (expr isa LatexifyOperation || h == :LatexifyOperation) && op == :merge
  #  if h == :call && op == :latexifymerge
  #    join(decend.(args), "")
  #  end
  # end,
  # function parse_string(io::IO, str, prevop, config)
  #   if str isa AbstractString
  #     try
  #         ex = Meta.parse(str)
  #         return decend(ex, prevop)
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
  # end,
  # function _pass_through_LaTeXString_substrings(io::IO, str, args...)
  #   str isa SubString{LaTeXString} ? String(str) : nothing
  # end,
  # function _pass_through_LaTeXString(io::IO, str, args...)
  #   str isa LaTeXString  ? str.s : nothing
  # end,
  # function _tuple_expr(io::IO, expr, prevop, config)
  #   head(expr) == :tuple ? join(vcat(operation(expr), arguments(expr)), ", ") : nothing
  # end,
  # function strip_broadcast_dot(io::IO, expr, prevop, config)
  #   h, op, args = unpack(expr)
  #   if expr isa Expr && config[:strip_broadcast] && h == :call && startswith(string(op), '.')
  #     return string(decend(Expr(h, Symbol(string(op)[2:end]), args...), prevop))
  #   end
  # end,
  # function strip_broadcast_dot_call(io::IO, expr, prevop, config)
  #   h, op, args = unpack(expr)
  #   if expr isa Expr && config[:strip_broadcast] && h == :. 
  #     return decend(Expr(:call, op, args[1].args...), prevop)
  #   end
  # end,
  # function plusminus(io::IO, expr, prevop, config)
  #   h, op, args = unpack(expr)
  #   if h == :call && op == :±
  #     return "$(decend(args[1], op)) \\pm $(decend(args[2], op))"
  #   end
  # end,
  function division(io::IO, expr, prevop, config)
    h, op, args = unpack(expr)
    if h == :call && op == :/
      write(io, "\\frac{")
      decend(io, args[1], op)
      write(io, "}{")
      decend(io, args[2], op)
      write(io, "}")
      # "\\frac{$(decend(args[1], op))}{$(decend(args[2], op))}"
      return true
    end
  end,
  # function multiplication(io::IO, expr, prevop, config)
  #   h, op, args = unpack(expr)
  #   if h == :call && op == :*
  #     join(decend.(args, op), "$(config[:mulsym])")
  #   end
  # end,
  function addition(io::IO, expr, prevop, config)
    h, op, args = unpack(expr)
    if h == :call && op == :+
      prevop ∈ [:*, :^] && write(io, "\\left( ")
      str = join_decend(io, args, " + ") 
      # str = replace(str, "+ -"=>"-")
      # prevop ∈ [:*, :^] && (str = surround(str))
      prevop ∈ [:*, :^] && write(io, " \\right)")
      # write()
      return true
    end
  end,
  # function subtraction(io::IO, expr, prevop, config)
  #   # this one is so gnarly because it tries to fix stuff like - - or -(-(x-y))
  #   # -(x) is also a bit different to -(x, y) which does not make things simpler
  #   h, op, args = unpack(expr)
  #   if h == :call && op == :-
  #     if length(args) == 1
  #       if operation(args[1]) == :- && length(arguments(args[1])) == 1
  #         return decend(arguments(args[1])[1], prevop)
  #       elseif args[1] isa Number && sign(args[1]) == -1
  #         # return _latexraw(-args[1]; config...)
  #         return decend(-args[1], op)
  #       else
  #         _arg = operation(args[1]) ∈ [:-, :+, :±] ? surround(args[1]) : args[1]
  #         return prevop == :^ ? surround("$op$_arg") : "$op$_arg"
  #       end
        
  #     elseif length(args) == 2
  #       if args[2] isa Number && sign(args[2]) == -1
  #         return "$(decend(args[1], :+)) + $(decend(-args[2], :+))"
  #       end
  #       if operation(args[2]) == :- && length(arguments(args[2])) == 1
  #         return "$(decend(args[1], :+)) + $(decend(arguments(args[2])[1], :+))"
  #       end
  #       if operation(args[2]) ∈ [:-, :.-, :+, :.+]
  #         return "$(decend(args[1], op)) - $(surround(decend(args[2], op)))"
  #       end
  #       str = join(decend.(args, op), " - ") 
  #       prevop ∈ [:*, :^] && (str = surround(str))
  #       return str
  #     end
  #   end
  # end,
  # function pow(io::IO, expr, prevop, config)
  #   h, op, args = unpack(expr)
  #   if h == :call && op == :^
  #       if operation(args[1]) in Latexify.trigonometric_functions
  #           fsym = operation(args[1])
  #           fstring = get(Latexify.function2latex, fsym, "\\$(fsym)")
  #           "$fstring^{$(decend(args[2], op))}\\left( $(join(decend.(arguments(args[1]), operation(args[1])), ", ")) \\right)"
  #       else
  #           "$(decend(args[1], op))^{$(decend(args[2], Val{:NoSurround}()))}"
  #       end
  #   end
  # end,
  # function equals(io::IO, expr, prevop, config)
  #   if head(expr) == :(=) 
  #     return "$(decend(expr.args[1], expr.head)) = $(decend(expr.args[2], expr.head))"
  #   end
  # end, 
  # function l_funcs(io::IO, ex, prevop, config)
  #   if head(ex) == :call && startswith(string(operation(ex)), "l_")
  #     l_func = string(operation(ex))[3:end]
  #     return "\\$(l_func){$(join(decend.(arguments(ex), prevop), "}{"))}"
  #   end
  # end,
]


function build_if_else_body(io::IO, args, ifstr, elseifstr, elsestr)
      _args = filter(x -> !(x isa LineNumberNode), args)
      dargs = decend.(_args)
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