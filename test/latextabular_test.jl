using DataFrames
using Latexify
using Base.Test
d = DataFrame(11:13, [:X, :Y, :Z])

# @Latexify.generate_test latexify(d; env=:table, side=[1, 2])

@test latexify(d; env=:table, side=[1, 2]) ==
raw"\begin{tabular}{cccc}
$1$ & $X$ & $Y$ & $Z$\\
$2$ & $11$ & $12$ & $13$\\
\end{tabular}
"

arr = ["x/(y-1)", 1.0, 3//2, :(x-y), :symb]

M = vcat(hcat(arr...), hcat(arr...))
head = ["col$i" for i in 1:size(M, 2)]
side = ["row$i" for i in 1:size(M, 1)]


@test latexify(M; env=:table, head=1:2, adjustment=:l, latex=false, transpose=true) ==
raw"\begin{tabular}{ll}
1 & 2\\
x/(y-1) & x/(y-1)\\
1.0 & 1.0\\
3//2 & 3//2\\
x - y & x - y\\
symb & symb\\
\end{tabular}
"


@test latexify(M; env=:table, head=1:2, adjustment=:l, transpose=true) ==
raw"\begin{tabular}{ll}
$1$ & $2$\\
$\frac{x}{y - 1}$ & $\frac{x}{y - 1}$\\
$1.0$ & $1.0$\\
$\frac{3}{2}$ & $\frac{3}{2}$\\
$x - y$ & $x - y$\\
$symb$ & $symb$\\
\end{tabular}
"

@test latexify(M; env=:table, head=1:5) ==
raw"\begin{tabular}{ccccc}
$1$ & $2$ & $3$ & $4$ & $5$\\
$\frac{x}{y - 1}$ & $1.0$ & $\frac{3}{2}$ & $x - y$ & $symb$\\
$\frac{x}{y - 1}$ & $1.0$ & $\frac{3}{2}$ & $x - y$ & $symb$\\
\end{tabular}
"

@test latexify(M; env=:table, side=[1, 2]) ==
raw"\begin{tabular}{cccccc}
$1$ & $\frac{x}{y - 1}$ & $1.0$ & $\frac{3}{2}$ & $x - y$ & $symb$\\
$2$ & $\frac{x}{y - 1}$ & $1.0$ & $\frac{3}{2}$ & $x - y$ & $symb$\\
\end{tabular}
"

D = Dict(:a=>"x/(k+x)", :b=>"x - y")
@test latexify(D; env=:tabular) ==
raw"\begin{tabular}{cc}
$a$ & $\frac{x}{k + x}$\\
$b$ & $x - y$\\
\end{tabular}
"

@test latexify(D; env=:tabular, head=["Keys", "Values"]) ==
raw"\begin{tabular}{cc}
$Keys$ & $Values$\\
$a$ & $\frac{x}{k + x}$\\
$b$ & $x - y$\\
\end{tabular}
"
