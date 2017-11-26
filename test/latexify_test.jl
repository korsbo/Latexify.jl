using Latexify
using DifferentialEquations
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
push!(test_results, latexraw("x = 4*y") == "x = 4 \\cdot y")
push!(test_results, latexraw(:(sqrt(x))) == "\\sqrt{x}")
push!(test_results, latexraw(complex(1,-1)) == "1-1\\textit{i}")
push!(test_results, latexraw(1//2) == "\\frac{1}{2}")

f = @ode_def feedback begin
    dx = y/c_1 - x
    dy = x^c_2 - y
end c_1=>1.0 c_2=>1.0
push!(test_results, latexraw(f) == ["dx/dt = \\frac{y}{c_{1}} - x", "dy/dt = x^{c_{2}} - y"])

println("latexraw_test successes: \n", test_results)
all(test_results)
