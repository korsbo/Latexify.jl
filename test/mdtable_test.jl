arr = ["x/(y-1)", 1.0, 3//2, :(x-y), :symb]

M = vcat(hcat(arr...), hcat(arr...))
head = ["col$i" for i in 1:size(M, 2)]
side = ["row$i" for i in 1:size(M, 1)]


@test mdtable(arr) == Markdown.md"
| $\frac{x}{y - 1}$ |
| -----------------:|
|             $1.0$ |
|     $\frac{3}{2}$ |
|           $x - y$ |
|            $symb$ |
"

@test mdtable(arr; head = ["head"]) == Markdown.md"
|              head |
| -----------------:|
| $\frac{x}{y - 1}$ |
|             $1.0$ |
|     $\frac{3}{2}$ |
|           $x - y$ |
|            $symb$ |
"

@test mdtable(arr; head = ["head"], side=1:length(arr)) == Markdown.md"
|   . |              head |
| ---:| -----------------:|
|   1 | $\frac{x}{y - 1}$ |
|   2 |             $1.0$ |
|   3 |     $\frac{3}{2}$ |
|   4 |           $x - y$ |
|   5 |            $symb$ |
"

@test mdtable(arr; head = ["head"], side=1:length(arr)+1) == Markdown.md"
|   1 |              head |
| ---:| -----------------:|
|   2 | $\frac{x}{y - 1}$ |
|   3 |             $1.0$ |
|   4 |     $\frac{3}{2}$ |
|   5 |           $x - y$ |
|   6 |            $symb$ |
"

@test mdtable(arr, arr) == Markdown.md"
| $\frac{x}{y - 1}$ | $\frac{x}{y - 1}$ |
| -----------------:| -----------------:|
|             $1.0$ |             $1.0$ |
|     $\frac{3}{2}$ |     $\frac{3}{2}$ |
|           $x - y$ |           $x - y$ |
|            $symb$ |            $symb$ |
"

@test mdtable(arr, arr; head = ["col1", "col2"]) == Markdown.md"
|              col1 |              col2 |
| -----------------:| -----------------:|
| $\frac{x}{y - 1}$ | $\frac{x}{y - 1}$ |
|             $1.0$ |             $1.0$ |
|     $\frac{3}{2}$ |     $\frac{3}{2}$ |
|           $x - y$ |           $x - y$ |
|            $symb$ |            $symb$ |
"

@test mdtable(M) == Markdown.md"
| $\frac{x}{y - 1}$ | $1.0$ | $\frac{3}{2}$ | $x - y$ | $symb$ |
| -----------------:| -----:| -------------:| -------:| ------:|
| $\frac{x}{y - 1}$ | $1.0$ | $\frac{3}{2}$ | $x - y$ | $symb$ |
"

@test mdtable(M, head=head) == Markdown.md"
|              col1 |  col2 |          col3 |    col4 |   col5 |
| -----------------:| -----:| -------------:| -------:| ------:|
| $\frac{x}{y - 1}$ | $1.0$ | $\frac{3}{2}$ | $x - y$ | $symb$ |
| $\frac{x}{y - 1}$ | $1.0$ | $\frac{3}{2}$ | $x - y$ | $symb$ |
"

@test mdtable(M, head=head, side=side) == Markdown.md"
|    . |              col1 |  col2 |          col3 |    col4 |   col5 |
| ----:| -----------------:| -----:| -------------:| -------:| ------:|
| row1 | $\frac{x}{y - 1}$ | $1.0$ | $\frac{3}{2}$ | $x - y$ | $symb$ |
| row2 | $\frac{x}{y - 1}$ | $1.0$ | $\frac{3}{2}$ | $x - y$ | $symb$ |
"

@test mdtable(M, head=side, side=head, transpose=true) == Markdown.md"
|    . |              row1 |              row2 |
| ----:| -----------------:| -----------------:|
| col1 | $\frac{x}{y - 1}$ | $\frac{x}{y - 1}$ |
| col2 |             $1.0$ |             $1.0$ |
| col3 |     $\frac{3}{2}$ |     $\frac{3}{2}$ |
| col4 |           $x - y$ |           $x - y$ |
| col5 |            $symb$ |            $symb$ |
"

@test_throws MethodError mdtable(M; bad_kwarg="should error")
