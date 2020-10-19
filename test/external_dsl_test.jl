using Test
using ParameterizedFunctions
using DiffEqBiological

# align
f = @ode_def TestAlignFeedback2 begin
    dx = y*c_1 - x
    dy = x^c_2 - y
end c_1 c_2

@test latexify(f; env=:align, cdot=false) == 
raw"\begin{align}
\frac{dx}{dt} =& y c_{1} - x \\
\frac{dy}{dt} =& x^{c_{2}} - y
\end{align}
"

@test latexify(f; env=:align, cdot=true) == 
raw"\begin{align}
\frac{dx}{dt} =& y \cdot c_{1} - x \\
\frac{dy}{dt} =& x^{c_{2}} - y
\end{align}
"



rn = @reaction_network begin
    hillr(D₂,α,K,n), ∅ --> m₁
    hillr(D₁,α,K,n), ∅ --> m₂
    (δ,γ), m₁ ↔ ∅
    (δ,γ), m₂ ↔ ∅
    β, m₁ --> m₁ + P₁
    β, m₂ --> m₂ + P₂
    μ, P₁ --> ∅
    μ, P₂ --> ∅
    (k₊,k₋), 2P₁ ↔ D₁ 
    (k₊,k₋), 2P₂ ↔ D₂
    (k₊,k₋), P₁+P₂ ↔ T
end α K n δ γ β μ k₊ k₋;

@test latexify(rn; cdot=false) == 
raw"\begin{align}
\frac{dm_1}{dt} =& \frac{\alpha K^{n}}{K^{n} + D_2^{n}} - \delta m_1 + \gamma \\
\frac{dm_2}{dt} =& \frac{\alpha K^{n}}{K^{n} + D_1^{n}} - \delta m_2 + \gamma \\
\frac{dP_1}{dt} =& \beta m_1 - \mu P_1 -2 k_+ \frac{P_1^{2}}{2} + 2 k_- D_1 - k_+ P_1 P_2 + k_- T \\
\frac{dP_2}{dt} =& \beta m_2 - \mu P_2 -2 k_+ \frac{P_2^{2}}{2} + 2 k_- D_2 - k_+ P_1 P_2 + k_- T \\
\frac{dD_1}{dt} =& k_+ \frac{P_1^{2}}{2} - k_- D_1 \\
\frac{dD_2}{dt} =& k_+ \frac{P_2^{2}}{2} - k_- D_2 \\
\frac{dT}{dt} =& k_+ P_1 P_2 - k_- T
\end{align}
"

@test latexify(rn; cdot=true) == 
raw"\begin{align}
\frac{dm_1}{dt} =& \frac{\alpha \cdot K^{n}}{K^{n} + D_2^{n}} - \delta \cdot m_1 + \gamma \\
\frac{dm_2}{dt} =& \frac{\alpha \cdot K^{n}}{K^{n} + D_1^{n}} - \delta \cdot m_2 + \gamma \\
\frac{dP_1}{dt} =& \beta \cdot m_1 - \mu \cdot P_1 -2 \cdot k_+ \cdot \frac{P_1^{2}}{2} + 2 \cdot k_- \cdot D_1 - k_+ \cdot P_1 \cdot P_2 + k_- \cdot T \\
\frac{dP_2}{dt} =& \beta \cdot m_2 - \mu \cdot P_2 -2 \cdot k_+ \cdot \frac{P_2^{2}}{2} + 2 \cdot k_- \cdot D_2 - k_+ \cdot P_1 \cdot P_2 + k_- \cdot T \\
\frac{dD_1}{dt} =& k_+ \cdot \frac{P_1^{2}}{2} - k_- \cdot D_1 \\
\frac{dD_2}{dt} =& k_+ \cdot \frac{P_2^{2}}{2} - k_- \cdot D_2 \\
\frac{dT}{dt} =& k_+ \cdot P_1 \cdot P_2 - k_- \cdot T
\end{align}
"

@test latexify(rn; env=:chemical, cdot=false) == 
raw"\begin{align}
\require{mhchem}
\ce{ \varnothing &->[\frac{\alpha K^{n}}{K^{n} + D_2^{n}}] m_{1}}\\
\ce{ \varnothing &->[\frac{\alpha K^{n}}{K^{n} + D_1^{n}}] m_{2}}\\
\ce{ m_{1} &<=>[\delta][\gamma] \varnothing}\\
\ce{ m_{2} &<=>[\delta][\gamma] \varnothing}\\
\ce{ m_{1} &->[\beta] m_{1} + P_{1}}\\
\ce{ m_{2} &->[\beta] m_{2} + P_{2}}\\
\ce{ P_{1} &->[\mu] \varnothing}\\
\ce{ P_{2} &->[\mu] \varnothing}\\
\ce{ 2 P_1 &<=>[k_{+}][k_{-}] D_{1}}\\
\ce{ 2 P_2 &<=>[k_{+}][k_{-}] D_{2}}\\
\ce{ P_{1} + P_{2} &<=>[k_{+}][k_{-}] T}
\end{align}
"

@test latexify(rn; env=:chemical, cdot=true) == 
raw"\begin{align}
\require{mhchem}
\ce{ \varnothing &->[\frac{\alpha \cdot K^{n}}{K^{n} + D_2^{n}}] m_{1}}\\
\ce{ \varnothing &->[\frac{\alpha \cdot K^{n}}{K^{n} + D_1^{n}}] m_{2}}\\
\ce{ m_{1} &<=>[\delta][\gamma] \varnothing}\\
\ce{ m_{2} &<=>[\delta][\gamma] \varnothing}\\
\ce{ m_{1} &->[\beta] m_{1} + P_{1}}\\
\ce{ m_{2} &->[\beta] m_{2} + P_{2}}\\
\ce{ P_{1} &->[\mu] \varnothing}\\
\ce{ P_{2} &->[\mu] \varnothing}\\
\ce{ 2 \cdot P_1 &<=>[k_{+}][k_{-}] D_{1}}\\
\ce{ 2 \cdot P_2 &<=>[k_{+}][k_{-}] D_{2}}\\
\ce{ P_{1} + P_{2} &<=>[k_{+}][k_{-}] T}
\end{align}
"

# tabular
@test latexify(rn.symjac; env=:tabular, cdot=false) == 
raw"\begin{tabular}{ccccccc}
$ - \delta$ & $0$ & $0$ & $0$ & $0$ & $\frac{ - K^{n} n \alpha D_2^{-1 + n}}{\left( K^{n} + D_2^{n} \right)^{2}}$ & $0$\\
$0$ & $ - \delta$ & $0$ & $0$ & $\frac{ - K^{n} n \alpha D_1^{-1 + n}}{\left( K^{n} + D_1^{n} \right)^{2}}$ & $0$ & $0$\\
$\beta$ & $0$ & $ - \mu - 2 k_+ P_1 - k_+ P_2$ & $ - k_+ P_1$ & $2 k_-$ & $0$ & $k_{-}$\\
$0$ & $\beta$ & $ - k_+ P_2$ & $ - \mu - k_+ P_1 - 2 k_+ P_2$ & $0$ & $2 k_-$ & $k_{-}$\\
$0$ & $0$ & $k_+ P_1$ & $0$ & $ - k_-$ & $0$ & $0$\\
$0$ & $0$ & $0$ & $k_+ P_2$ & $0$ & $ - k_-$ & $0$\\
$0$ & $0$ & $k_+ P_2$ & $k_+ P_1$ & $0$ & $0$ & $ - k_-$\\
\end{tabular}
"

@test latexify(rn.symjac; env=:tabular, cdot=true) == 
raw"\begin{tabular}{ccccccc}
$ - \delta$ & $0$ & $0$ & $0$ & $0$ & $\frac{ - K^{n} \cdot n \cdot \alpha \cdot D_2^{-1 + n}}{\left( K^{n} + D_2^{n} \right)^{2}}$ & $0$\\
$0$ & $ - \delta$ & $0$ & $0$ & $\frac{ - K^{n} \cdot n \cdot \alpha \cdot D_1^{-1 + n}}{\left( K^{n} + D_1^{n} \right)^{2}}$ & $0$ & $0$\\
$\beta$ & $0$ & $ - \mu - 2 \cdot k_+ \cdot P_1 - k_+ \cdot P_2$ & $ - k_+ \cdot P_1$ & $2 \cdot k_-$ & $0$ & $k_{-}$\\
$0$ & $\beta$ & $ - k_+ \cdot P_2$ & $ - \mu - k_+ \cdot P_1 - 2 \cdot k_+ \cdot P_2$ & $0$ & $2 \cdot k_-$ & $k_{-}$\\
$0$ & $0$ & $k_+ \cdot P_1$ & $0$ & $ - k_-$ & $0$ & $0$\\
$0$ & $0$ & $0$ & $k_+ \cdot P_2$ & $0$ & $ - k_-$ & $0$\\
$0$ & $0$ & $k_+ \cdot P_2$ & $k_+ \cdot P_1$ & $0$ & $0$ & $ - k_-$\\
\end{tabular}
"


f = @ode_def feedback begin
    dx = y/c_1 - x
    dy = x^c_2 - y
    end c_1 c_2

@test latexify(f; starred=true) ==
raw"\begin{align*}
\frac{dx}{dt} =& \frac{y}{c_{1}} - x \\
\frac{dy}{dt} =& x^{c_{2}} - y
\end{align*}
"


f = @ode_def TestRaw begin
    dx = y/c_1 - x
    dy = x^c_2 - y
end c_1 c_2
@test latexraw(f) == ["\\frac{dx}{dt} = \\frac{y}{c_{1}} - x", "\\frac{dy}{dt} = x^{c_{2}} - y"]


#==============================================================================#
#================================  Test align  ================================# 
#==============================================================================#

f = @ode_def TestAlignFeedback begin
    dx = y/c_1 - x
    dy = x^c_2 - y
end c_1 c_2

g = @ode_def TestAlign2 begin
    dx = p_x - d_x*x - d_x_y*y*x
    dy = p_y - d_y*y
    dz = p_z
end p_x d_x d_x_y p_y d_y p_z


@test latexify(f) == 
raw"\begin{align}
\frac{dx}{dt} =& \frac{y}{c_{1}} - x \\
\frac{dy}{dt} =& x^{c_{2}} - y
\end{align}
"

@test latexify(f; rows=1) == 
raw"\begin{align}
\frac{dx}{dt} =& \frac{y}{c_{1}} - x
\end{align}
"


@test latexify(f; env=:align, field=:symjac) == 
raw"\begin{align}
\frac{dx}{dt} =& -1 \cdot 1 =& c_{1}^{-1} \\
\frac{dy}{dt} =& x^{-1 + c_{2}} \cdot c_{2} =& -1 \cdot 1
\end{align}
"

@test latexalign(["d$(x)/dt" for x = f.syms], f.funcs) == 
raw"\begin{align}
\frac{dx}{dt} =& \frac{y}{c_{1}} - x \\
\frac{dy}{dt} =& x^{c_{2}} - y
\end{align}
"

@test latexalign([f,g]) == "\\begin{align}\n\\frac{dx}{dt}  &=  \\frac{y}{c_{1}} - x  &  \\frac{dx}{dt}  &=  p_{x} - d_{x} \\cdot x - d_{x\\_y} \\cdot y \\cdot x  &  \\\\\n\\frac{dy}{dt}  &=  x^{c_{2}} - y  &  \\frac{dy}{dt}  &=  p_{y} - d_{y} \\cdot y  &  \\\\\n  &    &  \\frac{dz}{dt}  &=  p_{z} \\cdot 1  & \n\\end{align}\n"


@reaction_func hill2(x, v, k) = v*x^2/(k^2 + x^2)

rn = @reaction_network TestAlignMyRnType begin
  hill2(y, v_x, k_x), 0 --> x
  p_y, 0 --> y
  (d_x, d_y), (x, y) --> 0
  (r_b, r_u), x ↔ y
end v_x k_x p_y d_x d_y r_b r_u


@test latexalign(rn; clean=true).s ==
raw"\begin{align}
\frac{dx}{dt} =& \frac{v_{x} \cdot y^{2}}{k_{x}^{2} + y^{2}} - d_{x} \cdot x - r_{b} \cdot x + r_{u} \cdot y \\
\frac{dy}{dt} =& p_{y} - d_{y} \cdot y + r_{b} \cdot x - r_{u} \cdot y
\end{align}
"

