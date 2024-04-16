using Documenter
using Latexify
using LaTeXStrings

Base.show(io::IO, ::MIME"text/html", l::LaTeXString) = l.s
makedocs(
    modules = [Latexify],
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true", mathengine = MathJax3()),
    sitename = "Latexify.jl",
    pages = [
        "index.md",
        # "Functions" => [
        #     "tutorials/latexify.md",
        #     "tutorials/latexinline.md",
        #     "tutorials/latexalign.md",
        #     "tutorials/latexarray.md",
        #     "tutorials/latextabular.md"
        # ],
        "tutorials/recipes.md",
        "Use with other packages" => [
            "tutorials/parameterizedfunctions.md",
            "tutorials/DiffEqBiological.md"
        ],
        "tutorials/notebooks.md",
        "arguments.md",
        "tutorials/inner_workings.md",
    ],
    doctest = false,
    checkdocs = :exports,
    warnonly = :missing_docs
)

deploydocs(
    #deps = Deps.pip("mkdocs", "python-markdown-math"),
    repo = "github.com/korsbo/Latexify.jl.git",
    target = "build",
    # make = nothing,
    # deps = nothing,
    )


# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
