using Latexify
using DiffEqBiological
using ParameterizedFunctions
using Markdown
using Test


#inline
@test latexify(:(x * y); env=:inline, cdot=false) == raw"$x y$"

@test latexify(:(x * y); env=:inline, cdot=true) == raw"$x \cdot y$"

@test latexify(:(x*(y+z)*y*(z+a)*(z+b)); env=:inline, cdot=false) == 
raw"$x \left( y + z \right) y \left( z + a \right) \left( z + b \right)$"

@test latexify(:(x*(y+z)*y*(z+a)*(z+b)); env=:inline, cdot=true) == 
raw"$x \cdot \left( y + z \right) \cdot y \cdot \left( z + a \right) \cdot \left( z + b \right)$"

# raw
@test latexify(:(x * y); env=:raw, cdot=false) == raw"x y"

@test latexify(:(x * y); env=:raw, cdot=true) == raw"x \cdot y"

@test latexify(:(x * (y + z) * y * (z + a) * (z + b)); env=:raw, cdot=false) == 
raw"x \left( y + z \right) y \left( z + a \right) \left( z + b \right)"

@test latexify(:(x * (y + z) * y * (z + a) * (z + b)); env=:raw, cdot=true) == 
raw"x \cdot \left( y + z \right) \cdot y \cdot \left( z + a \right) \cdot \left( z + b \right)"

# array
@test latexify( [:(x*y), :(x*(y+z)*y*(z+a)*(z+b))]; env=:array, cdot=false) ==
raw"\begin{equation}
\left[
\begin{array}{cc}
x y & x \left( y + z \right) y \left( z + a \right) \left( z + b \right) \\
\end{array}
\right]
\end{equation}
"

@test latexify( [:(x*y), :(x*(y+z)*y*(z+a)*(z+b))]; env=:array, cdot=true) == 
raw"\begin{equation}
\left[
\begin{array}{cc}
x \cdot y & x \cdot \left( y + z \right) \cdot y \cdot \left( z + a \right) \cdot \left( z + b \right) \\
\end{array}
\right]
\end{equation}
"

# align
f = @ode_def TestAlignFeedback begin
    dx = y*c_1 - x
    dy = x^c_2 - y
end c_1 c_2

@test latexify(f; env=:align, cdot=false) == 
raw"\begin{align}
\frac{dx}{dt} =& y c_{1} - x \\
\frac{dy}{dt} =& x^{c_{2}} - y \\
\end{align}
"

@test latexify(f; env=:align, cdot=true) == 
raw"\begin{align}
\frac{dx}{dt} =& y \cdot c_{1} - x \\
\frac{dy}{dt} =& x^{c_{2}} - y \\
\end{align}
"

# reactions
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
\frac{dT}{dt} =& k_+ P_1 P_2 - k_- T \\
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
\frac{dT}{dt} =& k_+ \cdot P_1 \cdot P_2 - k_- \cdot T \\
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

# mdtable
arr = ["x*(y-1)", 1.0, 3*2, :(x-2y), :symb]

@test latexify(arr; env=:mdtable, cdot=false) == 
Markdown.md"| $x \left( y - 1 \right)$ |
| ------------------------:|
|                    $1.0$ |
|                      $6$ |
|                $x - 2 y$ |
|                   $symb$ |
"

@test latexify(arr; env=:mdtable, cdot=true) == 
Markdown.md"| $x \cdot \left( y - 1 \right)$ |
| ------------------------------:|
|                          $1.0$ |
|                            $6$ |
|                $x - 2 \cdot y$ |
|                         $symb$ |
"




