using Latexify
using LaTeXStrings, tectonic_jll, Ghostscript_jll
using Test

render(L"x^2", MIME("image/png"))