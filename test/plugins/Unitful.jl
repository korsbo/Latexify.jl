using Unitful
using LaTeXStrings

u = u"J/kg"
q = 24.7e9u"Gm/s^2"

@test latexify(u) == "\$\\mathrm{J}\\mathrm{kg}^{-1}\$"
@test latexify(u,unitformat=:siunitx) == "\$\\si{\\joule\\per\\kilo\\gram}\$"
@test latexify(q) == "\$2.47e10\\;\\mathrm{Gm}\\mathrm{s}^{-2}\$"
@test latexify(q,unitformat=:siunitx) == "\$\\SI{2.47e10}{\\giga\\meter\\per\\second\\tothe{2}}\$"
