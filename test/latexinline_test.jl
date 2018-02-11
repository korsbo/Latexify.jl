using Latexify
using LaTeXStrings

test_results = []
test_array = ["x/y * d" :x ; :( (t_sub_sub - x)^(2*p) ) 3//4 ]
push!(test_results, latexinline(test_array) == [
    L"$\frac{x}{y} \cdot d$"                          L"$x$"         ;
    L"$\left( t_{sub\_sub} - x \right)^{2 \cdot p}$"  L"$\frac{3}{4}$"
    ])

all(test_results)
