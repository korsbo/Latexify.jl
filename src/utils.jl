
add_brackets(ex::Expr, vars) = postwalk(x -> x in vars ? "\\left[ $(convert_subscript(x)) \\right]" : x, ex)
add_brackets(arr::AbstractArray, vars) = [add_brackets(element, vars) for element in arr]
add_brackets(s::Any, vars) = s

default_packages(s) = vcat(["amssymb", "amsmath", "unicode-math"], occursin("\\ce{", s) ? ["mhchem"] : [])

function _writetex(s::LaTeXString;
        name=tempname(),
        command="\\Large",
        documentclass=("standalone", "varwidth=true"),
        packages=default_packages(s),
        preamble=""
    )
    doc = """
    \\documentclass$(_packagename(documentclass))
    """ * prod(map(p -> "\\usepackage$(_packagename(p))\n", packages)) * preamble * """
    \\begin{document}
    {
        $command
        $s
    }
    \\end{document}
    """
    doc = replace(doc, "\\begin{align}"=>"\\[\n\\begin{aligned}")
    doc = replace(doc, "\\end{align}"=>"\\end{aligned}\n\\]")
    doc = replace(doc, "\\require{mhchem}\n"=>"")
    texfile = name * ".tex"
    write(texfile, doc)
    texfile
end


function _openfile(name; ext="pdf")
    if Sys.iswindows()
        run(`cmd /c "start $name.$ext"`, wait=false)
    elseif Sys.islinux()
        run(`xdg-open $name.$ext`, wait=false)
    elseif Sys.isapple()
        run(`open $name.$ext`, wait=false)
    elseif Sys.isbsd()
        run(`xdg-open $name.$ext`, wait=false)
    end

    return nothing
end


"""
    render(::LaTeXString[, ::MIME"mime"]; debug=false, name=tempname(), command="\\Large", callshow=true, open=true)

Display a standalone document with the given input. Supported MIME-type strings are
"application/pdf" (default), "application/x-dvi", "image/png" and "image/svg".
"""
render(s::LaTeXString; kwargs...) = render(s, best_displayable(); kwargs...)

function best_displayable()
    priority_list = [
        MIME("juliavscode/html"),
        MIME("application/pdf"),
        MIME("application/x-dvi"),
        MIME("image/svg"),
        MIME("image/png"),
    ]
    for mime_type in priority_list
        displayable(mime_type) && return mime_type
    end
    return MIME("application/pdf")
end


function html_wrap(s::LaTeXString; scale=1.1, kwargs...)
    import_str = """
        <script>
            MathJax = {
                tex: {
                    displayMath: [['\$', '\$'], ['\\\\[', '\\\\]']]
                },
                chtml: {
                    scale: $scale
                },
                svg: {
                    scale: $scale
                }
            };
        </script>
        <script src="/js/mathjax/tex-chtml.js" id="MathJax-script" async></script>
        <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
        <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
        """
    return import_str * s.s
end

# render(s::LaTeXString, mime::MIME"juliavscode/html"; kwargs...) = render(stdout, mime; kwargs...)
render(s::LaTeXString, mime::MIME"juliavscode/html"; kwargs...) = display(mime, html_wrap(s; kwargs...))

function render(s::LaTeXString, ::MIME"application/pdf";
        debug=false,
        name=tempname(),
        open=true,
        kw...
    )
    _writetex(s; name=name, kw...)

    cd(dirname(name)) do
        cmd = `lualatex --interaction=batchmode $name.tex`
        debug || (cmd = pipeline(cmd, devnull))
        run(cmd)
    end

    # `display(MIME("application/pdf")` is generally not defined even though
    # `displayable(MIME("application/pdf")` returns `true`.
    #
    # if callshow && displayable(MIME("application/pdf"))
    #     display(MIME("application/pdf"), read("$name.pdf"))
    # end
    if open
        _openfile(name; ext="pdf")
    end

    return nothing
end


function render(s::LaTeXString, ::MIME"application/x-dvi";
        debug=false,
        name=tempname(),
        open=true,
        kw...
    )
    _writetex(s; name=name, kw...)

    cd(dirname(name)) do
        cmd = `dvilualatex --interaction=batchmode $name.tex`
        debug || (cmd = pipeline(cmd, devnull))
        run(cmd)
    end

    # `display(MIME("application/x-dvi")` is generally not defined even though
    # `displayable(MIME("application/x-dvi")` returns `true`.
    #
    # if callshow && displayable(MIME("application/x-dvi"))
    #     display(MIME("application/x-dvi"), read("$name.dvi"))
    # end
    if open
        _openfile(name; ext="dvi")
    end

    return nothing
end

function render(s::LaTeXString, ::MIME"image/png";
        debug=false,
        convert = :gs,
        name=tempname(),
        callshow=true,
        open=true,
        dpi=DEFAULT_DPI[],
        kw...
    )
    
    # tex -> dvi -> png is notoriously bad for fonts (not OTF support), see e.g. tex.stackexchange.com/q/537281
    # prefer tex -> pdf -> png instead
    if convert === :gs
        mime = MIME("application/pdf")
        cmd = `gs -sDEVICE=pngalpha -dTextAlphaBits=4 -r$dpi -o $name.png $name.pdf`
    elseif convert === :dvipng
        mime = MIME("application/x-dvi")
        deb = debug ? [] : ["-q"]
        cmd = `dvipng $(deb...) -bg Transparent -D $dpi -T tight $name.dvi -o $name.png`
    else
        error("$convert program not understood")
    end
    render(s, mime; debug=debug, name=name, open=false, kw...)
    debug || (cmd = pipeline(cmd, devnull))
    run(cmd)

    if callshow && displayable(MIME("image/png"))
        display(MIME("image/png"), read("$name.png"))
    elseif open
        _openfile(name; ext="png")
    end

    return nothing
end


function render(s::LaTeXString, ::MIME"image/svg";
        debug=false,
        convert = :dvisvgm,
        name=tempname(),
        callshow=true,
        open=true,
        kw...
    )
    if convert === :dvisvgm
        verb = debug ? 7 : 0
        cmd = `dvisvgm --no-fonts --pdf -v $verb $name.pdf -o $name.svg`
    elseif convert === :pdf2svg
        cmd = `pdf2svg $name.pdf $name.svg`
    else
        error("$convert program not understood")
    end
    render(s, MIME("application/pdf"); debug=debug, name=name, open=false, kw...)
    debug || (cmd = pipeline(cmd, devnull))
    run(cmd)

    # `displayable(MIME("image/svg"))` returns `true` even in a textual
    # context (e.g., in the REPL), but `display(MIME("image/svg+xml"), ...)`
    # is the one normally defined.
    if callshow && displayable(MIME("image/svg"))
        display(MIME("image/svg+xml"), read("$name.svg"))
    elseif open
        _openfile(name; ext="svg")
    end

    return nothing
end

safereduce(f, args) = length(args) == 1 ? f(args[1]) : reduce(f, args)

function expr_to_array(ex)
    ex.head === :typed_vcat && (ex = Expr(:vcat, ex.args[2:end]...))
    ex.head === :typed_hcat && (ex = Expr(:hcat, ex.args[2:end]...))
    ex.head === :ref && (ex = Expr(:vect, ex.args[2:end]...))
    ## If it is a matrix
    if Meta.isexpr(ex.args[1], :row)
        return eval(ex.head)(map(y -> permutedims(y.args), ex.args)...)
    else
        if ex.head == :hcat
            return safereduce(hcat, ex.args)
        elseif ex.head in (:vcat, :vect)
            return safereduce(vcat, ex.args)
        end
    end
end

_packagename(x::AbstractString) = "{$x}"
_packagename(x::Tuple) = "[$(join(x[2:end], ", "))]{$(first(x))}"
