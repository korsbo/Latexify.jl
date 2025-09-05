# using Pkg
# Pkg.activate(@__DIR__)
# using Latexify
import Base: show


const Lmime = MIME"text/latexify"
const lmime = MIME("text/latexify")

function join_matrix(io, m, delim = " & ", eol="\\\\\n")
   nrows, ncols = size(m)
   mime = MIME("text/latexify")
   for (i, row) in enumerate(eachrow(m))
       for x in row[1:end-1]
            show(io, mime, x)
            write(io, delim)
       end
       show(io, mime, row[end])
       i != nrows ? write(io, eol) : write(io, "\n")
    end
    return nothing
end

compare_precedence(a, b) = Base.operator_precedence(a) > Base.operator_precedence(b)

struct Environment{T} 
   args
end
Environment(s::Symbol, args) = Environment{Val{s}}(args)

# lalign(x::AbstractVector, y::AbstractVector) = hcat(x, y)

## Default Environments
Environment(args) = Environment{Val{:inline}}(args)
Environment(args::AbstractMatrix) = Environment{Val{:equation}}(args)
Environment(arg1::AbstractVector, arg2::AbstractVector) = Environment{Val{:align}}(hcat(arg1, arg2))



struct Operation{Head, Op}
    args
end
Operation(ex::Expr) = Operation{Val{head(ex)}, Val{op(ex)}}(args(ex))

head(::Any) = nothing
op(::Any) = nothing
args(::Any) = nothing

head(ex::Expr) = ex.head
op(ex::Expr) = head(ex) ∈ [:call, :ref] ? ex.args[1] : nothing
args(ex::Expr) = isnothing(op(ex)) ? ex.args : ex.args[2:end]

head(::Environment) = nothing
op(::Environment) = nothing
args(x::Environment) = x.args

val(::Val{T}) where T = T
val(T::DataType) = val(T())
val(x) = x

head(::Operation{Head, Op}) where {Head, Op} = val(Head)
op(::Operation{Head, Op}) where {Head, Op} = val(Op)
args(x::Operation) = x.args

######## Environments

function show(io::IO, mime::Lmime, x::Environment{Val{:align}}) 
  write(io, "\\begin{align}\n")
  join_matrix(io, args(x), " &= ")
  write(io, "\\end{align}")
end

function show(io::IO, mime::Lmime, x::Environment{Val{:inline}}) 
  write(io, "\$")
  show(io, mime, args(x))
  write(io, "\$")
end

function show(io::IO, mime::Lmime, x::Environment{Val{:equation}}) 
  write(io, "\\begin{equation}\n")
  show(io, mime, args(x))
  write(io, "\n\\end{equation}")
end

function show(io::IO, mime::Lmime, x::Environment{Val{:bracket}}) 
  write(io, "\\[")
  show(io, mime, args(x))
  write(io, "\\]")
end

######## Operations

function show(io::IO, mime::Lmime, x::Operation{Val{:call}, Val{:+}}) 
    surround = compare_precedence(get(io, :precedence, :+), :+)
    io = IOContext(io, :precedence=>:+)
    surround ? write(io, "\\left(") : nothing
    for arg in args(x)[1:end-1]
        show(io, mime, arg)
        write(io, " ++ ")
    end
    show(io, mime, args(x)[end])
    surround ? write(io, "\\right)") : nothing
end

function show(io::IO, mime::Lmime, x::Operation{Val{:ref}, T}) where T
    show(io, mime, op(x))
    write(io, "\\left[")
    for arg in args(x)[1:end-1]
        show(io, mime, arg)
        write(io, ", ")
    end
    show(io, mime, args(x)[end])
    write(io, "\\right]")
end

function show(io::IO, mime::MIME"text/latexify", x::Operation{Val{:call}, Val{:/}})
    write(io, "\\frac{")
    show(io, mime, args(x)[1])
    write(io, "}{")
    show(io, mime, args(x)[2])
    write(io, "}")
end

###### Convenience
show(io::IO, mime::Lmime, ex::Expr) = show(io, mime, Operation(ex))
show(io::IO, ::MIME"text/latexify", x) = print(io, x)


using LaTeXStrings

function latex(args...; kwargs...)
    io = IOBuffer(; append=true)
    latex(io, args...; kwargs...)
    LaTeXString(String(take!(io)))
end

function latex(io::IO, args...; env=:auto, kwargs...)
    io = IOContext(io, kwargs...)
    # envtype = env == :auto ? Environment(args...) : Environment(env, args)
    envtype = Environment(args...)
    show(io, MIME("text/latexify"), envtype)
    return nothing
end

# using SnoopCompile
# tinf = @snoopi_deep _latex([:x, 2],[:(x/y), 1/2])
# using ProfileView
# ProfileView.view(flamegraph(tinf))

@time latex([:x, 2],[:(x/y), 1/2])
latex(:(x/y))

