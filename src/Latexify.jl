module Latexify
using Requires
using LaTeXStrings
using InteractiveUtils
using Markdown
using MacroTools: postwalk
using Printf
using Formatting

export latexify, md, copy_to_clipboard, auto_display, set_default, get_default,
    reset_default, @latexrecipe, render, @latexify, @latexrun

## Allow some backwards compatibility until its time to deprecate.
export latexarray, latexalign, latexraw, latexinline, latextabular, mdtable

export StyledNumberFormatter, FancyNumberFormatter

COPY_TO_CLIPBOARD = false
function copy_to_clipboard(x::Bool)
    global COPY_TO_CLIPBOARD = x
end

AUTO_DISPLAY = false
function auto_display(x::Bool)
    global AUTO_DISPLAY = x
end

include("unicode2latex.jl")
include("function2latex.jl")
include("latexraw.jl")
include("latexoperation.jl")
include("latexify_function.jl")
include("latexarray.jl")
include("latexalign.jl")
include("latexinline.jl")
include("latexequation.jl")
include("latextabular.jl")
include("default_kwargs.jl")
include("recipes.jl")
include("macros.jl")

include("md.jl")
include("mdtable.jl")
include("mdtext.jl")

include("utils.jl")

include("numberformatters.jl")


### Add support for additional packages without adding them as dependencies.
function __init__()
    @require DiffEqBase = "2b5f629d-d688-5b77-993f-72d75c75574e" begin
        include("plugins/ParameterizedFunctions.jl")
    end
    @require ModelingToolkit = "961ee093-0014-501f-94e3-6117800e7a78" begin
        include("plugins/DiffEqBiological.jl")
    end
    @require SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8" begin
        include("plugins/SymEngine.jl")
    end
    @require Missings = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28" begin
        include("plugins/Missings.jl")
    end
    @require DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0" begin
        include("plugins/DataFrames.jl")
    end
end

macro generate_test(expr)
    return :(clipboard("\n@test $($(string(expr))) == \nraw\"$($(esc(expr)))\"\n\n"))
end

end
