# Generate the assets (pngs for README)
using Latexify, LaTeXStrings, ParameterizedFunctions, Catalyst

struct Ket{T}
    x::T
end
@latexrecipe function f(x::Ket)
    return Expr(:latexifymerge, "\\left|", x.x, "\\right>")
end

things = [
          "demo_fraction" => latexify(:(x / (y + x)^2)),
          "demo_matrix" => latexify(["x/y" 3//7 2+3im; 1 :P_x :(gamma(3))]; env=:inline),
          "demo_ket" => latexify(:($(Ket(:a)) + $(Ket(:b)))),
          "ode_positive_feedback" => latexify(@ode_def positiveFeedback begin
                                                  dx = v * y^n / (k^n + y^n) - x
                                                  dy = x / (k_2 + x) - y
                                              end v n k k_2),
          "demo_rn" => latexify(@reaction_network demoNetwork begin
                               (r_bind, r_unbind), A + B ↔ C
                               Hill(C, v, k, n), 0 --> X
                               d_x, X --> 0
                           end; form=:ode),
          "demo_rn_arrow" => latexify(@reaction_network demoNetwork begin
                                     (r_bind, r_unbind), A + B ↔ C
                                     Hill(C, v, k, n), 0 --> X
                                     d_x, X --> 0
                                 end),
         ]

cd("$(pkgdir(Latexify))/assets") do
    for (name, s) in things
        println(name)
        render(s, MIME"image/png"(); name=name, debug=false, callshow=false, open=false, packages=["mhchem", "amssymb"])
        run(`convert $name.png -flatten $name.png`)
    end
end
