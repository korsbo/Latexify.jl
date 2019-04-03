using Latexify
using Test
import Latexify: PlainNumberFormatter, PrintfNumberFormatter

@test FancyNumberFormatter() == FancyNumberFormatter(4) == FancyNumberFormatter("%.4g", "\\cdot") == FancyNumberFormatter("%.4g", s"\g<mantissa> \\cdot 10^{\g<exp>}")

x = -23.4728979e7

@test PlainNumberFormatter()(x) == "-2.34728979e8"
@test PrintfNumberFormatter("%.4g")(x) == "-2.347e+08"
@test StyledNumberFormatter()(x) == "-2.347 \\mathrm{e} 8"
@test FancyNumberFormatter()(x) == "-2.347 \\cdot 10^{8}"
@test FancyNumberFormatter("%.5E", s"\g<mantissa>,\g<before_dp>,\g<sign>,\g<before_dp_nosign>,\g<after_dp>,\g<e_or_E>,\g<raw_exp>,\g<exp>,\g<sign_exp>")(x) == "-2.34729,-2,-,2,34729,E,+08,8,"

y = 0xf43

@test StyledNumberFormatter()(y) == FancyNumberFormatter()(y) == "\\mathtt{0x0f43}"
