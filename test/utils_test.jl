name = tempname()

Latexify._writetex(L"x \cdot y"; name=name)
tex = open("$(name).tex") do f
    read(f, String)
end
@test tex == raw"""
\documentclass[varwidth=100cm]{standalone}
\usepackage{amssymb}
\usepackage{amsmath}

\begin{document}
{
    \Large
    $x \cdot y$
}
\end{document}
"""

Latexify._writetex(L"\ce{ 2 P_1 &<=>[k_{+}][k_{-}] D_{1}}"; name=name)
tex = open("$(name).tex") do f
    read(f, String)
end
@test tex == raw"""
\documentclass[varwidth=100cm]{standalone}
\usepackage{amssymb}
\usepackage{amsmath}
\usepackage{mhchem}
\begin{document}
{
    \Large
    $\ce{ 2 P_1 &<=>[k_{+}][k_{-}] D_{1}}$
}
\end{document}
"""
