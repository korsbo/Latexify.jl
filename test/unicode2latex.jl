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

@test latexify("ÀéÜ"; parse=false).s == raw"$\textrm{\`{A}}\textrm{\'{e}}\textrm{\\\"{U}}$"

@test latexify("w̋Ṽî"; parse=false).s == raw"$\textrm{\H{w}}\textrm{\~{V}}\textrm{\^{i}}$"

@test latexify("çĘf̄"; parse=false).s == raw"$\textrm{\c{c}}\textrm{\k{E}}\textrm{\={f}}$"

@test latexify("ṞȯX̣"; parse=false).s == raw"$\textrm{\b{R}}\textrm{\.{o}}\textrm{\d{X}}$"

@test latexify("ẙĞž"; parse=false).s == raw"$\textrm{\r{y}}\textrm{\u{G}}\textrm{\v{z}}$"

s = 'y' * Char(0x30a) * 'x' * Char(0x302) * 'a' * Char(0x331)
@test latexify(s; parse=false).s == raw"$\textrm{\r{y}}\textrm{\^{x}}\textrm{\b{a}}$"

s = 'Y' * Char(0x30a) * 'X' * Char(0x302) * 'A' * Char(0x331)
@test latexify(s; parse=false).s == raw"$\textrm{\r{Y}}\textrm{\^{X}}\textrm{\b{A}}$"

s = 'i' * Char(0x308) * 'z' * Char(0x304) * 'e' * Char(0x306)
@test latexify(s; parse=false).s == raw"$\textrm{\\\"{i}}\textrm{\={z}}\textrm{\u{e}}$"

s = 'I' * Char(0x308) * 'Z' * Char(0x304) * 'E' * Char(0x306)
@test latexify(s; parse=false).s == raw"$\textrm{\\\"{I}}\textrm{\={Z}}\textrm{\u{E}}$"
