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

@test latexify("ÀéÜ"; parse=false).s == raw"$\textnormal{\`{A}}\textnormal{\'{e}}\textnormal{\\\"{U}}$"

@test latexify("w̋Ṽî"; parse=false).s == raw"$\textnormal{\H{w}}\textnormal{\~{V}}\textnormal{\^{i}}$"

@test latexify("çĘf̄"; parse=false).s == raw"$\textnormal{\c{c}}\textnormal{\k{E}}\textnormal{\={f}}$"

@test latexify("ṞȯX̣"; parse=false).s == raw"$\textnormal{\b{R}}\textnormal{\.{o}}\textnormal{\d{X}}$"

@test latexify("ẙĞž"; parse=false).s == raw"$\textnormal{\r{y}}\textnormal{\u{G}}\textnormal{\v{z}}$"

s = 'y' * Char(0x30a) * 'x' * Char(0x302) * 'a' * Char(0x331)
@test latexify(s; parse=false).s == raw"$\textnormal{\r{y}}\textnormal{\^{x}}\textnormal{\b{a}}$"

s = 'Y' * Char(0x30a) * 'X' * Char(0x302) * 'A' * Char(0x331)
@test latexify(s; parse=false).s == raw"$\textnormal{\r{Y}}\textnormal{\^{X}}\textnormal{\b{A}}$"

s = 'i' * Char(0x308) * 'z' * Char(0x304) * 'e' * Char(0x306)
@test latexify(s; parse=false).s == raw"$\textnormal{\\\"{i}}\textnormal{\={z}}\textnormal{\u{e}}$"

s = 'I' * Char(0x308) * 'Z' * Char(0x304) * 'E' * Char(0x306)
@test latexify(s; parse=false).s == raw"$\textnormal{\\\"{I}}\textnormal{\={Z}}\textnormal{\u{E}}$"

@test latexify(:(iħ * (∂Ψ(𝐫, t) / ∂t) = -ħ^2 / 2m * ΔΨ(𝐫, t) + V * Ψ(𝐫, t))).s ==
    raw"$i\hslash \cdot \frac{\partial\Psi\left( \mathbf{r}, t \right)}{{\partial}t} = " * 
    raw"\frac{ - \hslash^{2}}{2 \cdot m} \cdot \Delta\Psi\left( \mathbf{r}, t \right) + V \cdot \Psi\left( \mathbf{r}, t \right)$"

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

    # not checked for correctness, only for rendering without errors
    eq = latexify(:(sin(α) / (β + 1)))

    name = tempname()
    render(eq, MIME("application/pdf"); name=name, open=false)
    @test filesize("$name.pdf") > 100

    name = tempname()
    render(eq, MIME("application/x-dvi"); name=name, open=false)
    @test filesize("$name.dvi") > 100

    name = tempname()
    render(eq, MIME("image/png"); name=name, open=false)
    @test filesize("$name.png") > 100

    name = tempname()
    render(eq, MIME("image/svg"); name=name, open=false)
    @test filesize("$name.svg") > 100
end
