using DataFrames: DataFrame
using Latexify
using Test
d = DataFrame(A = 11:13, B = [:X, :Y, :Z])

@test_broken latexify(d; env=:table, side=1:3, latex=false) == replace(
raw"\begin{tabular}{ccc}
 & A & B \\
1 & 11 & X \\
2 & 12 & Y \\
3 & 13 & Z
\end{tabular}", "\r\n"=>"\n")

# Latexify.@generate_test latexify([1.]; env=:table)
@test_broken latexify([1.0]; env = :table) == replace(
raw"\begin{tabular}{c}
$1.0$\\
\end{tabular}
", "\r\n"=>"\n")

arr = ["x/(y-1)", 1.0, 3//2, :(x-y), :symb]

M = (vcat(reduce(hcat, arr), reduce(hcat, arr)))

head = ["col$i" for i in 1:size(M, 2)]
side = ["row$i" for i in 1:size(M, 1)]


# Latexify.@generate_test latexify(M; env=:table, head=1:2, adjustment=:l, latex=false, transpose=true)

@test latexify(M; env = :table, head = 1:2, adjustment = :l, latex = false, transpose = true) == replace(
raw"\begin{tabular}{ll}
1 & 2 \\
\frac{x}{y - 1} & \frac{x}{y - 1} \\
1.0 & 1.0 \\
\frac{3}{2} & \frac{3}{2} \\
x - y & x - y \\
symb & symb
\end{tabular}", "\r\n"=>"\n")


@test latexify(M; env = :table, head = 1:5, adjustment = :l, latex = true, transpose = false) == replace(
raw"\begin{tabular}{lllll}
1 & 2 & 3 & 4 & 5 \\
$\frac{x}{y - 1}$ & $1.0$ & $\frac{3}{2}$ & $x - y$ & $symb$ \\
$\frac{x}{y - 1}$ & $1.0$ & $\frac{3}{2}$ & $x - y$ & $symb$
\end{tabular}", "\r\n"=>"\n")

# Latexify.@generate_test latexify(M; env=:table, head=1:2, adjustment=:l, latex=false, transpose=true) 

@test latexify(M; env = :table, head = 1:2, adjustment = :l, latex = false, transpose = true) == replace(
raw"\begin{tabular}{ll}
1 & 2 \\
\frac{x}{y - 1} & \frac{x}{y - 1} \\
1.0 & 1.0 \\
\frac{3}{2} & \frac{3}{2} \\
x - y & x - y \\
symb & symb
\end{tabular}", "\r\n"=>"\n")

# Latexify.@generate_test latexify(M; env=:table, head=1:2, adjustment=:l, latex=false, transpose=true) 

@test latexify(M; env = :table, head = 1:2, adjustment = :l, latex = false, transpose = true) == replace(
raw"\begin{tabular}{ll}
1 & 2 \\
\frac{x}{y - 1} & \frac{x}{y - 1} \\
1.0 & 1.0 \\
\frac{3}{2} & \frac{3}{2} \\
x - y & x - y \\
symb & symb
\end{tabular}", "\r\n"=>"\n")


@test latexify(M; env=:table, head=1:2, adjustment=:l, transpose=true) == replace(
raw"\begin{tabular}{ll}
1 & 2 \\
$\frac{x}{y - 1}$ & $\frac{x}{y - 1}$ \\
$1.0$ & $1.0$ \\
$\frac{3}{2}$ & $\frac{3}{2}$ \\
$x - y$ & $x - y$ \\
$symb$ & $symb$
\end{tabular}", "\r\n"=>"\n")

@test latexify(M; env=:table, head=1:5) == replace(
raw"\begin{tabular}{ccccc}
1 & 2 & 3 & 4 & 5 \\
$\frac{x}{y - 1}$ & $1.0$ & $\frac{3}{2}$ & $x - y$ & $symb$ \\
$\frac{x}{y - 1}$ & $1.0$ & $\frac{3}{2}$ & $x - y$ & $symb$
\end{tabular}", "\r\n"=>"\n")

@test latexify(M; env=:table, side=[1, 2]) == replace(
raw"\begin{tabular}{cccccc}
1 & $\frac{x}{y - 1}$ & $1.0$ & $\frac{3}{2}$ & $x - y$ & $symb$ \\
2 & $\frac{x}{y - 1}$ & $1.0$ & $\frac{3}{2}$ & $x - y$ & $symb$
\end{tabular}", "\r\n"=>"\n")

@test latexify(M; env=:table, booktabs=true) == replace(
raw"\begin{tabular}{ccccc}
\toprule
$\frac{x}{y - 1}$ & $1.0$ & $\frac{3}{2}$ & $x - y$ & $symb$ \\
$\frac{x}{y - 1}$ & $1.0$ & $\frac{3}{2}$ & $x - y$ & $symb$
\bottomrule
\end{tabular}", "\r\n"=>"\n")

@test_broken latexify(M; env=:table, head=1:5, booktabs=true) == replace(
raw"\begin{tabular}{ccccc}
\toprule
1 & 2 & 3 & 4 & 5 \\
\midrule
$\frac{x}{y - 1}$ & $1.0$ & $\frac{3}{2}$ & $x - y$ & $symb$ \\
$\frac{x}{y - 1}$ & $1.0$ & $\frac{3}{2}$ & $x - y$ & $symb$
\bottomrule
\end{tabular}", "\r\n"=>"\n")

D = Dict(:a=>"x/(k+x)", :b=>"x - y")
@test latexify(D; env=:tabular) == replace(
raw"\begin{tabular}{cc}
$a$ & $\frac{x}{k + x}$ \\
$b$ & $x - y$
\end{tabular}", "\r\n"=>"\n")

@test latexify(D; env=:tabular, head=["Keys", "Values"]) == replace(
raw"\begin{tabular}{cc}
Keys & Values \\
$a$ & $\frac{x}{k + x}$ \\
$b$ & $x - y$
\end{tabular}", "\r\n"=>"\n")
