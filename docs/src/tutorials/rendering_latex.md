# A note on rendering ``\LaTeX``
Using the `print` function on a latexified object prints text which is suitable for copy-pasting into a ``\LaTeX`` document.

However, it is often also useful to be able to render the equation inside the document that one is using to develop code. The Julia REPL does not support this, but IJulia does.
So, inside a Jupyter document (or if you are running Atom with Hydrogen), you can render ``\LaTeX`` using

```julia
display("text/latex", x)
```
where `x` is a latex-formatted string.

This requires `x` to specify a ``\LaTeX`` environment. `latexalign` and `latexarray` already does this, but if you want to render the result of `latexify` you must supply an environment (for example `"\$ $x \$"`).
