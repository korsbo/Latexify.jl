using Latexify
# Latexify.set_default(; render=true)
using Test

@test latexify(((1.0, 2), (3, 4)); env=:align) == replace(
raw"\begin{align}
1.0 =& 3 \\
2 =& 4
\end{align}
", "\r\n"=>"\n")

@test latexify(((1.0, 2), (3, 4)); separator = [" =& ", " ∈& "], env = :align) == replace(
raw"\begin{align}
1.0 =& 3 \\
2 ∈& 4
\end{align}
", "\r\n"=>"\n")

lhs = [:a, :b]
rhs = [1, 2]

@test latexify(lhs, rhs; env = :bracket) == replace(
raw"\[
\begin{aligned}
a =& 1 \\
b =& 2
\end{aligned}
\]", "\r\n"=>"\n")

@test latexify(["a=1"], env = :align) == replace(
raw"\begin{align}
a =& 1
\end{align}
", "\r\n"=>"\n")

@test latexify(["a=1" ,"b=2", "c=x/y"], env = :align) == raw"\begin{align}
a =& 1 \\
b =& 2 \\
c =& \frac{x}{y}
\end{align}
"