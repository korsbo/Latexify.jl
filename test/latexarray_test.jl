using Latexify
using Test

arr = [1 2; 3 4]

@test latexify(:([x])) == replace(
raw"$\left[
\begin{array}{c}
x \\
\end{array}
\right]$", "\r\n"=>"\n")

@test latexify(arr) == replace(
raw"\begin{equation}
\left[
\begin{array}{cc}
1 & 2 \\
3 & 4 \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")

# Latexify.@generate_test latexify(arr; env=:inline)
@test latexify(arr; env = :inline) == replace(
raw"$\left[
\begin{array}{cc}
1 & 2 \\
3 & 4 \\
\end{array}
\right]$", "\r\n"=>"\n")

# Latexify.@generate_test latexify(arr; env=:equation)
@test latexify(arr; env = :equation) == replace(
raw"\begin{equation}
\left[
\begin{array}{cc}
1 & 2 \\
3 & 4 \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")

# Latexify.@generate_test latexify(arr; env=:bracket)
@test latexify(arr; env = :bracket) == replace(
raw"\[
\left[
\begin{array}{cc}
1 & 2 \\
3 & 4 \\
\end{array}
\right]\]
", "\r\n"=>"\n")

# Latexify.@generate_test latexify(arr; env=:raw)
@test latexify(arr; env = :raw) == replace(
raw"\left[
\begin{array}{cc}
1 & 2 \\
3 & 4 \\
\end{array}
\right]", "\r\n"=>"\n")

arr = [1,2,:(x/y),4]

@test latexify(arr) == replace(
raw"\begin{equation}
\left[
\begin{array}{c}
1 \\
2 \\
\frac{x}{y} \\
4 \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")

@test latexify(arr; transpose=true) == replace(
raw"\begin{equation}
\left[
\begin{array}{cccc}
1 & 2 & \frac{x}{y} & 4 \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")

@test latexify((1.0, 2), (3, 4)) == replace(
raw"\begin{equation}
\left[
\begin{array}{cc}
1.0 & 3 \\
2 & 4 \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")

@test latexify(((1.0, 2), (3, 4))) == replace(
raw"\begin{equation}
\left[
\begin{array}{cc}
1.0 & 3 \\
2 & 4 \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")


@test latexify(:(x = [1 2] * [1, 2] * [1 2; 3 4])) == replace(
raw"$x = \left[
\begin{array}{cc}
1 & 2 \\
\end{array}
\right] \cdot \left[
\begin{array}{c}
1 \\
2 \\
\end{array}
\right] \cdot \left[
\begin{array}{cc}
1 & 2 \\
3 & 4 \\
\end{array}
\right]$", "\r\n"=>"\n")


@test latexify(:(x = $arr)) == replace(
raw"$x = \left[
\begin{array}{c}
1 \\
2 \\
\frac{x}{y} \\
4 \\
\end{array}
\right]$", "\r\n"=>"\n")


