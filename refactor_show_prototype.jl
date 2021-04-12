using Pkg
Pkg.activate(@__DIR__)
using Latexify
import Base: show
using SnoopCompile


const Lmime = MIME"text/latexify"
const lmime = MIME("text/latexify")

const opdict = (;
    :* => :Multiplication,
    :/ => :Division,
    :+ => :Addition,
    :- => :Subtraction,
    :^ => :Pow,
)
for T in values(opdict)
    println(T)
end
abstract type AbstractLatexifyOperation end
for T in values(opdict)
    @eval(
        struct $(T){S} <: AbstractLatexifyOperation
            args::S
        end
    )
end

const ops = (; (keys(opdict) .=> eval.(values(opdict)))...)
ops[:*]([:a, :b])

for op in pairs(ops)
    println(op[1], op[2])
    @eval latexop(::Val{:call}, ::Val{$(QuoteNode(op[1]))}, args) = $(op[2])(args)
end


abstract type AbstractLatexifyEnvironment end
for T in [:Align, :Equation, :Inline, :Bracket, :Raw, :Table]
    @eval(
        struct $(T){S} <: AbstractLatexifyEnvironment
            args::S
        end
    )
end
Align(x, y) = Align(hcat(x, y))



latexop(ex::Expr) = latexop(Val(ex.head), Val(ex.args[1]), ex.args[2:end])
latexop(x) = x
latexop(x...) = x
latexop(x::Matrix) = Align(x)
latexop(::Val{:align}, x) = Align(x)
latexop(::Val{:equation}, x) = Equation(x)
latexop(lhs::Vector, rhs::Vector) = Align(lhs, rhs)

show(io::IO, ::MIME"text/latexify", x) = print(io, x)

compare_precedence(a, b) = Base.operator_precedence(a) > Base.operator_precedence(b)
function show(io::IO, mime::MIME"text/latexify", x::Multiplication)
    surround = compare_precedence(get(io, :precedence, :+), :*)
    io = IOContext(io, :precedence=>:*)
    surround ? write(io, "\\left( ") : nothing
    show(io, mime, x.args[1])
    write(io, get(io, :multsign, " \\cdot "))
    show(io, mime, x.args[2])
    surround ? write(io, "\\right) ") : nothing
end

function show(io::IO, mime::MIME"text/latexify", x::Addition)
    surround = compare_precedence(get(io, :precedence, :+), :+)
    io = IOContext(io, :precedence=>:+)
    surround ? write(io, "\\left(") : nothing
    for arg in x.args[1:end-1]
        show(io, mime, arg)
        write(io, " + ")
    end
    show(io, mime, x.args[end])
    surround ? write(io, "\\right)") : nothing
end

function show(io::IO, mime::MIME"text/latexify", x::Division)
    write(io, "\\frac{")
    show(io, mime, x.args[1])
    write(io, "}{")
    show(io, mime, x.args[2])
    write(io, "}")
end

function show(io::IO, mime::MIME"text/latexify", x::Expr)
    show(io, mime, latexop(x))
end


function join_matrix(io, m, delim = " & ", eol="\\\\\n")
   nrows, ncols = size(m)
   mime = MIME("text/latexify")
   for (i, row) in enumerate(eachrow(m))
       for x in row[1:end-1]
            show(io, mime, x)
            write(io, delim)
       end
       show(io, mime, row[end])
       i != nrows && write(io, eol)
    end
    return nothing
end


function show(io::IO, mime::MIME"text/latexify", x::Align)
    write(io, "\\begin{align}\n")
    # join_show(io, x.args, " &= ")
    join_matrix(io, x.args, " &= ")
    write(io, "\n\\end{align}")
end


function _latex(args...; kwargs...)
    io = IOBuffer(; append=true)
    _latex(io, args...; kwargs...)
    String(take!(io))
end
function _latex(io::IO, args...; kwargs...)
    io = IOContext(io, kwargs...)
    show(io, MIME("text/latexify"), latexop(args...))
    return nothing
end

io = IOBuffer(; append=true)
@time _latex(:(x/y))
tinf = @snoopi_deep _latex(io, [1 2; :(x/y) 3])
@time read(io, String) 
using ProfileView
ProfileView.view(flamegraph(tinf))