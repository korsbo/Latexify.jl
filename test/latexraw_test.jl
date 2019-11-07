
using Latexify
using ParameterizedFunctions
using Test
using Markdown

str = "2*x^2 - y/c_2"
ex = :(2*x^2 - y/c_2)

desired_output = "2 \\cdot x^{2} - \\frac{y}{c_{2}}"

@test latexraw(str) == latexraw(ex)
@test latexraw(ex) == desired_output

array_test = [ex, str]
@test all(latexraw(array_test) .== desired_output)

@test latexraw(:y_c_a) == "y_{c\\_a}"
@test latexraw(1.0) == "1.0"
@test latexraw(1.00) == "1.0"
@test latexraw(1) == "1"
@test latexraw(:(log10(x))) == "\\log_{10}\\left( x \\right)"
@test latexraw(:(sin(x))) ==  "\\sin\\left( x \\right)"
@test latexraw(:(sin(x)^2)) ==  "\\sin^{2}\\left( x \\right)"
@test latexraw(:(asin(x))) ==  "\\arcsin\\left( x \\right)"
@test latexraw(:(asinh(x))) ==  "\\mathrm{arcsinh}\\left( x \\right)"
@test latexraw(:(sinc(x))) ==  "\\mathrm{sinc}\\left( x \\right)"
@test latexraw(:(acos(x))) ==  "\\arccos\\left( x \\right)"
@test latexraw(:(acosh(x))) ==  "\\mathrm{arccosh}\\left( x \\right)"
@test latexraw(:(cosc(x))) ==  "\\mathrm{cosc}\\left( x \\right)"
@test latexraw(:(atan(x))) ==  "\\arctan\\left( x \\right)"
@test latexraw(:(atan2(x))) ==  "\\arctan\\left( x \\right)"
@test latexraw(:(atanh(x))) ==  "\\mathrm{arctanh}\\left( x \\right)"
@test latexraw(:(acot(x))) ==  "\\mathrm{arccot}\\left( x \\right)"
@test latexraw(:(acoth(x))) ==  "\\mathrm{arccoth}\\left( x \\right)"
@test latexraw(:(asec(x))) ==  "\\mathrm{arcsec}\\left( x \\right)"
@test latexraw(:(sech(x))) ==  "\\mathrm{sech}\\left( x \\right)"
@test latexraw(:(asech(x))) ==  "\\mathrm{arcsech}\\left( x \\right)"
@test latexraw(:(acsc(x))) ==  "\\mathrm{arccsc}\\left( x \\right)"
@test latexraw(:(csch(x))) ==  "\\mathrm{csch}\\left( x \\right)"
@test latexraw(:(acsch(x))) ==  "\\mathrm{arccsch}\\left( x \\right)"
@test latexraw(:(x ± y)) == "x \\pm y"
@test latexraw(:(f(x))) ==  "\\mathrm{f}\\left( x \\right)"
@test latexraw("x = 4*y") == "x = 4 \\cdot y"
@test latexraw(:(sqrt(x))) == "\\sqrt{x}"
@test latexraw(complex(1,-1)) == "1-1\\textit{i}"
@test latexraw(1//2) == "\\frac{1}{2}"
@test latexraw(Missing()) == "\\textrm{NA}"
@test latexraw("x[2]") == raw"\mathrm{x}\left[2\right]"
@test latexraw("x[2, 3]") == raw"\mathrm{x}\left[2, 3\right]"
@test latexraw("α") == raw"\alpha"
@test latexraw("α + 1") == raw"\alpha + 1"
@test latexraw("α₁") == raw"\alpha_{1}"
@test latexraw("γ³") == raw"\gamma^3"
@test latexraw("β₃_hello") == raw"\beta_{3\_hello}"
### Test broadcasting
@test latexraw(:(sum.((a, b)))) == raw"\mathrm{sum}\left( a, b \right)"


f = @ode_def TestRaw begin
    dx = y/c_1 - x
    dy = x^c_2 - y
end c_1 c_2
@test latexraw(f) == ["\\frac{dx}{dt} = \\frac{y}{c_{1}} - x", "\\frac{dy}{dt} = x^{c_{2}} - y"]


### Test for correct signs in nested sums/differences.
@test latexraw("-(-1)") == raw" + 1"
@test latexraw("+(-1)") == raw"-1"
@test latexraw("-(+1)") == raw" - 1"
@test latexraw("-(1+1)") == raw" - \left( 1 + 1 \right)"
@test latexraw("1-(-2)") == raw"1 + 2"
@test latexraw("1 + (-(2))") == raw"1 - 2"
@test latexraw("1 + (-2 -3 -4)") == raw"1 -2 - 3 - 4"
@test latexraw("1 - 2 - (- 3 - 4)") == raw"1 - 2 - \left(  - 3 - 4 \right)"
@test latexraw("1 - 2 - (- 3 -(2) + 4)") == raw"1 - 2 - \left(  - 3 - 2 + 4 \right)"
@test latexraw("1 - 2 - (- 3 -(2 - 8) + 4)") == raw"1 - 2 - \left(  - 3 - \left( 2 - 8 \right) + 4 \right)"

# @test_throws ErrorException latexify("x/y"; env=:raw, bad_kwarg="should error")


@test latexraw(:(3 * (a .< b .<= c < d <= e > f <= g .<= h .< i == j .== k != l .!= m))) ==
raw"3 \cdot \left( a \lt b \leq c \lt d \leq e \gt f \leq g \leq h \lt i = j = k \neq l \neq m \right)"



#### Test the fmt keyword option
@test latexify([32894823 1.232212 :P_1; :(x / y) 1.0e10 1289.1]; env=:align, fmt="%.2e") ==
raw"\begin{align}
3.29e+07 =& 1.23e+00 =& P_{1} \\
\frac{x}{y} =& 1.00e+10 =& 1.29e+03
\end{align}
"

@test latexify([32894823 1.232212 :P_1; :(x / y) 1.0e10 1289.1]; env=:array, fmt="%.2e") ==
raw"\begin{equation}
\left[
\begin{array}{ccc}
3.29e+07 & 1.23e+00 & P_{1} \\
\frac{x}{y} & 1.00e+10 & 1.29e+03 \\
\end{array}
\right]
\end{equation}
"


@test latexify([32894823 1.232212 :P_1; :(x / y) 1.0e10 1289.1]; env=:table, fmt="%.2e") ==
raw"\begin{tabular}{ccc}
$3.29e+07$ & $1.23e+00$ & $P_{1}$\\
$\frac{x}{y}$ & $1.00e+10$ & $1.29e+03$\\
\end{tabular}
"


@test latexify([32894823 1.232212 :P_1; :(x / y) 1.0e10 1289.1]; env=:mdtable, fmt="%.2e") ==
Markdown.md"|    $3.29e+07$ | $1.23e+00$ |    $P_{1}$ |
| -------------:| ----------:| ----------:|
| $\frac{x}{y}$ | $1.00e+10$ | $1.29e+03$ |
"

@test latexify(1234.2234; env=:inline, fmt="%.2e") ==
raw"$1.23e+03$"

@test latexify(1234.2234; env=:raw, fmt="%.2e") ==
raw"1.23e+03"


test_functions = [:sinh, :alpha, :Theta, :cosc, :acoth, :acot, :asech, :lambda,
                  :asinh, :sinc, :eta, :kappa, :nu, :asin, :epsilon, :sigma,
                  :upsilon, :phi, :tanh, :iota, :Psi, :acosh, :log, :zeta, :mu,
                  :csc, :xi, :tau, :beta, :Lambda, :Xi, :Phi, :acsc, :atan,
                  :sech, :atanh, :gamma, :Delta, :rho, :sec, :log10, :delta,
                  :pi, :cot, :log2, :cos, :Omega, :psi, :atan2, :Gamma, :cosh,
                  :acos, :Pi, :Upsilon, :omega, :coth, :chi, :tan, :csch,
                  :acsch, :theta, :asec, :Sigma, :sin]


@test latexify(["3*$(func)(x)^2/4 -1" for func = test_functions]) == 
raw"\begin{equation}
\left[
\begin{array}{c}
\frac{3 \cdot \sinh^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \left( \alpha\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \Theta\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \mathrm{cosc}^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \mathrm{arccoth}^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \mathrm{arccot}^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \mathrm{arcsech}^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \left( \lambda\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \mathrm{arcsinh}^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \mathrm{sinc}^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \left( \eta\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \kappa\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \nu\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \arcsin^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \left( \epsilon\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \sigma\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \upsilon\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \phi\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \tanh^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \left( \iota\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \Psi\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \mathrm{arccosh}^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \left( \log\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \zeta\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \mu\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \csc^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \left( \xi\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \tau\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \beta\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \Lambda\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \Xi\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \Phi\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \mathrm{arccsc}^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \arctan^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \mathrm{sech}^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \mathrm{arctanh}^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \left( \Gamma\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \Delta\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \rho\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \sec^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \left( \log_{10}\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \delta\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \pi\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \cot^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \left( \log_{2}\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \cos^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \left( \Omega\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \psi\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \arctan^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \left( \Gamma\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \cosh^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \arccos^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \left( \Pi\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \Upsilon\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \left( \omega\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \coth^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \left( \chi\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \tan^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \mathrm{csch}^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \mathrm{arccsch}^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \left( \theta\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \mathrm{arcsec}^{2}\left( x \right)}{4} - 1 \\
\frac{3 \cdot \left( \Sigma\left( x \right) \right)^{2}}{4} - 1 \\
\frac{3 \cdot \sin^{2}\left( x \right)}{4} - 1 \\
\end{array}
\right]
\end{equation}
"


