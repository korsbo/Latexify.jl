@test latexify("α"; convert_unicode=false) == raw"$α$"


@test latexify(['α', :β, "γ/η"], convert_unicode=false) ==
raw"\begin{equation}
\left[
\begin{array}{ccc}
α & β & \frac{γ}{η} \\
\end{array}
\right]
\end{equation}
"
