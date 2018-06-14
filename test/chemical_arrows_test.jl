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
\require{mhchem}
\ce{ \varnothing &->[\frac{v_{x} \cdot y^{2}}{k_{x}^{2} + y^{2}}] x}\\
\ce{ \varnothing &->[p_{y}] y}\\
\ce{ x &->[d_{x}] \varnothing}\\
\ce{ y &->[d_{y}] \varnothing}\\
\ce{ x &<=>[{r_{b}}][{r_{u}}] y}\\
\end{align}
"

@test latexify(rn; env=:chem, expand=false) ==
raw"\begin{align}
\require{mhchem}
\ce{ \varnothing &->[\mathrm{hill2}\left( y, v_{x}, k_{x} \right)] x}\\
\ce{ \varnothing &->[p_{y}] y}\\
\ce{ x &->[d_{x}] \varnothing}\\
\ce{ y &->[d_{y}] \varnothing}\\
\ce{ x &<=>[{r_{b}}][{r_{u}}] y}\\
\end{align}
"

@test md(rn; env=:chem) ==
raw"\begin{align}
\require{mhchem}
\ce{ \varnothing &->[\frac{v_{x} \cdot y^{2}}{k_{x}^{2} + y^{2}}] x}\\\\
\ce{ \varnothing &->[p_{y}] y}\\\\
\ce{ x &->[d_{x}] \varnothing}\\\\
\ce{ y &->[d_{y}] \varnothing}\\\\
\ce{ x &<=>[{r_{b}}][{r_{u}}] y}\\\\
\end{align}
"

@test md(rn; env=:chem, starred=true) ==
raw"\begin{align*}
\require{mhchem}
\ce{ \varnothing &->[\frac{v_{x} \cdot y^{2}}{k_{x}^{2} + y^{2}}] x}\\\\
\ce{ \varnothing &->[p_{y}] y}\\\\
\ce{ x &->[d_{x}] \varnothing}\\\\
\ce{ y &->[d_{y}] \varnothing}\\\\
\ce{ x &<=>[{r_{b}}][{r_{u}}] y}\\\\
\end{align*}
"

ode = @reaction_network InducedDegradation begin
    (d_F, d_Ff, d_R), (F, Ff, R) --> 0 # degradations
    (p_F, Ff), 0 --> (F, R)  # productions
    (r_b * i, r_u), F ↔ Ff # bindin/unbinding
end  i p_F d_F r_b r_u d_Ff d_R

@test md(ode; env=:chem) ==
raw"\begin{align}
\require{mhchem}
\ce{ F &->[d_{F}] \varnothing}\\\\
\ce{ Ff &->[d_{Ff}] \varnothing}\\\\
\ce{ R &->[d_{R}] \varnothing}\\\\
\ce{ \varnothing &->[p_{F}] F}\\\\
\ce{ \varnothing &->[Ff] R}\\\\
\ce{ F &<=>[{r_{b} \cdot i}][{r_{u}}] Ff}\\\\
\end{align}
"
