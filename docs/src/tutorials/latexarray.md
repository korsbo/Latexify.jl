# `latexarray`


This functions takes a 1 or 2D array and spits out a latex array environment.
For example:

```julia-repl
julia> arr = eye(Int,3)
julia> print(latexarray(arr))

\begin{equation}
\left[
\begin{array}{ccc}
1 & 0 & 0\\
0 & 1 & 0\\
0 & 0 & 1\\
\end{array}
\right]
\end{equation}
```
which renders as:

\begin{equation}
\left[
\begin{array}{ccc}
1 & 0 & 0\\\\
0 & 1 & 0\\\\
0 & 0 & 1\\\\
\end{array}
\right]
\end{equation}


`latexify()` is called for each element of the input, individually.
It therefore does not matter if the input array is of a mixed type.

```julia
arr = [1.0, 2-3im, 3//4, :(x/(k_1+x)), "e^(-k_b*t)"]
print(latexarray(arr))
```
renders as:

\begin{equation}
\left[
\begin{array}{c}
1.0\\\\
2-3\textit{i}\\\\
\frac{3}{4}\\\\
\frac{x}{k_{1} + x}\\\\
e^{- k_{b} \cdot t}\\\\
\end{array}
\right]
\end{equation}
