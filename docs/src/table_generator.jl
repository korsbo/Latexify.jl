#=
In the documents, there are tables of what keyword arguments can be passed
to latexify for different outputs or inputs. This file contains that information
as well as the means to generate tables for the documentation.

This exists so that I do not have to repeat myself and to type the same
information into multiple places (that way lies madness!). With this code, I
can simply filter the information according to some criterion and automatically
have it inserted in the docs.
=#
using Latexify

struct KeywordArgument
    kw::Symbol
    env::Array{Symbol}
    values::String
    default::String
    description::String
    types::Array{Symbol}
end

#     KeywordArgument(:template, [:array], "`Bool`", "`false`", "description", [:Any]),
keyword_arguments = [
    KeywordArgument(:starred, [:align, :array, :arrow, :equation], "`Bool`", "`false`", "Star the environment to prevent equation numbering.", [:Any]),
    KeywordArgument(:separator, [:align], "`String`", "`\" =& \"`", "Specify how to separate the left hand side and the right.", [:Any]),
    KeywordArgument(:transpose, [:array, :tabular, :mdtable], "`Bool`", "`true`", "Flip rows for columns.", [:Any]),
    KeywordArgument(:double_linebreak, [:array, :align, :arrow], "`Bool`", "`false`", "Add an extra `\\\\` to the end of the line.", [:Any]),
    KeywordArgument(:bracket, [:align], "`Bool`", "`false`", "Surround variables with square brackets.", [:ParameterizedFunction, :ReactionNetwork]),
    KeywordArgument(:noise, [:align], "`Bool`", "`false`", "Display the noise function instead of the deterministic one.", [:ReactionNetwork]),
    KeywordArgument(:adjustment, [:tabular, :array, :mdtable], "`:c` for centered, `:l` for left, `:r` for right, or a vector with one such symbol per column.", "`:c`", "Set the adjustment of text within the table cells.", [:Any]),
    KeywordArgument(:expand, [:arrow, :align], "`Bool`", "`true`", "Expand functions such as `hill(x, v, k, n)` to their mathematical expression.", [:ReactionNetwork]),
    KeywordArgument(:mathjax, [:arrow], "`Bool`", "`true`", "Add `\\require{mhchem}` to tell MathJax to load the required module.", [:ReactionNetwork]),
    KeywordArgument(:latex, [:mdtable, :tabular], "`Bool`", "`true`", "Toggle latexification of the table elements.", [:Any]),
    KeywordArgument(:head, [:mdtable, :tabular], "`Array`", "`[]`", "Add a header to the table. It will error if it is not of the right length (unless empty). ", [:Any]),
    KeywordArgument(:side, [:mdtable, :tabular], "`Array`", "`[]`", "Add a leftmost column to the table. It will error if it is not of the right length (unless empty). ", [:Any]),
    KeywordArgument(:fmt, [:mdtable, :tabular, :align, :array, :raw, :inline], "format string", "`\"\"`", "Format number output in accordance with Printf. Example: \"%.2e\"", [:Any]),
    KeywordArgument(:imaginary_unit, [:mdtable, :tabular, :align, :array, :raw, :inline], "`String`", "`\"\\\\mathit{i}\"`", "The symbol to use to represent the imaginary unit", [:Any]),
    KeywordArgument(:escape_underscores, [:mdtable, :mdtext], "`Bool`", "`false`", "Prevent underscores from being interpreted as formatting.", [:Any]),
    KeywordArgument(:convert_unicode, [:mdtable, :tabular, :align, :array, :raw, :inline], "`Bool`", "`true`", "Convert unicode characters to latex commands, for example `α` to `\\alpha`", [:Any]),
    KeywordArgument(:cdot, [:mdtable, :tabular, :align, :array, :raw, :inline], "`Bool`", "`true`", "Toggle between using `\\cdot` or just a space to represent multiplication.", [:Any]),
    KeywordArgument(:symbolic, [:align], "`Bool`", "`false`", "Use symbolic calculations to clean up the expression.", [:ReactionNetwork]),
    KeywordArgument(:clean, [:align], "`Bool`", "`false`", "Clean out `1*` terms. Only useful for Catalyst (then named DiffEqBiological) versions 3.4 or below.", [:ReactionNetwork]),
    KeywordArgument(:rows, [:align], "Iterable or symol", ":all", "Which rows to include in the output.", [:Any]),
    KeywordArgument(:booktabs, [:tabular], "`Bool`", "`false`", "Add top, mid and bottom booktabs rule", [:Any]),
    KeywordArgument(:index, [:mdtable, :tabular, :align, :array, :raw, :inline], "`Symb`", "`:bracket`", "Represent index specification with `:bracket` (`u[1]`) or `:subscript` (`u_1`). ", [:Any]),
    KeywordArgument(:snakecase, [:mdtable, :tabular, :align, :array, :raw, :inline], "`Bool`", "`false`", "Treat underscores as literal underscores (if not, treat first underscore as subscript).", [:Any]),
    KeywordArgument(:safescripts, [:mdtable, :tabular, :align, :array, :raw, :inline], "`Bool`", "`false`", "Put scripts inside brackets (`a{_b}`), sometimes making them uglier, but making alternating scripts possible.", [:Any]),
    KeywordArgument(:arraystyle, [:array], "`Symbol`, `String`, `NTuple{3, String}`", "`:square`", "How to style (brackets around) arrays. `Symbol`s correspond to predefined styles: `:square`, `:round`, `:curly`, `:bmatrix`, `:pmatrix`. A string will be used as an environment, with no further brackets (e.g. `\"vmatrix\"`). Tuples should be `(<starting bracket>, <ending bracket>, <environment>)`, for instance `:square` corresponds to `(\"\\n\\\\left[\", \"\\\\right]\\n\", \"array\")`.", [:Any]),
#     KeywordArgument(:template, [:array], "`Bool`", "`false`", "description", [:Any]),
    ]

#= @latexrecipe function f(list::Array{KeywordArgument}; types=true) =#
#=     isempty(list) && return nothing =#
#=     sort!(list, by=x->x.kw) =#
#=     keys = ["`:$(x.kw)`" for x in list] =#
#=     # values = [join(["$i" for i in x.values], ", ") for x in list] =#
#=     applicable_types = [join(["`$i`" for i in x.types], ", ") for x in list] =#
#=     values = [x.values for x in list] =#
#=     defaults = [x.default for x in list] =#
#=     descriptions = [x.description for x in list] =#

#=     latex --> false =#
#=     env := :mdtable =#

#=     if any(x->x.types != [:Any], list) && types =#
#=         head --> ["Keyword", "Values", "Default", "Applicable types", "Description"] =#
#=         return hcat(keys, values, defaults, applicable_types, descriptions) =#
#=     else =#
#=         head --> ["Keyword", "Values", "Default", "Description"] =#
#=         return hcat(keys, values, defaults, descriptions) =#
#=     end =#
#= end =#

import Latexify: mdtable
function mdtable(list::Array{KeywordArgument}; types=true, kwargs...)
    isempty(list) && return nothing
    sort!(list, by=x->x.kw)
    keys = ["`:$(x.kw)`" for x in list]
    # values = [join(["$i" for i in x.values], ", ") for x in list]
    applicable_types = [join(["`$i`" for i in x.types], ", ") for x in list]
    values = [x.values for x in list]
    defaults = [x.default for x in list]
    descriptions = [x.description for x in list]
    if any(x->x.types != [:Any], list) && types
        mdtable(hcat(keys, values, defaults, applicable_types, descriptions), head=["Keyword", "Values", "Default", "Applicable types", "Description"], latex=false)
    else
        mdtable(hcat(keys, values, defaults, descriptions), head=["Keyword", "Values", "Default", "Description"], latex=false)
    end
end
