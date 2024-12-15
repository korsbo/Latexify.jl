using DataFrames
using LaTeXStrings


df = DataFrame(A = 'x':'z', B = ["α/β", 1//2, 8])

@test mdtable(df) ==
Markdown.md"|   A |                      B |
| ---:| ----------------------:|
| $x$ | $\frac{\alpha}{\beta}$ |
| $y$ |          $\frac{1}{2}$ |
| $z$ |                    $8$ |
"

@test latexify(df, latex=true) ==
Markdown.md"|   A |                      B |
| ---:| ----------------------:|
| $x$ | $\frac{\alpha}{\beta}$ |
| $y$ |          $\frac{1}{2}$ |
| $z$ |                    $8$ |
"



@test_broken latexify(df; env=:array) == replace(
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
", "\r\n"=>"\n")


@test latexify(df; env=:table, latex=true) == replace(
raw"\begin{tabular}{cc}
$A$ & $B$\\
$x$ & $\frac{\alpha}{\beta}$\\
$y$ & $\frac{1}{2}$\\
$z$ & $8$\\
\end{tabular}
", "\r\n"=>"\n")


@test latexify(df; env=:table, latex=false) == replace(
raw"\begin{tabular}{cc}
A & B\\
x & α/β\\
y & 1//2\\
z & 8\\
\end{tabular}
", "\r\n"=>"\n")

@test latexify(df; head=["x", "y"]) ==
Markdown.md"|   x |                      y |
| ---:| ----------------------:|
| $x$ | $\frac{\alpha}{\beta}$ |
| $y$ |          $\frac{1}{2}$ |
| $z$ |                    $8$ |
"
