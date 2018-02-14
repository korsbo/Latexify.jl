using Documenter
using Latexify

makedocs(
    modules = [Latexify],
    format = :html,
    sitename = "Latexify.jl",
    pages = [
        "index.md",
        "Functions" => [
            "tutorials/latexify.md",
            "tutorials/latexinline.md",
            "tutorials/latexalign.md",
            "tutorials/latexarray.md",
            "tutorials/latextabular.md"
        ],
        "Use with other packages" => [
            "tutorials/parameterizedfunctions.md",
            "tutorials/DiffEqBiological.md"
        ],
        "tutorials/inner_workings.md"
        # "Functions" => [
        #     "functions/latexify.md",
        #     "functions/latexalign.md",
        #     "functions/latexarray.md",
        #     "functions/latexoperation.md"
        # ]
    ],
    doctest = false
)

deploydocs(
    #deps = Deps.pip("mkdocs", "python-markdown-math"),
    repo = "github.com/korsbo/Latexify.jl.git",
    julia  = "release",
    target = "build",
    osname = "linux",
    make = nothing,
    deps = nothing
    )


# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
