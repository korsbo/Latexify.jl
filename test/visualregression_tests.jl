using Latexify, VisualRegressionTests
if ~is_ci()
    using Gtk
end

function latexify_VRT(filename, args...; kwargs...)
    testfun(fname) = render(latexify(args...; kwargs...), MIME"image/png"(); name=replace(fname, r".png$"=>""), transparent=false)
    @visualtest testfun joinpath("visualreferences", filename) ~is_ci() 0.01
end

latexify_VRT("simpleequation.png", :(x^2-2y_a*exp(3)∈[1,2,3]); cdot=false)
latexify_VRT("table.png", hcat([1,2,3], [4,5,6], [7;8;9]); env=:table, head=["a" "b" "c"])

struct Ket{T}
    x::T
end
@latexrecipe function f(x::Ket)
    return Expr(:latexifymerge, "\\left|", x.x, "\\right>")
end
latexify_VRT("ket.png", :($(Ket(:a)) + $(Ket(:b))))
