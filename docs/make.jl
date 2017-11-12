using Documenter
using Latexify

makedocs(
    modules = [Latexify],
    format = :html,
    sitename = "Latexify.jl",
    doctest = false
)

deploydocs(
    deps = Deps.pip("mkdocs", "python-markdown-math"),
    repo = "github.com/korsbo/Latexify.jl.git",
    julia  = "0.6",
    target = "build",
    osname = "linux"
    )


# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
