l = @latexify dummyfunc(x; y=1, z=3) = x^2/y + z
@test l == raw"$\mathrm{dummyfunc}\left( x; y = 1, z = 3 \right) = \frac{x^{2}}{y} + z$"

@test_throws UndefVarError dummyfunc(1.) 

l2 = @latexrun dummyfunc2(x; y=1, z=3) = x^2/y + z
@test l2 == raw"$\mathrm{dummyfunc2}\left( x; y = 1, z = 3 \right) = \frac{x^{2}}{y} + z$"

@test dummyfunc2(1.) == 4

