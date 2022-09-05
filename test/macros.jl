l = @latexify dummyfunc(x; y=1, z=3) = x^2/y + z
@test l == raw"$dummyfunc\left( x; y = 1, z = 3 \right) = \frac{x^{2}}{y} + z$"

@test_throws UndefVarError dummyfunc(1.) 

l2 = @latexrun dummyfunc2(x; y=1, z=3) = x^2/y + z
@test l2 == raw"$dummyfunc2\left( x; y = 1, z = 3 \right) = \frac{x^{2}}{y} + z$"

@test dummyfunc2(1.) == 4

l3 = @latexify dummyfunc2(x::Number; y=1, z=3) = x^2/y + z
@test l3 == replace( raw"$dummyfunc2\left( x::\mathrm{Number}; y = 1, z = 3 \right) = \frac{x^{2}}{y} + z$", "\r\n"=>"\n")

l4 = @latexify dummyfunc2(::Number; y=1, z=3) = x^2/y + z
@test l4 == raw"$dummyfunc2\left( ::\mathrm{Number}; y = 1, z = 3 \right) = \frac{x^{2}}{y} + z$"

