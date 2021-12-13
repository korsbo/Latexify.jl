
struct TracedIO{T} <: IO
  trace::Vector{Function}
  io::T
end
Base.write(x::TracedIO, s::String; kwargs...) = Base.write(x.io, s; kwargs...)

struct TracedResult{T}
  trace::Vector{Function}
  str::T
end

function Base.show(io::IO, tio::TracedResult)
  write(io, "Latexify TracedResult\n")
  write(io, "\nwith call trace:\n")
  write(io, join(string.(typeof.(tio.trace)), "\n"))
  write(io, "\n\nand result\n")
  show(io, tio.str)
end