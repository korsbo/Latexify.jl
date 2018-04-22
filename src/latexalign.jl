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

function latexalign(arr::AbstractMatrix; separator=" =& ", md=false, starred=false)
    (rows, columns) = size(arr)
    eol = md ? "\\\\\\\\ \n" : "\\\\ \n"
    arr = latexraw(arr)

    str = "\\begin{align$(starred ? "*" : "")}\n"
    for i in 1:rows
        str *= join(arr[i,:], separator) * eol
    end
    str *= "\\end{align$(starred ? "*" : "")}\n"
    latexstr = LaTeXString(str)
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end

function latexalign(lhs::AbstractArray, rhs::AbstractArray; kwargs...)
    return latexalign(hcat(lhs, rhs); kwargs...)
end

function latexalign(nested::AbstractVector{AbstractVector}; kwargs...)
    return latexalign(hcat(nested...); kwargs...)
end

"""
    latexalign(vec::AbstractVector)

Go through the elements, split at any = sign, pass on as a matrix.
"""
function latexalign(vec::AbstractVector; kwargs...)
    lvec = latexraw(vec)
    ## turn the array into a matrix
    lmat = hcat(split.(lvec, " = ")...)
    ## turn the matrix ito arrays of left-hand-side, right-hand-side.
    larr = [lmat[i,:] for i in 1:size(lmat, 1)]
    length(larr) < 2 && error("Invalid intput to latexalign().")
    return latexalign( hcat(larr...) ; kwargs...)
end


@require DiffEqBase begin
    function latexalign(ode::DiffEqBase.AbstractParameterizedFunction; field::Symbol=:funcs, kwargs...)
        lhs = [parse("d$x/dt") for x in ode.syms]
        rhs = getfield(ode, field)
        return latexalign(lhs, rhs; kwargs...)
    end

    """
        latexalign(odearray; field=:funcs)

    Display ODEs side-by-side.
    """
    function latexalign(odearray::AbstractVector{T}; field::Symbol=:funcs, kwargs...) where T<:DiffEqBase.AbstractParameterizedFunction
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
        return latexalign(a; separator=" ", kwargs...)
    end

    """
        latexalign(r::AbstractReactionNetwork; noise=false, symbolic=true)

    Generate an align environment from a reaction network.

    ### kwargs
    - noise::Bool - output the noise function?
    - symbolic::Bool - use symbolic calculation to reduce the expression?
    """
    function latexalign(r::DiffEqBase.AbstractReactionNetwork; noise=false, symbolic=true, kwargs...)
        lhs = ["d$x/dt" for x in r.syms]
        if !noise
            symbolic ? (rhs = r.f_symfuncs) : (rhs = r.f_func)
        else
            vec = r.g_func
            M = reshape(vec, :, length(r.syms))
            M = permutedims(M, [2,1])
            expr_arr = parse.([join(M[i,:], " + ") for i in 1:size(M,1)])

            if symbolic
                rhs = [SymEngine.Basic(ex) for ex in expr_arr]
            else
                for i in 1:length(expr_arr)
                    filter!(x -> x != 0, expr_arr[i].args)
                end
                rhs = expr_arr
            end
        end
        return latexalign(lhs, rhs; kwargs...)
    end
end
