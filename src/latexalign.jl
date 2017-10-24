"""
    latexalign()
Generate a LaTeX align environment from an input.

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
```jldoctest
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

function latexalign{T}(arr::AbstractArray{T,2})
    (rows, columns) = size(arr)
    size(arr,2) != 2 && error("Wrong dimensions of array in latexalign")
    str = "\\begin{align}\n"
    isa(arr, Matrix{String}) || (arr = latexify(arr))
    for i in 1:rows
        str *= "$(arr[i,1]) =& $(arr[i,2]) \\\\ \n"
    end
    str *= "\\end{align}\n"
    return str
end

function latexalign(lhs::AbstractArray, rhs::AbstractArray)
    return latexalign(latexify(hcat(lhs, rhs)))
end

function latexalign(ode::DiffEqBase.AbstractParameterizedFunction; field::Symbol=:funcs)
    lhs = [parse("d$x/dt") for x in ode.syms]
    rhs = getfield(ode, field)
    return latexalign(lhs, rhs)
end
