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

# KeywordArgument(:template, [:array], "`Bool`", "`false`", "description", [:Any]),
keyword_arguments = [
    KeywordArgument(:starred, [:align, :array], "`Bool`", "`false`", "Star the environment to prevent equation numbering.", [:Any]),
    KeywordArgument(:separator, [:align], "`String`", "`\" =& \"`", "Specify how to separate the left hand side and the right.", [:Any]),
    KeywordArgument(:transpose, [:array], "`Bool`", "`true`", "Flip rows for columns.", [:Any]),
    KeywordArgument(:double_linebreak, [:array, :align], "`Bool`", "`false`", "Add an extra `\\\\` to the end of the line.", [:Any]),
    KeywordArgument(:bracket, [:align], "`Bool`", "`false`", "Surround variables with square brackets.", [:ParameterizedFunction, :ReactionNetwork]),
    ]

import Latexify: mdtable

function mdtable(list::Array{KeywordArgument}; types=true)
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
