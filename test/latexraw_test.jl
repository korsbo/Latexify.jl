
using Latexify
using Test
using Markdown

str = "2*x^2 - y/c_2"
ex = :(2*x^2 - y/c_2)

desired_output = "2 \\cdot x^{2} - \\frac{y}{c_{2}}"

@test latexify(:(a = [x / y; 3; 4])) == 
raw"$a = \left[
\begin{array}{c}
\frac{x}{y} \\
3 \\
4 \\
\end{array}
\right]$"

@test latexify(:(a = [x / y 2 3 4])) == 
raw"$a = \left[
\begin{array}{cccc}
\frac{x}{y} & 2 & 3 & 4 \\
\end{array}
\right]$"

@test latexify(:(a = [x / y 2; 3 4])) == 
raw"$a = \left[
\begin{array}{cc}
\frac{x}{y} & 2 \\
3 & 4 \\
\end{array}
\right]$"


@test latexraw(str) == latexraw(ex)
@test latexraw(ex) == desired_output

@test latexify(:(u[1, 2]); index = :bracket) == raw"$u\left[1, 2\right]$"
@test latexify(:(u[1, 2]); index = :subscript) == raw"$u_{1,2}$"

array_test = [ex, str]
@test all(latexraw(array_test) .== desired_output)

@test latexraw(:(@__dot__(x / y))) == raw"\frac{x}{y}"
@test latexraw(:(@. x / y)) == raw"\frac{x}{y}"
@test latexraw(:(eps())) == raw"\mathrm{eps}()"

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
@test latexraw(:(f(x))) ==  "f\\left( x \\right)"
@test latexraw("x = 4*y") == "x = 4 \\cdot y"
@test latexraw(:(sqrt(x))) == "\\sqrt{x}"
@test latexraw(complex(1,-1)) == "1-1\\textit{i}"
@test latexraw(1//2) == "\\frac{1}{2}"
@test latexraw(Missing()) == "\\textrm{NA}"
@test latexraw("x[2]") == raw"x\left[2\right]"
@test latexraw("x[2, 3]") == raw"x\left[2, 3\right]"
@test latexraw("α") == raw"\alpha"
@test latexraw("α + 1") == raw"\alpha + 1"
@test latexraw("α₁") == raw"\alpha{_1}"
@test latexraw("γ³") == raw"\gamma{^3}"
@test latexraw("β₃_hello") == raw"\beta{_3}_{hello}"
@test latexraw("β₃₄") == raw"\beta{_{34}}"
@test latexraw("β₃₄¹⁴") == raw"\beta{_{34}^{14}}"
@test latexraw("β₃¹⁴") == raw"\beta{_3^{14}}"
@test latexraw("β¹⁴₃") == raw"\beta{^{14}_3}"
@test latexraw("β¹⁴") == raw"\beta{^{14}}"
@test latexraw("β⁴") == raw"\beta{^4}"



@test latexify(:((-1) ^ 2)) == replace(
raw"$\left( -1 \right)^{2}$", "\r\n"=>"\n")
@test latexify(:($(1 + 2im) ^ 2)) == replace(
raw"$\left( 1+2\textit{i} \right)^{2}$", "\r\n"=>"\n")
@test latexify(:($(3 // 2) ^ 2)) == replace(
raw"$\left( \frac{3}{2} \right)^{2}$", "\r\n"=>"\n")


### Test broadcasting
@test latexraw(:(sum.((a, b)))) == raw"\mathrm{sum}\left( a, b \right)"




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
raw"3 \cdot \left( a < b \leq c < d \leq e > f \leq g \leq h < i = j = k \neq l \neq m \right)"



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


## Test logical operators
@test latexraw(:(x && y)) == "x \\wedge y"
@test latexraw(:(x || y)) == "x \\vee y"
@test latexraw(:(x || !y)) == "x \\vee \\neg y"


## Test {cases} enviroment
@test latexraw(:(R(p,e,d) = e ? 0 : log(p) - d)) ==
raw"R\left( p, e, d \right) = \begin{cases}
0 & \text{if } e\\
\log\left( p \right) - d & \text{otherwise}
\end{cases}"

@test latexraw(:(R(p,e,d,t) = if (t && e); 0 elseif (t && !e); d else log(p) end)) ==
raw"R\left( p, e, d, t \right) = \begin{cases}
0 & \text{if } t \wedge e\\
d & \text{if } t \wedge \neg e\\
\log\left( p \right) & \text{otherwise}
\end{cases}"

@test latexraw(:(function reward(p,e,d,t)
    if t && e
        return 0
    elseif t && !e
        return -1d
    elseif 2t && e
        return -2d
    elseif 3t && e
        return -3d
    else
        return log(p)
    end
end)) ==
raw"\mathrm{reward}\left( p, e, d, t \right) = \begin{cases}
0 & \text{if } t \wedge e\\
-1 \cdot d & \text{if } t \wedge \neg e\\
-2 \cdot d & \text{if } 2 \cdot t \wedge e\\
-3 \cdot d & \text{if } 3 \cdot t \wedge e\\
\log\left( p \right) & \text{otherwise}
\end{cases}"
