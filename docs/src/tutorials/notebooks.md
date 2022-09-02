# Notebook workflows

When working in a notebook (These tips assume Pluto, but will apply at least
in part to other similar environments), there's a number of options to
incorporate latexifications.

As a first principle, any cell that returns a single `LaTeXString` (or a
string surrounded by `$` in general) will be displayed as math:

```julia
latexify(35e-9; fmt=FancyNumberFormatter())
```
```math
3.5 \cdot 10^{-8}
```

```julia
@latexify (3x + 45)/2y
```
```math
\frac{3 \cdot x + 45}{2 \cdot y}
```

There's a visual bug in Pluto where any expression looking like an assignment
is printed with extra unnecessary information. To avoid this, encase such in a `begin/end` block:

```julia
begin
    @latexrun x = 125
end
```
```math
x = 125
```

```julia
begin
    @latexdefine y = x
end
```
```math
y = x = 125
```

One very nice workflow is to use `Markdown.parse` to embed latexifications in
markdown text. Note that `md""` does
*not* work very well for this, as the
dollar signs signifying math mode will
clash with those signifying
interpolation. In `parse`, you need to
escape special characters like
backslashes, but since we're using
`Latexify` we don't need to write very
many of those anyway.

```julia
Markdown.parse("""
## Results

With the previously calculated 
$(@latexdefine x), we can use
$(@latexify x = v*t) to calculate
$(@latexrun v = x/10), giving a final
velocity of $(latexify(v)).

If we want more manual control, we can
combine manual dollar signs with
`env=:raw`: \$ \hat{v} =
$(latexify(v, env=:raw))\;\mathrm{m}/\mathrm{s} \$
""")
```

## Results

With the previously calculated 
$x = 125$, we can use $x = v \cdot t$
to calculate $v = \frac{x}{10}$,
giving a final velocity of $12.5$.

If we want more manual control, we can combine manual dollar signs with `env=:raw`: $ \hat{v} = 12.5\;\mathrm{m}/\mathrm{s} $
