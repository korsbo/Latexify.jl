
const MATCHING_FUNCTIONS = [
  function report_bad_call(expr, prevop, config)
     println("""
     Unsupported input with
     expr=$expr
     prevop=$prevop
     and config=$config
     """)
     return nothing
  end,
  function call(expr, prevop, config)
    if expr isa Expr && head(expr) == :call 
      h, op, args = unpack(expr)

      if op isa Symbol
        funcname = string(get(Latexify.function2latex, op, replace(string(op), "_"=>"\\_")))
      else
        funcname = descend(op)
      end
      if length(args) >= 1 && head(args[1]) == :parameters
        _arg = "\\left( $(join(descend.(args[2:end]), ", ")); $(descend(args[1])) \\right)"
      else
        _arg = "\\left( " * join(descend.(args), ", ") * " \\right)"
      end
        return  funcname * _arg
    end
  end,
  function _sqrt(ex, prevop, config)
    operation(ex) == :sqrt ? "\\$(operation(ex)){$(arguments(ex)[1])}" : nothing
  end,
  function _abs(ex, prevop, config)
    operation(ex) == :abs ? "\\left\\|$(arguments(ex)[1])\\right\\|" : nothing
  end,
  function _single_comparison(ex, args...)
    if operation(ex) ∈ keys(comparison_operators) && length(arguments(ex)) == 2
        str = "$(arguments(ex)[1]) $(comparison_operators[operation(ex)]) $(arguments(ex)[2])"
        str = "\\left( $str \\right)"
        return str
    end
  end,
  function _if(ex, prevop, config)
    if ex isa Expr && head(ex) == :if
      str = build_if_else_body(
        ex.args,
        getconfig(:ifstr),
        getconfig(:elseifstr),
        getconfig(:elsestr)
      )
      return """
        \\begin{cases}
        $str
        \\end{cases}"""
    end
  end,
  function _elseif(ex, prevop, config)
    if ex isa Expr && head(ex) == :elseif
      str = build_if_else_body(
        ex.args,
        getconfig(:elseifstr),
        getconfig(:elseifstr),
        getconfig(:elsestr)
      )
    end
  end,
  function _oneline_function(ex, prevop, config)
    if head(ex) == :function && length(arguments(ex)) == 1
      return "$(descend(operation(ex), head(ex))) = $(descend(arguments(ex)[1], head(ex)))"
    end
  end,
  function _return(ex, prevop, config)
    head(ex) == :return && length(arguments(ex)) == 0 ? descend(operation(ex)) : nothing
  end,
  function _chained_comparisons(ex, _...)
    if head(ex) == :comparison && Symbol.(arguments(ex)[1:2:end]) ⊆ keys(comparison_operators)
        str = join([isodd(i) ? "$var" : comparison_operators[Symbol(var)] for (i, var) in enumerate(descend.(vcat(operation(ex), arguments(ex))))], " ")
        str = "\\left( $str \\right)"
        return str
    end
  end,
  function _type_annotation(ex, prevop, config)
    if head(ex) == :(::)
      if length(arguments(ex)) == 0 
        return "::$(operation(ex))"
      elseif length(arguments(ex)) == 1 
       return "$(operation(ex))::$(arguments(ex)[1])" 
      end
    end
  end,
  function _wedge(ex, prevop, config)
    head(ex) == :(&&) && length(arguments(ex)) == 1 ? "$(descend(operation(ex))) \\wedge $(descend(arguments(ex)[1]))" : nothing
  end,
  function _vee(ex, prevop, config)
    head(ex) == :(||) && length(arguments(ex)) == 1 ? "$(descend(operation(ex))) \\vee $(descend(arguments(ex)[1]))" : nothing
  end,
  function _negation(ex, prevop, config)
    operation(ex) == :(!) ? "\\neg $(arguments(ex)[1])" : nothing
  end,
  function _kw(x, args...)
    head(x) == :kw ? "$(descend(operation(x))) = $(descend(arguments(x)[1]))" : nothing
  end,
  function _parameters(x, args...)
    head(x) == :parameters ? join(descend.(vcat(operation(x), arguments(x))), ", ") : nothing
  end,
  function _indexing(x, prevop, config)
    if head(x) == :ref
        if getconfig(:index) == :subscript
            return "$(operation(x))_{$(join(arguments(x), ","))}"
        elseif getconfig(:index) == :bracket
            argstring = join(descend.(arguments(x)), ", ")
            return "$(descend(operation(x)))\\left[$argstring\\right]"
        else
            throw(ArgumentError("Incorrect `index` keyword argument to latexify. Valid values are :subscript and :bracket"))
        end
    end
  end,
  function _broadcast_macro(ex, prevop, config)
    if head(ex) == :macrocall && operation(ex) == Symbol("@__dot__")
        return descend(arguments(ex)[end])
    end
  end,
  function _block(x, args...)
    if head(x) == :block 
      return descend(vcat(operation(x), arguments(x))[end])
    end
  end,
  function number(x, prevop, config) 
    if x isa Number
      try isinf(x) && return "\\infty" catch; end
      fmt = getconfig(:fmt)
      fmt isa String && (fmt = PrintfNumberFormatter(fmt))
      str = string(fmt(x))
      sign(x) == -1 && prevop == :^ && (str = surround(str))
      return str
    end
  end,
  function rational_expr(x, prevop, config) 
    if operation(x) == ://
      if arguments(x)[2] == 1 
        return descend(arguments[1], prevop)
      else
        descend(:($(arguments(x)[1])/$(arguments(x)[2])), prevop)
      end
    end
  end,
  function rational(x, prevop, config) 
    if x isa Rational
      str = x.den == 1 ? descend(x.num, prevop) : descend(:($(x.num)/$(x.den)), prevop)
      prevop ∈ [:*, :^] && (str = surround(str))
      return str
    end
  end,
  function complex(z, prevop, config) 
    if z isa Complex
      str = "$(descend(z.re))$(z.im < 0 ? "-" : "+" )$(descend(abs(z.im)))\\textit{i}"
      prevop ∈ [:*, :^] && (str = surround(str))
      return str
    end
  end,
  function _missing(x, prevop, config) 
    if ismissing(x)
      "\\textrm{NA}"
    end
  end,
  function _nothing(x, prevop, config)
    x === nothing ? "" : nothing
  end,
  function symbol(sym, _, config)
    if sym isa Symbol
      str = string(sym == :Inf ? :∞ : sym)
      str = convert_subscript(str)
      getconfig(:convert_unicode) && (str = unicode2latex(str))
      return str
    end
  end,
  function _char(c, args...)
    c isa Char ? string(c) : nothing
  end,
  function array(x, args...) 
    x isa AbstractArray ? _latexarray(x) : nothing
  end,
  function tuple(x, args...) 
    x isa Tuple ? _latexarray(x) : nothing
  end,
  function vect_exp(x, args...) 
    head(x) ∈ [:vect, :vcat] ? _latexarray(expr_to_array(x)) : nothing
  end,
  function hcat_exp(x, args...) 
    # head(x)==:hcat ? _latexarray(permutedims(vcat(operation(x), arguments(x)))) : nothing
    head(x)==:hcat ? _latexarray(expr_to_array(x)) : nothing
  end,
   (expr, prevop, config) -> begin
   h, op, args = unpack(expr)
  #  if (expr isa LatexifyOperation || h == :LatexifyOperation) && op == :merge
   if h == :call && op == :latexifymerge
     join(descend.(args), "")
   end
  end,
  function parse_string(str, prevop, config)
    if str isa AbstractString
      try
          ex = Meta.parse(str)
          return descend(ex, prevop)
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
    end
  end,
  function _pass_through_LaTeXString_substrings(str, args...)
    str isa SubString{LaTeXString} ? String(str) : nothing
  end,
  function _pass_through_LaTeXString(str, args...)
    str isa LaTeXString  ? str.s : nothing
  end,
  function _tuple_expr(expr, prevop, config)
    head(expr) == :tuple ? join(vcat(operation(expr), arguments(expr)), ", ") : nothing
  end,
  function strip_broadcast_dot(expr, prevop, config)
    h, op, args = unpack(expr)
    if expr isa Expr && config[:strip_broadcast] && h == :call && startswith(string(op), '.')
      return string(descend(Expr(h, Symbol(string(op)[2:end]), args...), prevop))
    end
  end,
  function strip_broadcast_dot_call(expr, prevop, config)
    h, op, args = unpack(expr)
    if expr isa Expr && config[:strip_broadcast] && h == :. 
      return descend(Expr(:call, op, args[1].args...), prevop)
    end
  end,
  function plusminus(expr, prevop, config)
    h, op, args = unpack(expr)
    if h == :call && op == :±
      return "$(descend(args[1], op)) \\pm $(descend(args[2], op))"
    end
  end,
  function division(expr, prevop, config)
    h, op, args = unpack(expr)
    if h == :call && op == :/
      "\\frac{$(descend(args[1], op))}{$(descend(args[2], op))}"
    end
  end,
  function multiplication(expr, prevop, config)
    h, op, args = unpack(expr)
    if h == :call && op == :*
      join(descend.(args, op), "$(config[:mulsym])")
    end
  end,
  function addition(expr, prevop, config)
    h, op, args = unpack(expr)
    if h == :call && op == :+
      str = join(descend.(args, op), " + ") 
      str = replace(str, "+ -"=>"-")
      prevop ∈ [:*, :^] && (str = surround(str))
      return str
    end
  end,
  function subtraction(expr, prevop, config)
    # this one is so gnarly because it tries to fix stuff like - - or -(-(x-y))
    # -(x) is also a bit different to -(x, y) which does not make things simpler
    h, op, args = unpack(expr)
    if h == :call && op == :-
      if length(args) == 1
        if operation(args[1]) == :- && length(arguments(args[1])) == 1
          return descend(arguments(args[1])[1], prevop)
        elseif args[1] isa Number && sign(args[1]) == -1
          # return _latexraw(-args[1]; config...)
          return descend(-args[1], op)
        else
          _arg = operation(args[1]) ∈ [:-, :+, :±] ? surround(args[1]) : args[1]
          return prevop == :^ ? surround("$op$_arg") : "$op$_arg"
        end
        
      elseif length(args) == 2
        if args[2] isa Number && sign(args[2]) == -1
          return "$(descend(args[1], :+)) + $(descend(-args[2], :+))"
        end
        if operation(args[2]) == :- && length(arguments(args[2])) == 1
          return "$(descend(args[1], :+)) + $(descend(arguments(args[2])[1], :+))"
        end
        if operation(args[2]) ∈ [:-, :.-, :+, :.+]
          return "$(descend(args[1], op)) - $(surround(descend(args[2], op)))"
        end
        str = join(descend.(args, op), " - ") 
        prevop ∈ [:*, :^] && (str = surround(str))
        return str
      end
    end
  end,
  function pow(expr, prevop, config)
    h, op, args = unpack(expr)
    if h == :call && op == :^
        if operation(args[1]) in Latexify.trigonometric_functions
            fsym = operation(args[1])
            fstring = get(Latexify.function2latex, fsym, "\\$(fsym)")
            "$fstring^{$(descend(args[2], op))}\\left( $(join(descend.(arguments(args[1]), operation(args[1])), ", ")) \\right)"
        else
            "$(descend(args[1], op))^{$(descend(args[2], Val{:NoSurround}()))}"
        end
    end
  end,
  function equals(expr, prevop, config)
    if head(expr) == :(=) 
      return "$(descend(expr.args[1], expr.head)) = $(descend(expr.args[2], expr.head))"
    end
  end, 
  function l_funcs(ex, prevop, config)
    if head(ex) == :call && startswith(string(operation(ex)), "l_")
      l_func = string(operation(ex))[3:end]
      return "\\$(l_func){$(join(descend.(arguments(ex), prevop), "}{"))}"
    end
  end,
]


function build_if_else_body(args, ifstr, elseifstr, elsestr)
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