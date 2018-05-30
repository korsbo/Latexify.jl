__precompile__()
module Latexify
using Requires
using LaTeXStrings
using Base.Markdown
using MacroTools: postwalk

export latexify, md, copy_to_clipboard, auto_display

## Allow some backwards compatibility until its time to deprecate.
export latexarray, latexalign, latexraw, latexinline, latextabular, mdtable

COPY_TO_CLIPBOARD = false
function copy_to_clipboard(x::Bool)
    global COPY_TO_CLIPBOARD = x
end

AUTO_DISPLAY = false
function auto_display(x::Bool)
    global AUTO_DISPLAY = x
end

include("latexraw.jl")
include("latexoperation.jl")
include("latexify_function.jl")
include("latexarray.jl")
include("latexalign.jl")
include("latexinline.jl")
include("latextabular.jl")

include("md.jl")
include("mdtable.jl")
include("mdtext.jl")
end
