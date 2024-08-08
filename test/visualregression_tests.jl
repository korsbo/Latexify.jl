using Latexify, VisualRegressionTests
if isinteractive()
    using Gtk
end

function latexify_VRT(filename, args...; kwargs...)
    testfun(fname) = render(latexify(args...; kwargs...), MIME"image/png"(); name=replace(fname, r".png$"=>""), transparent=false)
    @visualtest testfun joinpath("visualreferences", filename) isinteractive()
end

latexify_VRT("simpleequation.png", :(x^2-2y_a*exp(3)∈[1,2,3]); cdot=false)

