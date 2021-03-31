using Latexify, Test

# Latexify.@generate_test latexify(:(x = [1, 2]), env=:bracket)
@test latexify(:(x = [1, 2]), env = :bracket) == replace(
raw"\[
x = \left[
\begin{array}{c}
1 \\
2 \\
\end{array}
\right]\]
", "\r\n"=>"\n")


# Latexify.@generate_test latexify([1, 2], env=:bracket)
@test latexify([1, 2], env = :bracket) == replace(
raw"\[
\left[
\begin{array}{c}
1 \\
2 \\
\end{array}
\right]\]
", "\r\n"=>"\n")