using Latexify
using Test


module MyModule
using Latexify
struct MyType
    vec1
    vec2
end

my_reverse(x) = x[end:-1:1]

@latexrecipe function f(t::MyType; reverse=false)
    env --> :align
    fmt := "%.2f"
    return reverse ? (t.vec2, t.vec1) : (t.vec1, t.vec2)
end

struct MyVec
    vec::AbstractVector
end

@latexrecipe function f(v::MyVec; reverse=false)
    env --> :array
    fmt := "%.2f"
    return reverse ? v.vec[end, -1, 1] : v.vec
end

struct MyTup
    tup::Tuple
end

@latexrecipe function f(v::MyTup; reverse=false)
    env --> :array
    fmt := "%.2f"
    return reverse ? my_reverse(v.tup) : v.tup
end

struct MyDoubleTup
    tup1::Tuple
    tup2::Tuple
end

@latexrecipe function f(t::MyDoubleTup)
    return t.tup1, t.tup2
end

end

using .MyModule
t = MyModule.MyType([:A, :B, 3], [1, 2, 3])
t2 = MyModule.MyType([:X, :Y, :(x/y)], Number[1.23434534, 232423.42345, 12//33])


@test latexify(t2, fmt="%.8f") == 
raw"\begin{align}
X =& 1.23 \\
Y =& 232423.42 \\
\frac{x}{y} =& \frac{4}{11}
\end{align}
"

@test latexify(t) == 
raw"\begin{align}
A =& 1.00 \\
B =& 2.00 \\
3.00 =& 3.00
\end{align}
"

@test latexify(t; reverse=true) == 
raw"\begin{align}
1.00 =& A \\
2.00 =& B \\
3.00 =& 3.00
\end{align}
"

@test latexify(t; env=:array) == 
raw"\begin{equation}
\left[
\begin{array}{cc}
A & 1.00 \\
B & 2.00 \\
3.00 & 3.00 \\
\end{array}
\right]
\end{equation}
"

@test latexify(t; env=:array, reverse=true) == 
raw"\begin{equation}
\left[
\begin{array}{cc}
1.00 & A \\
2.00 & B \\
3.00 & 3.00 \\
\end{array}
\right]
\end{equation}
"


vec = MyModule.MyVec([1., 2.])
@test latexify(vec, transpose=true) == 
raw"\begin{equation}
\left[
\begin{array}{cc}
1.00 & 2.00 \\
\end{array}
\right]
\end{equation}
"

tup = MyModule.MyTup((1., 2.))

@test latexify(tup, transpose=true) == 
raw"\begin{equation}
\left[
\begin{array}{cc}
1.00 & 2.00 \\
\end{array}
\right]
\end{equation}
"

@test latexify(tup, reverse=true, transpose=true) == 
raw"\begin{equation}
\left[
\begin{array}{cc}
2.00 & 1.00 \\
\end{array}
\right]
\end{equation}
"



tup2 = MyModule.MyDoubleTup((1., 3), (2., 4.))
@test latexify(tup2) == 
raw"\begin{equation}
\left[
\begin{array}{cc}
1.0 & 2.0 \\
3 & 4.0 \\
\end{array}
\right]
\end{equation}
"


