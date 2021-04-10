
@doc doc"""
    latexalign()
Generate a ``LaTeX`` align environment from an input.

# Examples
## use with arrays

```julia
lhs = [:(dx/dt), :(dy/dt), :(dz/dt)]
rhs = [:(y-x), :(x*z-y), :(-z)]
latexalign(lhs, rhs)
```

```LaTeX
\begin{align}
\frac{dx}{dt} =& y - x \\\\
\frac{dy}{dt} =& x \cdot z - y \\\\
\frac{dz}{dt} =& - z \\\\
\end{align}
```

## use with ParameterizedFunction

```julia-repl
julia> using DifferentialEquations
julia> ode = @ode_def foldChangeDetection begin
    dm = r_m * (i - m)
    dy = r_y * (p_y * i/m - y)
end i r_m r_y p_y

julia> latexalign(ode)
```
```LaTeX
\begin{align}
\frac{dm}{dt} =& r_{m} \cdot \left( i - m \right) \\\\
\frac{dy}{dt} =& r_{y} \cdot \left( \frac{p_{y} \cdot i}{m} - y \right) \\\\
\end{align}
```

"""
latexalign(args...; kwargs...) = latexify(args...; kwargs..., env=:align)

function _latexalign(arr::AbstractMatrix; separator=" =& ", double_linebreak=false, starred=false, rows=:all, aligned=false, kwargs...)
    eol = double_linebreak ? " \\\\\\\\\n" : " \\\\\n"
    arr = latexraw.(arr; kwargs...)
    separator isa String && (separator = fill(separator, size(arr)[1]))
    str = ""
    if aligned
        str *= "\\begin{aligned}\n"
    else
        str *= "\\begin{align$(starred ? "*" : "")}\n"
    end
    if rows == :all
        iterate_rows = 1:(size(arr)[1])
    else
        iterate_rows = rows
    end

    for i in iterate_rows
        if i != last(iterate_rows)
            str *= join(arr[i,:], separator[i]) * eol
        else
            str *= join(arr[i,:], separator[i]) * "\n"
        end
    end
    if aligned
        str *= "\\end{aligned}\n"
    else
        str *= "\\end{align$(starred ? "*" : "")}\n"
    end
    latexstr = LaTeXString(str)
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end

function _latexalign(lhs::AbstractArray, rhs::AbstractArray; kwargs...)
    return latexalign(hcat(lhs, rhs); kwargs...)
end

function _latexalign(lhs::Tuple, rhs::Tuple; kwargs...)
    return latexalign(hcat(collect(lhs), collect(rhs)); kwargs...)
end

_latexalign(args::Tuple...; kwargs...) = latexalign(reduce(hcat, [collect(i) for i in args]); kwargs...)

_latexalign(arg::Tuple; kwargs...) = latexalign(reduce(hcat, [collect(i) for i in arg]); kwargs...)

function _latexalign(nested::AbstractVector{AbstractVector}; kwargs...)
    return latexalign(reduce(hcat, nested); kwargs...)
end

function _latexalign(d::AbstractDict; kwargs...)
    latexalign(collect(keys(d)), collect(values(d)); kwargs...)
end

"""
    _latexalign(vec::AbstractVector)

Go through the elements, split at any = sign, pass on as a matrix.
"""
function _latexalign(vec::AbstractVector; kwargs...)
    lvec = latexraw.(vec; kwargs...)
    ## turn the array into a matrix
    lmat = reduce(hcat, split.(lvec, " = "))
    ## turn the matrix ito arrays of left-hand-side, right-hand-side.
    larr = [lmat[i,:] for i in 1:size(lmat, 1)]
    length(larr) < 2 && error("Invalid intput to _latexalign().")
    return latexalign( reduce(hcat, larr) ; kwargs...)
end
