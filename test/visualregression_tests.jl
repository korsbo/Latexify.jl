using Latexify, VisualRegressionTests
is_ci() = parse(Bool, get(ENV, "CI", "false"))
if ~is_ci()
    using Gtk
end

function latexify_VRT(filename, args...; kwargs...)
    testfun(fname) = render(latexify(args...; kwargs...), MIME"image/png"(); name=replace(fname, r".png$"=>""), transparent=false)
    @visualtest testfun joinpath("visualreferences", filename) ~is_ci()
end

latexify_VRT("simpleequation.png", :(x^2-2y_a*exp(3)∈[1,2,3]); cdot=false)
latexify_VRT("table.png", [1;2;3;;4;5;6;;7;8;9]; env=:table, head=["a" "b" "c"])

