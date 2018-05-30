
using Latexify
using ParameterizedFunctions

str = "2*x^2 - y/c_2"
exp = :(2*x^2 - y/c_2)

desired_output = "2 \\cdot x^{2} - \\frac{y}{c_{2}}"

@test latexraw(str) == latexraw(exp)
@test latexraw(exp) == desired_output

array_test = [exp, str]
@test all(latexraw(array_test) .== desired_output)

@test latexraw(:y_c_a) == "y_{c\\_a}"
@test latexraw(1.0) == "1.0"
@test latexraw(1.00) == "1.0"
@test latexraw(1) == "1"
@test latexraw(:(log10(x))) == "\\log_{10}\\left( x \\right)"
@test latexraw(:(sin(x))) ==  "\\sin\\left( x \\right)"
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
@test latexraw(:(f(x))) ==  "\\mathrm{f}\\left( x \\right)"
@test latexraw("x = 4*y") == "x = 4 \\cdot y"
@test latexraw(:(sqrt(x))) == "\\sqrt{x}"
@test latexraw(complex(1,-1)) == "1-1\\textit{i}"
@test latexraw(1//2) == "\\frac{1}{2}"
@test latexraw(Missing()) == "\\textrm{NA}"

f = @ode_def feedback begin
    dx = y/c_1 - x
    dy = x^c_2 - y
end c_1 c_2
@test latexraw(f) == ["\\frac{dx}{dt} = \\frac{y}{c_{1}} - x", "\\frac{dy}{dt} = x^{c_{2}} - y"]
