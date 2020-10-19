using Latexify
using Test


@test latexify(((1.0, 2), (3, 4)); env=:align) == 
raw"\begin{align}
1.0 =& 3 \\
2 =& 4
\end{align}
"


# @test_throws MethodError latexify(rn; bad_kwarg="should error")
