using Documenter
using Latexify

makedocs(
    modules = [Latexify],
    doctext = true
)

deploydocs(deps   = Deps.pip("mkdocs", "python-markdown-math"),
    repo = "github.com/korsbo/Latexify.jl.git",
    julia  = "0.6",
    osname = "osx")
# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
