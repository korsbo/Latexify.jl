doc"""
    latexalign()
Generate a ``LaTeX`` align environment from an input.

# Examples
## use with arrays
```jldoctest
lhs = [:(dx/dt), :(dy/dt), :(dz/dt)]
rhs = [:(y-x), :(x*z-y), :(-z)]
latexalign(lhs, rhs)

# output

"\\begin{align}\n\\frac{dx}{dt} =& y - x \\\\ \n\\frac{dy}{dt} =& x \\cdot z - y \\\\ \n\\frac{dz}{dt} =& - z \\\\ \n\\end{align}\n"
```

## use with ParameterizedFunction
```julia
using DifferentialEquations
ode = @ode_def foldChangeDetection begin
    dm = r_m * (i - m)
    dy = r_y * (p_y * i/m - y)
end i=>1.0 r_m=>1.0 r_y=>1.0 p_y=>1.0

latexalign(ode)

# output

"\\begin{align}\n\\frac{dm}{dt} =& r_{m} \\cdot (i - m) \\\\ \n\\frac{dy}{dt} =& r_{y} \\cdot (\\frac{p_{y} \\cdot i}{m} - y) \\\\ \n\\end{align}\n"
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

function latexalign(ode::DiffEqBase.AbstractParameterizedFunction; field::Symbol=:funcs)
    lhs = [parse("d$x/dt") for x in ode.syms]
    rhs = getfield(ode, field)
    return latexalign(lhs, rhs)
end

function latexalign(nested::AbstractVector{AbstractVector})
    return latexalign(hcat(nested...))
end

function latexalign(vec::AbstractVector)
    lvec = latexraw(vec)
    lmat = hcat(split.(lvec, " = ")...)
    larr = [lmat[i,:] for i in 1:size(lmat, 1)]
    return latexalign( larr... )
end

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
