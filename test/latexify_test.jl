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

all(test_results)
