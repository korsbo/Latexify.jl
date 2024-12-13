using Latexify
using Markdown
using Test


#inline
@test latexify(:(x * y); env=:inline, cdot=false) == raw"$x \, y$"

@test latexify(:(x * y); env=:inline, cdot=true) == raw"$x \cdot y$"

@test latexify(:(x*(y+z)*y*(z+a)*(z+b)); env=:inline, cdot=false) ==
raw"$x \, \left( y + z \right) \, y \, \left( z + a \right) \, \left( z + b \right)$"

@test latexify(:(x*(y+z)*y*(z+a)*(z+b)); env=:inline, cdot=true) ==
raw"$x \cdot \left( y + z \right) \cdot y \cdot \left( z + a \right) \cdot \left( z + b \right)$"

# raw
@test latexify(:(x * y); env=:raw, cdot=false) == raw"x \, y"

@test latexify(:(x * y); env=:raw, cdot=true) == raw"x \cdot y"

@test latexify(:(x * (y + z) * y * (z + a) * (z + b)); env=:raw, cdot=false) ==
raw"x \, \left( y + z \right) \, y \, \left( z + a \right) \, \left( z + b \right)"

@test latexify(:(x * (y + z) * y * (z + a) * (z + b)); env=:raw, cdot=true) ==
raw"x \cdot \left( y + z \right) \cdot y \cdot \left( z + a \right) \cdot \left( z + b \right)"

# array
@test latexify( [:(x*y), :(x*(y+z)*y*(z+a)*(z+b))]; env=:equation, transpose=true, cdot=false) == replace(
raw"\begin{equation}
\left[
\begin{array}{cc}
x \, y & x \, \left( y + z \right) \, y \, \left( z + a \right) \, \left( z + b \right) \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")

@test latexify( [:(x*y), :(x*(y+z)*y*(z+a)*(z+b))]; env=:equation, transpose=true, cdot=true) == replace(
raw"\begin{equation}
\left[
\begin{array}{cc}
x \cdot y & x \cdot \left( y + z \right) \cdot y \cdot \left( z + a \right) \cdot \left( z + b \right) \\
\end{array}
\right]
\end{equation}
", "\r\n"=>"\n")




# mdtable
arr = ["x*(y-1)", 1.0, 3*2, :(x-2y), :symb]

@test latexify(arr; env=:mdtable, cdot=false) ==
Markdown.md"| $x \, \left( y - 1 \right)$ |
| -------------------------:|
|                     $1.0$ |
|                       $6$ |
|              $x - 2 \, y$ |
|                    $symb$ |
"

@test latexify(arr; env=:mdtable, cdot=true) ==
Markdown.md"| $x \cdot \left( y - 1 \right)$ |
| ------------------------------:|
|                          $1.0$ |
|                            $6$ |
|                $x - 2 \cdot y$ |
|                         $symb$ |
"




