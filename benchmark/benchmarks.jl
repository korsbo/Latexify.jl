using BenchmarkTools
using Latexify

const SUITE = BenchmarkGroup()

chars = vcat(
             'A':'Z',
             'a':'z',
             'Α':'Ρ', # skip unprintable char (no \Varsigma)
             'Σ':'Ω',
             'α':'ω',
             '𝕒':'𝕫',
             '𝐴':'𝑍',
            )

SUITE["unicode"] = @benchmarkable latexify(string(c)) setup = (c = rand(chars))

struct AType
    x
end
struct BType
    a
end

@latexrecipe function f(a::AType)
    return :($(a.x) + 1)
end
@latexrecipe function f(b::BType)
    return :($(b.a)/2)
end


SUITE["user types"] = @benchmarkable latexify(BType(AType(x))) setup = (x=rand())

SUITE["expression"] = @benchmarkable latexify(:(2x + 3 ∈ 25/4 + y - z^2^4α ? 8 : 9))

