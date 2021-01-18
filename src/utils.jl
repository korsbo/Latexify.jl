


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
    render(::LaTeXString[, ::MIME"mime"]; debug=false, name=tempname(), command="\\Large", open=true)

Display a standalone document with the given input. Supported MIME-type strings are
"application/pdf" (default), "application/x-dvi", "image/png" and "image/svg+xml".
"""
function render(s::LaTeXString; kwargs...)
    return render(s, MIME("application/pdf"); kwargs...)
end


function render(s::LaTeXString, ::MIME"application/pdf"; debug=false, name=tempname(), command="\\Large", open=true)
    _writetex(s; name=name, command=command)

    cd(dirname(name)) do
        cmd = `lualatex --interaction=batchmode $(name).tex`
        debug || (cmd = pipeline(cmd, devnull))
        run(cmd)
    end

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

    if open
        _openfile(name; ext="dvi")
    end

    return nothing
end


function render(s::LaTeXString, ::MIME"image/png"; debug=false, name=tempname(), command="\\Large", open=true, dpi=300)
    render(s, MIME("application/x-dvi"); debug=debug, name=name, command=command, open=false)

    cmd = `dvipng -bg Transparent -D $(dpi) -T tight -o $(name).png $(name).dvi`
    debug || (cmd = pipeline(cmd, devnull))
    run(cmd)

    if open
        _openfile(name; ext="png")
    end

    return nothing
end


function render(s::LaTeXString, ::MIME"image/svg+xml"; debug=false, name=tempname(), command="\\Large", open=true)
    render(s, MIME("application/x-dvi"); debug=debug, name=name, command=command, open=false)

    cmd = `dvisvgm -n -v 0 -o $(name).svg $(name).dvi`
    debug || (cmd = pipeline(cmd, devnull))
    run(cmd)

    if open
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
