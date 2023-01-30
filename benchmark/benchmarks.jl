using BenchmarkTools
using Latexify

const SUITE = BenchmarkGroup()

chars = vcat(
             'A':'Z',
             'a':'z',
             'Α':'Ρ', 'Σ':'Ω',
             'α':'ω',
             '𝕒':'𝕫',
             '𝐴':'𝑍',
            )

SUITE["unicode"] = @benchmarkable latexify(string(c)) setup = (c = rand(chars))
