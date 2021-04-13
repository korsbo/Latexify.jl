@doc doc"""
    mdtable(array; latex=true, head=[], side=[], transpose=false)

Latexify the input and output a markdown-formatted table.

```julia
julia> using Latexify
juila> copy_to_clipboard(true)
julia> M = ["x/y" 1//2
            "p_m" "e^2"]
julia> mdtable(M)
```

| $\frac{x}{y}$ | $\frac{1}{2}$ |
| -------------:| -------------:|
|       $p_{m}$ |       $e^{2}$ |

```julia
julia> head = ["Column 1", "Column 2"]
julia> side = ["Row 1", "Row 2"]
julia> mdtable(M; head=head, side=side)
```

|     . |      Column 1 |      Column 2 |
| -----:| -------------:| -------------:|
| Row 1 | $\frac{x}{y}$ | $\frac{1}{2}$ |
| Row 2 |       $p_{m}$ |       $e^{2}$ |


The value in the top right corner can be set if you let the `side` vector be one element
larger than the number of rows of your input:

```julia
julia> side = ["Corner", "Row 1", "Row 2"]
julia> mdtable(M; head=head, side=side)
```

| Corner |      Column 1 |      Column 2 |
| ------:| -------------:| -------------:|
|  Row 1 | $\frac{x}{y}$ | $\frac{1}{2}$ |
|  Row 2 |       $p_{m}$ |       $e^{2}$ |


The `head` and `side` vectors are not latexifed, but you can easily do this yourself:

```julia
julia> head = ["p_1", "p_2"]
julia> mdtable(M; head=latexinline(head))
```

|       $p_{1}$ |       $p_{2}$ |
| -------------:| -------------:|
| $\frac{x}{y}$ | $\frac{1}{2}$ |
|       $p_{m}$ |       $e^{2}$ |
"""
function mdtable end

function mdtable(M::AbstractMatrix; latex::Bool=true, escape_underscores=false, head=[], side=[], transpose=false, kwargs...)
    transpose && (M = permutedims(M, [2,1]))
    if latex
        M = _latexinline.(M; kwargs...)
    elseif haskey(kwargs, :fmt)
        formatter = kwargs[:fmt] isa String ? PrintfNumberFormatter(kwargs[:fmt]) : kwargs[:fmt]
        M = map(x -> x isa Number ? formatter(x) : x, M)
    end

    if !isempty(head)
        M = vcat(safereduce(hcat, head), M)
        @assert length(head) == size(M, 2) "The length of the head does not match the shape of the input matrix."
    end
    if !isempty(side)
        length(side) == size(M, 1) - 1 && (side = [LaTeXString("∘"); side])
        @assert length(side) == size(M, 1) "The length of the side does not match the shape of the input matrix."
        M = hcat(side, M)
    end


    t = "| " * join(M[1,:], " | ") * " |\n"
    size(M, 1) > 1 && (t *= "| ---  "^(size(M,2)-1) * "| --- |\n")
    for i in 2:size(M,1)
        t *= "| " * join(M[i,:], " | ") * " |\n"
    end

    escape_underscores && (t = replace(t, "_"=>"\\_"))
    t = Markdown.parse(t)
    COPY_TO_CLIPBOARD && clipboard(t)
    return t
end

mdtable(v::AbstractArray; kwargs...) = mdtable(reshape(v, (length(v), 1)); kwargs...)
mdtable(v::AbstractArray...; kwargs...) = mdtable(safereduce(hcat, v); kwargs...)
mdtable(d::AbstractDict; kwargs...) = mdtable(collect(keys(d)), collect(values(d)); kwargs...)
mdtable(arg::Tuple; kwargs...) = mdtable(safereduce(hcat, [collect(i) for i in arg]); kwargs...)
