


add_brackets(arr::AbstractArray, vars) = [add_brackets(element, vars) for element in arr]

add_brackets(s::Any, vars) = return s

function add_brackets(ex::Expr, vars)
    ex = postwalk(x -> x in vars ? "\\left[ $(convertSubscript(x)) \\right]" : x, ex)
    return ex
end


"""
    render(::LaTeXString; debug=false, name=tempname(), command="\\Large")

Display a standalone PDF with the given input.
"""
function render(s::LaTeXString; debug=false, name=tempname(), command="\\Large")
    doc = """
    \\documentclass[varwidth=100cm]{standalone}
    \\usepackage{amssymb}
    \\usepackage{amsmath}
    \\begin{document}
    {
        $command
        $s
    }
    \\end{document}
    """
    doc = replace(doc, "\\begin{align}"=>"\\[\n\\begin{aligned}")
    doc = replace(doc, "\\end{align}"=>"\\end{aligned}\n\\]")
    open("$(name).tex", "w") do f
        write(f, doc)
    end
    cd(dirname(name)) do 
        cmd = `lualatex $(name).tex`
        debug || (cmd = pipeline(cmd, devnull))
        run(cmd)
    end
    if Sys.iswindows()
        run(`cmd /c "start $(name).pdf"`, wait=false)
    elseif Sys.islinux()
        run(`xdg-open $(name).pdf`, wait=false)
    elseif Sys.isapple()
        run(`open $(name).pdf`, wait=false)
    elseif Sys.isbsd()
        run(`xdg-open $(name).pdf`, wait=false)
    end
    return nothing
end
