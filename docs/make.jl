using Documenter
using Latexify

makedocs(
    modules = [Latexify],
    format = :html,
    sitename = "Latexify.jl",
    pages = [
        "index.md",
        "Demos" => [
            "tutorials/latexify.md",
            "tutorials/latexarray.md"
        ],
        "Functions" => [
            "functions/latexify.md",
            "functions/latexalign.md",
            "functions/latexarray.md",
            "functions/latexoperation.md"
        ]
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
