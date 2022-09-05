
@test latexify("x/y"; env=:eq) == 
raw"\begin{equation}
\frac{x}{y}
\end{equation}"

@test latexify("x = a^x/b"; env=:eq, starred=true) == 
raw"\begin{equation*}
x = \frac{a^{x}}{b}
\end{equation*}"
