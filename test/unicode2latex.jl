@test latexify("α"; convert_unicode=false) == raw"$α$"

@test latexify(['α', :β, "γ/η"], transpose=true, convert_unicode=false) == replace(
raw"\begin{equation}
\left[
\begin{array}{ccc}
α & β & \frac{γ}{η} \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")

@test latexify("αaβ") == raw"${\alpha}a\beta$"

@test latexify("αaβ").s == raw"${\alpha}a\beta$"

@test latexify("ÀéÜ"; parse=false).s == raw"$\text{\`{A}}\text{\'{e}}\text{\\\"{U}}$"

@test latexify("w̋Ṽî"; parse=false).s == raw"$\text{\H{w}}\text{\~{V}}\text{\^{i}}$"

@test latexify("çĘf̄"; parse=false).s == raw"$\text{\c{c}}\text{\k{E}}\text{\={f}}$"

@test latexify("ṞȯX̣"; parse=false).s == raw"$\text{\b{R}}\text{\.{o}}\text{\d{X}}$"

@test latexify("ẙĞž"; parse=false).s == raw"$\text{\r{y}}\text{\u{G}}\text{\v{z}}$"

s = 'y' * Char(0x30a) * 'x' * Char(0x302) * 'a' * Char(0x331)
@test latexify(s; parse=false).s == raw"$\text{\r{y}}\text{\^{x}}\text{\b{a}}$"

s = 'Y' * Char(0x30a) * 'X' * Char(0x302) * 'A' * Char(0x331)
@test latexify(s; parse=false).s == raw"$\text{\r{Y}}\text{\^{X}}\text{\b{A}}$"

s = 'i' * Char(0x308) * 'z' * Char(0x304) * 'e' * Char(0x306)
@test latexify(s; parse=false).s == raw"$\text{\\\"{i}}\text{\={z}}\text{\u{e}}$"

s = 'I' * Char(0x308) * 'Z' * Char(0x304) * 'E' * Char(0x306)
@test latexify(s; parse=false).s == raw"$\text{\\\"{I}}\text{\={Z}}\text{\u{E}}$"

if Sys.islinux()
  mktempdir() do dn
    name = tempname()
    str = map(
      chunk -> string("\\[", join(chunk, " "), "\\]\n"),
      Iterators.partition(values(Latexify.unicodedict), 40)
    ) |> prod
    Latexify._writetex(
      LaTeXString(str),
      name=name,
      documentclass="article",
      preamble="\\usepackage[margin=2cm]{geometry}"
    )
    # should compile, even if some glyphs aren't found in the default font face
    @test pipeline(`latexmk -output-directory=$dn -quiet -pdflatex=lualatex -pdf $name.tex`, stdout=devnull) |> run |> success
  end
end
