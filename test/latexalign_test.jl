using Latexify
using ParameterizedFunctions
using DiffEqBiological
using Base.Test

f = @ode_def feedback begin
    dx = y/c_1 - x
    dy = x^c_2 - y
end c_1 c_2

g = @ode_def test2 begin
    dx = p_x - d_x*x - d_x_y*y*x
    dy = p_y - d_y*y
    dz = p_z
end p_x d_x d_x_y p_y d_y p_z

@test latexalign(["d$x/dt" for x in f.syms], f.funcs) == "\\begin{align}\n\\frac{dx}{dt} =& \\frac{y}{c_{1}} - x \\\\\n\\frac{dy}{dt} =& x^{c_{2}} - y \\\\\n\\end{align}\n"
@test latexalign(f) == "\\begin{align}\n\\frac{dx}{dt} =& \\frac{y}{c_{1}} - x \\\\\n\\frac{dy}{dt} =& x^{c_{2}} - y \\\\\n\\end{align}\n"
@test latexalign(f, field=:symfuncs) ==
raw"\begin{align}
\frac{dx}{dt} =&  - x + \frac{y}{c_{1}} \\
\frac{dy}{dt} =&  - y + x^{c_{2}} \\
\end{align}
"


@test latexalign([f,g]) == "\\begin{align}\n\\frac{dx}{dt}  &=  \\frac{y}{c_{1}} - x  &  \\frac{dx}{dt}  &=  p_{x} - d_{x} \\cdot x - d_{x\\_y} \\cdot y \\cdot x  &  \\\\\n\\frac{dy}{dt}  &=  x^{c_{2}} - y  &  \\frac{dy}{dt}  &=  p_{y} - d_{y} \\cdot y  &  \\\\\n  &    &  \\frac{dz}{dt}  &=  p_{z} \\cdot 1  &  \\\\\n\\end{align}\n"



@reaction_func hill2(x, v, k) = v*x^2/(k^2 + x^2)

rn = @reaction_network MyRnType begin
  hill2(y, v_x, k_x), 0 --> x
  p_y, 0 --> y
  (d_x, d_y), (x, y) --> 0
  (r_b, r_u), x ↔ y
end v_x k_x p_y d_x d_y r_b r_u

@test latexalign(rn).s ==
raw"\begin{align}
\frac{dx}{dt} =& \frac{v_{x} \cdot y^{2}}{k_{x}^{2} + y^{2}} - d_{x} \cdot x - r_{b} \cdot x + r_{u} \cdot y \\
\frac{dy}{dt} =& p_{y} - d_{y} \cdot y + r_{b} \cdot x - r_{u} \cdot y \\
\end{align}
"

@test latexalign(rn, symbolic=true) ==
raw"\begin{align}
\frac{dx}{dt} =&  - x \cdot d_{x} - x \cdot r_{b} + y \cdot r_{u} + \frac{y^{2} \cdot v_{x}}{k_{x}^{2} + y^{2}} \\
\frac{dy}{dt} =& p_{y} + x \cdot r_{b} - y \cdot d_{y} - y \cdot r_{u} \\
\end{align}
"

@test_throws MethodError latexify(rn; bad_kwarg="should error")
