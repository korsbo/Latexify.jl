using Latexify
using Test


@test latexify(((1.0, 2), (3, 4)); env=:align) == 
raw"\begin{align}
1.0 =& 3 \\
2 =& 4
\end{align}
"

@test latexify(((1.0, 2), (3, 4)); separator = [" =& ", " ∈& "], env = :align) == 
raw"\begin{align}
1.0 =& 3 \\
2 ∈& 4
\end{align}
"


lhs = [:a, :b]
rhs = [1, 2]

@test latexify(lhs, rhs; env = :aligned) == replace(
raw"\[
\begin{aligned}
a =& 1 \\
b =& 2
\end{aligned}
\]
", "\r\n"=>"\n")

# @test_throws MethodError latexify(rn; bad_kwarg="should error")
