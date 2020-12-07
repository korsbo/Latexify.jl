using Unitful
using LaTeXStrings

u = u"J/kg"
q = 24.7e9u"Gm/s^2"

@test latexify(u) == L"$\mathrm{J}\mathrm{kg}^{-1}$"
@test latexify(u,unitformat=:siunitx) == LaTeXString("\\si{\\joule\\per\\kilo\\gram}")
@test latexify(q) == L"$2.47e10\;\mathrm{Gm}\mathrm{s}^{-2}$"
@test latexify(q,unitformat=:siunitx) == LaTeXString("\\SI{2.47e10}{\\giga\\meter\\per\\second\\tothe{2}}")
