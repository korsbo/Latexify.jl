@test latexify("α"; convert_unicode=false) == raw"$α$"


@test latexify(['α', :β, "γ/η"], transpose=true, convert_unicode=false) == replace(
raw"$\left[
\begin{array}{ccc}
α & β & \frac{γ}{η} \\
\end{array}
\right]$", "\r\n"=>"\n")

@test latexify("αaβ") == raw"${\alpha}a\beta$"
