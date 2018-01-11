using Latexify
using LaTeXStrings

test_results = []
test_array = ["x/y * d" :x ; :( (t_sub_sub - x)^(2*p) ) 3//4 ]
push!(test_results, latexify(test_array) == [
    L"$\frac{x}{y} \cdot d$"                          L"$x$"         ;
    L"$\left( t_{sub\_sub} - x \right)^{2 \cdot p}$"  L"$\frac{3}{4}$"
    ])

#Latexify.copy_to_clipboard(true)
#latexify("x/y")
#push!(test_results, clipboard() == "\$\\frac{x}{y}\$" )

#Latexify.copy_to_clipboard(false)
#latexify("x")
#push!(test_results, clipboard() == "\$\\frac{x}{y}\$" )

all(test_results)
