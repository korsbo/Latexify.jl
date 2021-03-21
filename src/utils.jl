


add_brackets(arr::AbstractArray, vars) = [add_brackets(element, vars) for element in arr]

add_brackets(s::Any, vars) = return s

function add_brackets(ex::Expr, vars)
    ex = postwalk(x -> x in vars ? "\\left[ $(convertSubscript(x)) \\right]" : x, ex)
    return ex
end


function _writetex(s::LaTeXString; name=tempname(), command="\\Large")
    doc = """
    \\documentclass[varwidth=100cm]{standalone}
    \\usepackage{amssymb}
    \\usepackage{amsmath}
    $(occursin("\\ce{", s) ? "\\usepackage{mhchem}" : "")
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
    open("$(name).tex", "w") do f
        write(f, doc)
    end

    return nothing
end


function _openfile(name; ext="pdf")
    if Sys.iswindows()
        run(`cmd /c "start $(name).$(ext)"`, wait=false)
    elseif Sys.islinux()
        run(`xdg-open $(name).$(ext)`, wait=false)
    elseif Sys.isapple()
        run(`open $(name).$(ext)`, wait=false)
    elseif Sys.isbsd()
        run(`xdg-open $(name).$(ext)`, wait=false)
    end

    return nothing
end


"""
    render(::LaTeXString[, ::MIME"mime"]; debug=false, name=tempname(), command="\\Large", callshow=true, open=true)

Display a standalone document with the given input. Supported MIME-type strings are
"application/pdf" (default), "application/x-dvi", "image/png" and "image/svg".
"""
function render(s::LaTeXString; kwargs...)
    return render(s, best_displayable(); kwargs...)
end

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
    return MIME("image/pdf")
end


function html_wrap(s::LaTeXString; scale=1.1, kwargs...)
    import_str = """
        <script>
            MathJax = {
                tex: {
                    displayMath: [['\$', '\$']]
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
function render(s::LaTeXString, mime::MIME"juliavscode/html"; kwargs...)
      display(mime, html_wrap(s; kwargs...))
end


function render(s::LaTeXString, ::MIME"application/pdf"; debug=false, name=tempname(), command="\\Large", open=true)
    _writetex(s; name=name, command=command)

    cd(dirname(name)) do
        cmd = `lualatex --interaction=batchmode $(name).tex`
        debug || (cmd = pipeline(cmd, devnull))
        run(cmd)
    end

    # `display(MIME("application/pdf")` is generally not defined even though
    # `displayable(MIME("application/pdf")` returns `true`.
    #
    # if callshow && displayable(MIME("application/pdf"))
    #     Base.open("$name.pdf") do f
    #         display(MIME("application/pdf"), read(f, String))
    #     end
    if open
        _openfile(name; ext="pdf")
    end

    return nothing
end


function render(s::LaTeXString, ::MIME"application/x-dvi"; debug=false, name=tempname(), command="\\Large", open=true)
    _writetex(s; name=name, command=command)

    cd(dirname(name)) do
        cmd = `dvilualatex --interaction=batchmode $(name).tex`
        debug || (cmd = pipeline(cmd, devnull))
        run(cmd)
    end

    # `display(MIME("application/x-dvi")` is generally not defined even though
    # `displayable(MIME("application/x-dvi")` returns `true`.
    #
    # if callshow && displayable(MIME("application/x-dvi"))
    #     Base.open("$name.dvi") do f
    #         display(MIME("application/x-dvi"), read(f, String))
    #     end
    if open
        _openfile(name; ext="dvi")
    end

    return nothing
end


function render(s::LaTeXString, ::MIME"image/png"; debug=false, name=tempname(), command="\\Large", callshow=true, open=true, dpi=300)
    render(s, MIME("application/x-dvi"); debug=debug, name=name, command=command, open=false)

    cmd = `dvipng -bg Transparent -D $(dpi) -T tight -o $(name).png $(name).dvi`
    debug || (cmd = pipeline(cmd, devnull))
    run(cmd)

    if callshow && displayable(MIME("image/png"))
        Base.open("$name.png") do f
            display(MIME("image/png"), read(f))
        end
    elseif open
        _openfile(name; ext="png")
    end

    return nothing
end


function render(s::LaTeXString, ::MIME"image/svg"; debug=false, name=tempname(), command="\\Large", callshow=true, open=true)
    render(s, MIME("application/x-dvi"); debug=debug, name=name, command=command, open=false)

    cmd = `dvisvgm -n -v 0 -o $(name).svg $(name).dvi`
    debug || (cmd = pipeline(cmd, devnull))
    run(cmd)

    # `displayable(MIME("image/svg"))` returns `true` even in a textual
    # context (e.g., in the REPL), but `display(MIME("image/svg+xml"), ...)`
    # is the one normally defined.
    if callshow && displayable(MIME("image/svg"))
        Base.open("$name.svg") do f
            display(MIME("image/svg+xml"), read(f, String))
        end
    elseif open
        _openfile(name; ext="svg")
    end

    return nothing
end


function expr_to_array(ex)
    ex.head == :typed_vcat && (ex = Expr(:vcat, ex.args[2:end]...))
    ex.head == :typed_hcat && (ex = Expr(:hcat, ex.args[2:end]...))
    ex.head == :ref && (ex = Expr(:vect, ex.args[2:end]...))
    ## If it is a matrix
    if ex.args[1] isa Expr && ex.args[1].head == :row
        return eval(ex.head)(map(y -> permutedims(y.args), ex.args)...)
    else 
        if ex.head == :hcat
            return hcat( ex.args...)
        elseif ex.head in [:vcat, :vect]
            return vcat( ex.args...)
        end
    end
end
