l = @latexify dummyfunc(x; y=1, z=3) = x^2/y + z
@test l == raw"$\mathrm{dummyfunc}\left( x; y = 1, z = 3 \right) = \frac{x^{2}}{y} + z$"

@test_throws UndefVarError dummyfunc(1.)

l2 = @latexrun dummyfunc2(x; y=1, z=3) = x^2/y + z
@test l2 == raw"$\mathrm{dummyfunc2}\left( x; y = 1, z = 3 \right) = \frac{x^{2}}{y} + z$"

@test dummyfunc2(1.) == 4

l3 = @latexify dummyfunc2(x::Number; y=1, z=3) = x^2/y + z
@test l3 == raw"$\mathrm{dummyfunc2}\left( x::Number; y = 1, z = 3 \right) = \frac{x^{2}}{y} + z$"


l4 = @latexify dummyfunc2(::Number; y=1, z=3) = x^2/y + z
@test l4 == raw"$\mathrm{dummyfunc2}\left( ::Number; y = 1, z = 3 \right) = \frac{x^{2}}{y} + z$"

l5 = @latexify x = abs2(-3)
@test l5 == raw"$x = \left|-3\right|^{2}$"

l6 = @latexify x = $(abs2(-3))
@test l6 == raw"$x = 9$"

l7 = @latexrun x = abs2(-3)
@test l7 == raw"$x = \left|-3\right|^{2}$"
@test x == 9

l8 = @latexrun x = $(abs2(-3))
@test l8 == raw"$x = 9$"
@test x == 9

l9 = @latexdefine x = abs2(-2)
@test l9 == raw"$x = \left|-2\right|^{2} = 4$"
@test x == 4

l10 = @latexdefine x = $(abs2(-2))
@test l10 == raw"$x = 4 = 4$"
@test x == 4

l11 = @latexify x = 1 env=:raw
@test l11 == raw"x = 1"

l12 = @latexrun x = 1 env=:raw
@test l12 == raw"x = 1"

l13 = @latexdefine y = x env=:raw
@test l13 == raw"y = x = 1"

env = :raw
l14 = @latexdefine y env
@test l14 == raw"y = 1"

@test latexify(:(@hi(x / y))) == replace(
raw"$\mathrm{@hi}\left( \frac{x}{y} \right)$", "\r\n"=>"\n")
