__precompile__()
module Latexify
using Requires
using LaTeXStrings
using Base.Markdown

export latexify, latexarray, latexalign, latexraw, latexinline, latextabular, copy_to_clipboard

COPY_TO_CLIPBOARD = false
function copy_to_clipboard(x::Bool)
    global COPY_TO_CLIPBOARD = x
end

include("latexraw.jl")
include("latexoperation.jl")
include("latexify_function.jl")
include("latexarray.jl")
include("latexalign.jl")
include("latexinline.jl")
include("latextabular.jl")
include("mdtable.jl")
end
