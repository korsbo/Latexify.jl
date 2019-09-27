using Latexify
using Test


module MyModule
using Latexify
struct MyType
    vec1
    vec2
end

@latexrecipe function f(t::MyType; reverse=false)
    env --> :align
    fmt := "%.2f"
    return reverse ? (t.vec2, t.vec1) : (t.vec1, t.vec2)
end

end

using .MyModule
t = MyModule.MyType([:A, :B, 3], [1, 2, 3])
t2 = MyModule.MyType([:X, :Y, :(x/y)], [1.23434534, 232423.42345, 12//33])

@test latexify(t2, fmt="%.8f") == 
raw"\begin{align}
X =& 1.23 \\
Y =& 232423.42 \\
\frac{x}{y} =& 0.36
\end{align}
"


@test latexify(t) == 
raw"\begin{align}
A =& 1 \\
B =& 2 \\
3 =& 3
\end{align}
"

@test latexify(t; reverse=true) == 
raw"\begin{align}
1 =& A \\
2 =& B \\
3 =& 3
\end{align}
"

@test latexify(t, env=:array) == 
raw"\begin{equation}
\left[
\begin{array}{cc}
A & 1 \\
B & 2 \\
3 & 3 \\
\end{array}
\right]
\end{equation}
"

@test latexify(t, env=:array, reverse=true) == 
raw"\begin{equation}
\left[
\begin{array}{cc}
1 & A \\
2 & B \\
3 & 3 \\
\end{array}
\right]
\end{equation}
"

