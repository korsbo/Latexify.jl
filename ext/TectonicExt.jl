module TectonicExt
import LaTeXStrings.LaTeXString
import Latexify.render, Latexify._compile
isdefined(Base, :get_extension) ? (using tectonic_jll) : (using ..tectonic_jll)
__precompile__(false)

function render(s::LaTeXString, ::MIME"application/pdf"; use_tectonic=true, tectonic_flags="", lualatex_flags="", kw...)
    use_tectonic && return _compile(s, `$(tectonic()) --keep-logs $tectonic_flags main.tex`, "pdf"; kw...)
    return _compile(s, `lualatex --interaction=batchmode $lualatex_flags main.tex`, "pdf"; kw...)
end
end
