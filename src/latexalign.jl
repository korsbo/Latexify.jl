
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
function latexalign end

function latexalign(arr::AbstractMatrix; separator=" =& ", double_linebreak=false, starred=false, rows=:all, kwargs...)
    eol = double_linebreak ? " \\\\\\\\\n" : " \\\\\n"
    arr = latexraw(arr; kwargs...)
    separator isa String && (separator = fill(separator, size(arr)[1]))

    str = "\\begin{align$(starred ? "*" : "")}\n"
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
    str *= "\\end{align$(starred ? "*" : "")}\n"
    latexstr = LaTeXString(str)
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end

function latexalign(lhs::AbstractArray, rhs::AbstractArray; kwargs...)
    return latexalign(hcat(lhs, rhs); kwargs...)
end

function latexalign(lhs::Tuple, rhs::Tuple; kwargs...)
    return latexalign(hcat(collect(lhs), collect(rhs)); kwargs...)
end

latexalign(args::Tuple...; kwargs...) = latexalign(hcat([collect(i) for i in args]...); kwargs...)

latexalign(arg::Tuple; kwargs...) = latexalign(hcat([collect(i) for i in arg]...); kwargs...)

function latexalign(nested::AbstractVector{AbstractVector}; kwargs...)
    return latexalign(hcat(nested...); kwargs...)
end

function latexalign(d::AbstractDict; kwargs...)
    latexalign(collect(keys(d)), collect(values(d)); kwargs...)
end

"""
    latexalign(vec::AbstractVector)

Go through the elements, split at any = sign, pass on as a matrix.
"""
function latexalign(vec::AbstractVector; kwargs...)
    lvec = latexraw(vec; kwargs...)
    ## turn the array into a matrix
    lmat = hcat(split.(lvec, " = ")...)
    ## turn the matrix ito arrays of left-hand-side, right-hand-side.
    larr = [lmat[i,:] for i in 1:size(lmat, 1)]
    length(larr) < 2 && error("Invalid intput to latexalign().")
    return latexalign( hcat(larr...) ; kwargs...)
end
