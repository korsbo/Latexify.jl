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

@latexrecipe f(a::AType) = :($(a.x) + 1)
@latexrecipe f(b::BType) = :($(b.a)/2)

SUITE["user types"] = @benchmarkable latexify(BType(AType(x))) setup = (x=rand())
