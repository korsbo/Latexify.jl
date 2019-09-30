using Latexify
using Test

arr = [1 2; 3 4]

@test latexify(arr) ==
raw"\begin{equation}
\left[
\begin{array}{cc}
1 & 2 \\
3 & 4 \\
\end{array}
\right]
\end{equation}
"


arr = [1,2,:(x/y),4]

@test latexify(arr) ==
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
"

@test latexify(arr; transpose=true) == 
raw"\begin{equation}
\left[
\begin{array}{cccc}
1 & 2 & \frac{x}{y} & 4 \\
\end{array}
\right]
\end{equation}
"

@test latexify((1.0, 2), (3, 4)) ==
raw"\begin{equation}
\left[
\begin{array}{cc}
1.0 & 3 \\
2 & 4 \\
\end{array}
\right]
\end{equation}
"

@test latexify(((1.0, 2), (3, 4))) ==
raw"\begin{equation}
\left[
\begin{array}{cc}
1.0 & 3 \\
2 & 4 \\
\end{array}
\right]
\end{equation}
"
