using SparseArrays

x = sparse([1,2,3],[1,3,2],[0,1,2])
@test latexraw(x) == replace(raw"""\left[
\begin{array}{ccc}
0 & 0 & 0 \\
0 & 0 & 1 \\
0 & 2 & 0 \\
\end{array}
\right]""", "\r\n"=>"\n")

