abstract type LatexifyException <: Exception end

struct NoRecipeException <: LatexifyException
    type::Type
end
function Base.showerror(io::IO, e::NoRecipeException)
    return print(io, "cannot latexify objects of type ", e.type)
end
struct UnrecognizedExpressionException <: LatexifyException
    ex::Expr
end
function Base.showerror(io::IO, e::UnrecognizedExpressionException)
    return print(
        io,
        "latexoperation does not know what to do with one of the expressions provided (",
        e.ex,
        ")",
    )
end

struct UnrepresentableException <: LatexifyException
    desc::String
end
function Base.showerror(io::IO, e::UnrepresentableException)
    return print(io, e.desc, " cannot be represented as LaTeX")
end

struct MathParseError <: LatexifyException
    input::String
end
function Base.showerror(io::IO, e::MathParseError)
    return print(
        io,
        """
    You are trying to create LaTeX maths from a `String` that cannot be parsed as an expression: `""",
        e.input,
        """`.
`latexify` will, by default, try to parse any string inputs into expressions and this parsing has just failed.
If you are passing strings that you want returned verbatim as part of your input, try making them `LaTeXString`s first.
If you are trying to make a table with plain text entries, try passing the keyword argument `latex=false`.
You should also ensure that you have chosen an output environment that is capable of displaying non-maths objects.
Try for example `env=:table` for a LaTeX table or `env=:mdtable` for a markdown table.
""",
    )
end

struct RecipeException <: Exception
    msg::String
end
Base.showerror(io::IO, e::RecipeException) = print(io, e.msg)

struct LatexifyRenderError <: Exception
    logfilename::String
end
function Base.showerror(io::IO, e::LatexifyRenderError)
    isfile(e.logfilename) ||
        return println(io, "an error occured while rendering LaTeX, no log file available.")
    println(io, "an error occured while rendering LaTeX: ")
    secondline = false
    for l in eachline(e.logfilename)
        if secondline
            println(io, "\t", l)
            break
        end
        m = match(r"^! (.*)$", l)
        isnothing(m) && continue
        println(io, "\t", m[1])
        secondline = true
    end
    return print(io, "Check the log file at ", e.logfilename, " for more information")
end
