using DiffEqBiological
using Latexify
using LaTeXStrings
using Base.Test

@reaction_func hill2(x, v, k) = v*x^2/(k^2 + x^2)

rn = @reaction_network MyRnType begin
  hill2(y, v_x, k_x), 0 --> x
  p_y, 0 --> y
  (d_x, d_y), (x, y) --> 0
  (r_b, r_u), x ↔ y
end v_x k_x p_y d_x d_y r_b r_u


@test latexify(rn; env=:chem) ==
raw"\begin{align}
\varnothing &\xrightarrow{\frac{v_{x} \cdot y^{2}}{k_{x}^{2} + y^{2}}} x\\
\varnothing &\xrightarrow{p_{y}} y\\
x &\xrightarrow{d_{x}} \varnothing\\
y &\xrightarrow{d_{y}} \varnothing\\
x &\xrightleftharpoons[r_{u}]{r_{b}} y\\
\end{align}
"

@test latexify(rn; env=:chem, expand=false) ==
raw"\begin{align}
\varnothing &\xrightarrow{\mathrm{hill2}\left( y, v_{x}, k_{x} \right)} x\\
\varnothing &\xrightarrow{p_{y}} y\\
x &\xrightarrow{d_{x}} \varnothing\\
y &\xrightarrow{d_{y}} \varnothing\\
x &\xrightleftharpoons[r_{u}]{r_{b}} y\\
\end{align}
"

@test md(rn; env=:chem) ==
raw"\begin{align}
\varnothing &\xrightarrow{\frac{v_{x} \cdot y^{2}}{k_{x}^{2} + y^{2}}} x\\\\
\varnothing &\xrightarrow{p_{y}} y\\\\
x &\xrightarrow{d_{x}} \varnothing\\\\
y &\xrightarrow{d_{y}} \varnothing\\\\
x &\xrightleftharpoons[r_{u}]{r_{b}} y\\\\
\end{align}
"

@test md(rn; env=:chem, starred=false) ==
raw"\begin{align}
\varnothing &\xrightarrow{\frac{v_{x} \cdot y^{2}}{k_{x}^{2} + y^{2}}} x\\\\
\varnothing &\xrightarrow{p_{y}} y\\\\
x &\xrightarrow{d_{x}} \varnothing\\\\
y &\xrightarrow{d_{y}} \varnothing\\\\
x &\xrightleftharpoons[r_{u}]{r_{b}} y\\\\
\end{align}
"
