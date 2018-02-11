doc"""
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

function latexalign(arr::AbstractMatrix; separator=" =& ")
    (rows, columns) = size(arr)
    arr = latexraw(arr)
    str = "\\begin{align}\n"
    for i in 1:rows
        str *= join(arr[i,:], separator) * " \\\\ \n"
    end
    str *= "\\end{align}\n"
    latexstr = LaTeXString(str)
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end

function latexalign(lhs::AbstractArray, rhs::AbstractArray)
    return latexalign(hcat(lhs, rhs))
end

function latexalign(nested::AbstractVector{AbstractVector})
    return latexalign(hcat(nested...))
end

"""
    latexalign(vec::AbstractVector)

Go through the emlements, split at any = sign, pass on as a matrix.
"""
function latexalign(vec::AbstractVector)
    lvec = latexraw(vec)
    ## turn the array into a matrix
    lmat = hcat(split.(lvec, " = ")...)
    ## turn the matrix ito arrays of left-hand-side, right-hand-side.
    larr = [lmat[i,:] for i in 1:size(lmat, 1)]
    length(larr) < 2 && error("Invalid intput to latexalign().")
    return latexalign( hcat(larr...) )
end


@require DiffEqBase begin
    function latexalign(ode::DiffEqBase.AbstractParameterizedFunction; field::Symbol=:funcs)
        lhs = [parse("d$x/dt") for x in ode.syms]
        rhs = getfield(ode, field)
        return latexalign(lhs, rhs)
    end

    """
        latexalign(odearray; field=:funcs)

    Display ODEs side-by-side.
    """
    function latexalign(odearray::AbstractVector{T}; field::Symbol=:funcs) where T<:DiffEqBase.AbstractParameterizedFunction
        a = []
        maxrows = maximum(length.(getfield.(odearray, :syms)))

        blank = LaTeXString("")
        for ode in odearray
            nr_eq = length(ode.syms)

            lhs = [parse("d$x/dt") for x in ode.syms]
            rhs = getfield(ode, field)
            first_separator = fill(LaTeXString(" &= "), nr_eq)
            second_separator = fill(LaTeXString(" & "), nr_eq)
            if nr_eq < maxrows
                ### This breaks type-safety, but I don't think that it will be a bottle neck for anyone.
                lhs = [lhs; fill(blank, maxrows - nr_eq)]
                rhs = [rhs; fill(blank, maxrows - nr_eq)]
                first_separator = [first_separator; fill(LaTeXString(" & "), maxrows-nr_eq)]
                second_separator = [second_separator; fill(LaTeXString(" & "), maxrows-nr_eq)]
            end

            append!(a, [lhs, first_separator, rhs, second_separator])
        end
        a = hcat(a...)
        return latexalign(a; separator=" ")
    end
end
