
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
