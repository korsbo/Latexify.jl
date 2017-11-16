using Latexify
test_results = []

str = "2*x^2 - y/c_2"
exp = :(2*x^2 - y/c_2)

desired_output = "2 \\cdot x^{2} - \\frac{y}{c_{2}}"

push!(test_results, latexify(str) == latexify(exp))
push!(test_results, latexify(exp) == desired_output)

array_test = [exp, str]
push!(test_results, all(latexify(array_test) .== desired_output))

push!(test_results, latexify(:y_c_a) == "y_{c\\_a}")
push!(test_results, latexify(1.0) == "1.0")
push!(test_results, latexify(1.00) == "1.0")
push!(test_results, latexify(1) == "1")
push!(test_results, latexify(:(log10(x))) == "\\log_{10}\\left( x \\right)")
push!(test_results, latexify(:(sin(x))) ==  "\\sin\\left( x \\right)")
push!(test_results, latexify("x = 4*y") == "x = 4 \\cdot y")
push!(test_results, latexify(:(sqrt(x))) == "\\sqrt{x}")



push!(test_results, latexify(1//2) == "\\frac{1}{2}")

using DifferentialEquations
f = @ode_def feedback begin
    dx = y/c_1 - x
    dy = x^c_2 - y
end c_1=>1.0 c_2=>1.0
push!(test_results, latexify(f) == ["dx/dt = \\frac{y}{c_{1}} - x", "dy/dt = x^{c_{2}} - y"])

println("latexify_test successes: \n", test_results)
all(test_results)
