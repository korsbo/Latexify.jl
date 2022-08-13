using SymEngine

@vars x y
symExpr = x + x + x*y*y
@test latexraw(symExpr) == "2 \\cdot x + x \\cdot y^{2}"
