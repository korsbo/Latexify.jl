
using Latexify
using ParameterizedFunctions
test_results = []

str = "2*x^2 - y/c_2"
exp = :(2*x^2 - y/c_2)

desired_output = "2 \\cdot x^{2} - \\frac{y}{c_{2}}"

push!(test_results, latexraw(str) == latexraw(exp))
push!(test_results, latexraw(exp) == desired_output)

array_test = [exp, str]
push!(test_results, all(latexraw(array_test) .== desired_output))

push!(test_results, latexraw(:y_c_a) == "y_{c\\_a}")
push!(test_results, latexraw(1.0) == "1.0")
push!(test_results, latexraw(1.00) == "1.0")
push!(test_results, latexraw(1) == "1")
push!(test_results, latexraw(:(log10(x))) == "\\log_{10}\\left( x \\right)")
push!(test_results, latexraw(:(sin(x))) ==  "\\sin\\left( x \\right)")
push!(test_results, latexraw(:(asin(x))) ==  "\\arcsin\\left( x \\right)")
push!(test_results, latexraw(:(asinh(x))) ==  "\\mathrm{arcsinh}\\left( x \\right)")
push!(test_results, latexraw(:(sinc(x))) ==  "\\mathrm{sinc}\\left( x \\right)")
push!(test_results, latexraw(:(acos(x))) ==  "\\arccos\\left( x \\right)")
push!(test_results, latexraw(:(acosh(x))) ==  "\\mathrm{arccosh}\\left( x \\right)")
push!(test_results, latexraw(:(cosc(x))) ==  "\\mathrm{cosc}\\left( x \\right)")
push!(test_results, latexraw(:(atan(x))) ==  "\\arctan\\left( x \\right)")
push!(test_results, latexraw(:(atan2(x))) ==  "\\arctan\\left( x \\right)")
push!(test_results, latexraw(:(atanh(x))) ==  "\\mathrm{arctanh}\\left( x \\right)")
push!(test_results, latexraw(:(acot(x))) ==  "\\mathrm{arccot}\\left( x \\right)")
push!(test_results, latexraw(:(acoth(x))) ==  "\\mathrm{arccoth}\\left( x \\right)")
push!(test_results, latexraw(:(asec(x))) ==  "\\mathrm{arcsec}\\left( x \\right)")
push!(test_results, latexraw(:(sech(x))) ==  "\\mathrm{sech}\\left( x \\right)")
push!(test_results, latexraw(:(asech(x))) ==  "\\mathrm{arcsech}\\left( x \\right)")
push!(test_results, latexraw(:(acsc(x))) ==  "\\mathrm{arccsc}\\left( x \\right)")
push!(test_results, latexraw(:(csch(x))) ==  "\\mathrm{csch}\\left( x \\right)")
push!(test_results, latexraw(:(acsch(x))) ==  "\\mathrm{arccsch}\\left( x \\right)")
push!(test_results, latexraw(:(f(x))) ==  "f\\left( x \\right)")
push!(test_results, latexraw("x = 4*y") == "x = 4 \\cdot y")
push!(test_results, latexraw(:(sqrt(x))) == "\\sqrt{x}")
push!(test_results, latexraw(complex(1,-1)) == "1-1\\textit{i}")
push!(test_results, latexraw(1//2) == "\\frac{1}{2}")
push!(test_results, latexraw(Missing()) == "\\textrm{NA}")

f = @ode_def feedback begin
    dx = y/c_1 - x
    dy = x^c_2 - y
end c_1 c_2
push!(test_results, latexraw(f) == ["\\frac{dx}{dt} = \\frac{y}{c_{1}} - x", "\\frac{dy}{dt} = x^{c_{2}} - y"])

println("latexraw_test successes: \n", test_results)
all(test_results)
