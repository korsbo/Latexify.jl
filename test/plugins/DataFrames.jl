using DataFrames
using LaTeXStrings


df = DataFrame(A = 'x':'z', B = ["α/β", 1//2, 8])


@test latexify(df, latex=true) ==
Markdown.md"|   A |                      B |
| ---:| ----------------------:|
| $x$ | $\frac{\alpha}{\beta}$ |
| $y$ |          $\frac{1}{2}$ |
| $z$ |                    $8$ |
"



@test_broken latexify(df; env=:array) ==
L"\begin{equation}
\left[
\begin{array}{cc}
A & B \\
x & \frac{\alpha}{\beta} \\
y & \frac{1}{2} \\
z & 8 \\
\end{array}
\right]
\end{equation}
"


@test latexify(df; env=:table, latex=true) ==
raw"\begin{tabular}{cc}
$A$ & $B$\\
$x$ & $\frac{\alpha}{\beta}$\\
$y$ & $\frac{1}{2}$\\
$z$ & $8$\\
\end{tabular}
"


@test latexify(df; env=:table, latex=false) ==
raw"\begin{tabular}{cc}
A & B\\
x & α/β\\
y & 1//2\\
z & 8\\
\end{tabular}
"
