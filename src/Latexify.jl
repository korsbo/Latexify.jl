module Latexify

if isdefined(Base, :Experimental) && isdefined(Base.Experimental, Symbol("@optlevel"))
    @eval Base.Experimental.@optlevel 1
end
if isdefined(Base, :Experimental) && isdefined(Base.Experimental, Symbol("@max_methods"))
    @eval Base.Experimental.@max_methods 1
end

using LaTeXStrings
using InteractiveUtils
using Markdown
using MacroTools: postwalk
import MacroTools
using Format
import Base.showerror

export latexify, md, copy_to_clipboard, auto_display, set_default, get_default,
    reset_default, @latexrecipe, render, @latexify, @latexrun, @latexdefine

## Allow some backwards compatibility until its time to deprecate.
export latexequation, latexarray, latexalign, latexraw, latexinline, latextabular, mdtable

export StyledNumberFormatter, FancyNumberFormatter

COPY_TO_CLIPBOARD = false
function copy_to_clipboard(x::Bool)
    global COPY_TO_CLIPBOARD = x
end

AUTO_DISPLAY = false
function auto_display(x::Bool)
    global AUTO_DISPLAY = x
end

const DEFAULT_DPI = Ref(300)

include("unicode2latex.jl")
include("symbol_translations.jl")
include("latexraw.jl")
include("latexoperation.jl")
include("latexarray.jl")
include("latexalign.jl")
include("latexbracket.jl")
include("latexinline.jl")
include("latexequation.jl")
include("latextabular.jl")
include("default_kwargs.jl")
include("recipes.jl")
include("macros.jl")

include("mdtable.jl")
include("mdtext.jl")
include("md.jl")

include("utils.jl")

include("numberformatters.jl")

include("latexify_function.jl")
include("type_recipes.jl")

### Add support for additional packages without adding them as dependencies.
### Requires on <1.9 and weakdeps/extensions on >=1.9
if !isdefined(Base, :get_extension)
using Requires
end

@static if !isdefined(Base, :get_extension)
function __init__()
    @require SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8" begin
        include("../ext/SymEngineExt.jl")
    end
    @require DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0" begin
        include("../ext/DataFramesExt.jl")
    end
end
end

macro generate_test(expr)
    return :(clipboard("@test $($(string(expr))) == replace(\nraw\"$($(esc(expr)))\", \"\\r\\n\"=>\"\\n\")\n"))
end

"""
    @append_latexify_test!(fname, expr)

Generate a Latexify test and append it to the file `fname`.

The expression `expr` should return a string when evaluated.

Example use:
```
Latexify.@append_latexify_test!("./tests/latexify_tests.jl", latexify(:(x/y)))
```

The macro returns the output of the expression and can often be rendered
for a visual check that the test itself is ok.
```
Latexify.@append_latexify_test!("./tests/latexify_tests.jl", latexify(:(x/y))) |> render
```
"""
macro append_latexify_test!(fname, expr)
    fname = esc(fname)
    return :(
    str = "@test $($(string(expr))) == replace(\nraw\"$($(esc(expr)))\", \"\\r\\n\"=>\"\\n\")\n\n";
    open($fname, "a") do f
        write(f,str)
    end;
    $(esc(expr))
    )
end

"""
    @append_test!(fname, expr)

Both execute and append code to a test file.

The code can be either a normal expression or a string.
Example use:
```
Latexify.@append_test A = [1 2; 3 4]
```

Useful for adding code that generates objects to be used in latexify tests.
"""
macro append_test!(fname, str)
    fname = esc(fname)
    returnobj = str isa String ? Meta.parse(str) : str
    printobj = str isa String ? str : string(MacroTools.striplines(str))
    return :(
    open($fname, "a") do f
        write(f, $(esc(printobj)))
        write(f, "\n\n")
    end;
    $(esc(returnobj))
    )
end

end
