
add_brackets(ex::Expr, vars) = postwalk(x -> x in vars ? "\\left[ $(convert_subscript(x)) \\right]" : x, ex)
add_brackets(arr::AbstractArray, vars) = [add_brackets(element, vars) for element in arr]
add_brackets(s::Any, vars) = s

default_packages(s) = vcat(
                           ["amssymb", "amsmath", "unicode-math"],
                           occursin("\\ce{", s) ? ["mhchem"] : [],
                           any(x->occursin(prod(x), s), Iterators.product(["\\si", "\\SI", "\\num", "\\qty"], ["{", "range{", "list{", "product{"])) ? ["siunitx"] : [],
                          )

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

function _compile(s::LaTeXString, cmd::Cmd, ext::String;
        debug=false,
        name=tempname(),
        open=true,
        use_tectonic=false,
        kw...
    )
    use_tectonic && throw(ArgumentError("`use_tectonic` requires the `tectonic_jll` package"))
    name = abspath(name)
    mktempdir() do source_dir
        cd(source_dir) do
            _writetex(s; name="main", kw...)
            debug || (cmd = pipeline(cmd, devnull))
            try
                run(cmd)
            catch err
                isa(err, ProcessFailedException) || rethrow(err)
                isfile("$source_dir/main.log") || rethrow(LatexifyRenderError(""))
                mv("$source_dir/main.log", "$name.log"; force=true)
                rethrow(LatexifyRenderError("$name.log"))
            end
        end
        mv("$source_dir/main.$ext", "$name.$ext"; force=true)
    end
    if open
        _openfile(name; ext=ext)
    end
    return "$name.$ext"
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

# `display(MIME("application/pdf")` is generally not defined even though
# `displayable(MIME("application/pdf")` returns `true`.
#
# if callshow && displayable(MIME("application/pdf"))
#     display(MIME("application/pdf"), read("$name.pdf"))
# end
render(s::LaTeXString, ::MIME"application/pdf"; lualatex_flags=``, kw...) = _compile(s, `lualatex --interaction=nonstopmode $lualatex_flags main.tex`, "pdf"; kw...)

# `display(MIME("application/x-dvi")` is generally not defined even though
# `displayable(MIME("application/x-dvi")` returns `true`.
#
# if callshow && displayable(MIME("application/x-dvi"))
#     display(MIME("application/x-dvi"), read("$name.dvi"))
# end
render(s::LaTeXString, ::MIME"application/x-dvi"; dvilualatex_flags=``, kw...) = _compile(s,  `dvilualatex --interaction=batchmode $dvilualatex_flags main.tex`, "dvi"; kw...)

function render(s::LaTeXString, mime::MIME"image/png";
        debug=false,
        convert = :gs,
        name=tempname(),
        callshow=true,
        open=true,
        dpi=DEFAULT_DPI[],
        ghostscript_flags=`-sDEVICE=pngalpha -dTextAlphaBits=4 -r$dpi`,
        dvipng_flags=`-bg Transparent -D $dpi -T tight`,
        kw...
    )
    ext = "png"

    mktemp() do aux_name, _
        # tex -> dvi -> png is notoriously bad for fonts (not OTF support), see e.g. tex.stackexchange.com/q/537281
        # prefer tex -> pdf -> png instead
        if convert === :gs
            aux_mime = MIME("application/pdf")
            ghostscript_command = get(ENV, "GHOSTSCRIPT", Sys.iswindows() ? "gswin64c" : "gs")
            cmd = `$ghostscript_command $ghostscript_flags  -o $name.$ext $aux_name.pdf`
        elseif convert === :dvipng
            aux_mime = MIME("application/x-dvi")
            deb = debug ? [] : ["-q"]
            cmd = `dvipng $(deb...) $dvipng_flags $aux_name.dvi -o $name.$ext`
        else
            throw(ArgumentError("$convert program not understood"))
        end
        render(s, aux_mime; debug=debug, name=aux_name, open=false, kw...)
        debug || (cmd = pipeline(cmd, devnull))
        run(cmd)
    end

    if callshow && displayable(mime)
        display(mime, read("$name.$ext"))
    elseif open
        _openfile(name; ext=ext)
    end

    return nothing
end


function render(s::LaTeXString, mime::MIME"image/svg";
        debug=false,
        convert = :dvisvgm,
        name=tempname(),
        callshow=true,
        open=true,
        dvisvgm_flags=``,
        pdf2svg_flags=``,
        kw...
    )
    ext="svg"
    mktemp() do aux_name, _
        aux_mime = MIME("application/pdf")
        if convert === :dvisvgm
            verb = debug ? 7 : 0
            cmd = `dvisvgm --no-fonts --pdf -v $verb $dvisvgm_flags $aux_name.pdf -o $name.$ext`
        elseif convert === :pdf2svg
            cmd = `pdf2svg $pdf2svg_flags $aux_name.pdf $name.$ext`
        else
            throw(ArgumentError("$convert program not understood"))
        end
        render(s, aux_mime; debug=debug, name=aux_name, open=false, kw...)
        debug || (cmd = pipeline(cmd, devnull))
        run(cmd)
    end

    # `displayable(MIME("image/svg"))` returns `true` even in a textual
    # context (e.g., in the REPL), but `display(MIME("image/svg+xml"), ...)`
    # is the one normally defined.
    if callshow && displayable(mime)
        display(MIME("image/svg+xml"), read("$name.$ext"))
    elseif open
        _openfile(name; ext=ext)
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
