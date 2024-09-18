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
    env --> :equation
    fmt := "%.2f"
    return reverse ? v.vec[end, -1, 1] : v.vec
end

struct MyTup
    tup::Tuple
end

@latexrecipe function f(v::MyTup; reverse=false)
    env --> :equation
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

struct MyFloat
    x::Float64
end

@latexrecipe function f(m::MyFloat)
    fmt --> "%.6e"
    return m.x*m.x
end

@latexrecipe function f(vec::Vector{T}) where T <: MyFloat
    fmt --> "%.4e"
    return [myfloat.x for myfloat in vec]
end

struct MyDoubleVec{T}
    vec1::AbstractVector{T}
    vec2::AbstractVector{T}
end

@latexrecipe function f(vec::MyDoubleVec{T}) where T <: MyFloat
    return [myfloat.x for myfloat in vec.vec1], [myfloat.x for myfloat in vec.vec2]
end

struct MySum
    x
    y
end
@latexrecipe function f(s::MySum)
    operation --> :+
    return :($(s.x) + $(s.y))
end

end

using .MyModule
t = MyModule.MyType([:A, :B, 3.], [1., 2, 3])
t2 = MyModule.MyType([:X, :Y, :(x/y)], Number[1.23434534, 232423.42345, 12//33])

m = MyModule.MyFloat(3)
@test latexify(m) == raw"$9.000000e+00$"
@test latexify(:(2+$m)) == raw"$2 + 9.000000e+00$"

vec = [MyModule.MyFloat(x) for x in 1:4]
@test latexify(vec; transpose=true) == replace(
raw"\begin{equation}
\left[
\begin{array}{cccc}
1.0000e+00 & 2.0000e+00 & 3.0000e+00 & 4.0000e+00 \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")

double_vec = MyModule.MyDoubleVec([MyModule.MyFloat(x) for x in 1:4], [MyModule.MyFloat(x) for x in 8:11])
@test latexify(double_vec) == replace(
raw"\begin{equation}
\left[
\begin{array}{cc}
1.0 & 8.0 \\
2.0 & 9.0 \\
3.0 & 10.0 \\
4.0 & 11.0 \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")



@test latexify(t2, fmt="%.8f") == replace(
raw"\begin{align}
X &= 1.23 \\
Y &= 232423.42 \\
\frac{x}{y} &= \frac{4.00}{11.00}
\end{align}
", "\r\n"=>"\n")

@test latexify(t) == replace(
raw"\begin{align}
A &= 1.00 \\
B &= 2.00 \\
3.00 &= 3.00
\end{align}
", "\r\n"=>"\n")

@test latexify(t; reverse=true) == replace(
raw"\begin{align}
1.00 &= A \\
2.00 &= B \\
3.00 &= 3.00
\end{align}
", "\r\n"=>"\n")

@test latexify(t; env=:equation) == replace(
raw"\begin{equation}
\left[
\begin{array}{cc}
A & 1.00 \\
B & 2.00 \\
3.00 & 3.00 \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")

@test latexify(t; env=:equation, reverse=true) == replace(
raw"\begin{equation}
\left[
\begin{array}{cc}
1.00 & A \\
2.00 & B \\
3.00 & 3.00 \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")


vec = MyModule.MyVec([1., 2.])
@test latexify(vec, transpose=true) == replace(
raw"\begin{equation}
\left[
\begin{array}{cc}
1.00 & 2.00 \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")

tup = MyModule.MyTup((1., 2.))

@test latexify(tup, transpose=true) == replace(
raw"\begin{equation}
\left[
\begin{array}{cc}
1.00 & 2.00 \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")

@test latexify(tup, reverse=true, transpose=true) == replace(
raw"\begin{equation}
\left[
\begin{array}{cc}
2.00 & 1.00 \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")



tup2 = MyModule.MyDoubleTup((1., 3), (2., 4.))
@test latexify(tup2) == replace(
raw"\begin{equation}
\left[
\begin{array}{cc}
1.0 & 2.0 \\
3 & 4.0 \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")

sum1 = MyModule.MySum(3, 4)
@test latexify(:(2 + $(sum1)^2)) == raw"$2 + \left( 3 + 4 \right)^{2}$"
@test latexify(:(2 - $(sum1))) == raw"$2 - \left( 3 + 4 \right)$"

struct NothingThing end
@test_throws Latexify.NoRecipeException(NothingThing) latexify(NothingThing())
@latexrecipe function f(::NothingThing; keyword=nothing)
    if isnothing(keyword)
        return L"a"
    elseif keyword == :nothing
        return L"b"
    end
end
@test latexify(NothingThing()) == raw"$a$"
@test latexify(NothingThing(); keyword=nothing) == raw"$a$"
@test latexify(NothingThing(); keyword=:nothing) == raw"$b$"


