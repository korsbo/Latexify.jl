module ParameterizedFunctionsExt

using Latexify
isdefined(Base, :get_extension) ? (using DiffEqBase) : (using ..DiffEqBase)


##################################################
#   Override default handling (default = inline) #
##################################################

Latexify.get_latex_function(ode::DiffEqBase.AbstractParameterizedFunction) = latexalign
function Latexify.get_latex_function(x::AbstractArray{T}) where T <: DiffEqBase.AbstractParameterizedFunction
    return latexalign
end

Latexify.get_md_function(args::DiffEqBase.AbstractParameterizedFunction) = mdalign
function Latexify.get_md_function(x::AbstractArray{T}) where T <: DiffEqBase.AbstractParameterizedFunction
    return mdalign
end

###############################################
#         Overload environment functions      #
###############################################

function Latexify.latexraw(ode::DiffEqBase.AbstractParameterizedFunction; kwargs...)
    lhs = ["\\frac{d$x}{dt} = " for x in ode.syms]
    rhs = latexraw(ode.funcs; kwargs...)
    return lhs .* rhs
end


function Latexify.latexinline(ode::DiffEqBase.AbstractParameterizedFunction; kwargs...)
    lhs = ["\\frac{d$x}{dt} = " for x in ode.syms]
    rhs = latexraw(ode.funcs; kwargs...)
    return latexstring.( lhs .* rhs )
end

function Latexify.latexalign(ode::DiffEqBase.AbstractParameterizedFunction; field::Symbol=:funcs, bracket=false, kwargs...)
    lhs = [Meta.parse("d$x/dt") for x in ode.syms]
    rhs = getfield(ode, field)
    if bracket
        rhs = add_brackets(rhs, ode.syms)
        lhs = [:(d[$x]/dt) for x in ode.syms]
    end
    return latexalign(lhs, rhs; kwargs...)
end

"""
latexalign(odearray; field=:funcs)

Display ODEs side-by-side.
"""
function Latexify.latexalign(odearray::AbstractVector{T}; field::Symbol=:funcs, kwargs...) where T<:DiffEqBase.AbstractParameterizedFunction
    a = []
    maxrows = maximum(length.(getfield.(odearray, :syms)))

    blank = LaTeXString("")
    for ode in odearray
        nr_eq = length(ode.syms)

        lhs = [Meta.parse("d$x/dt") for x in ode.syms]
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
    a = safereduce(hcat, a)
    return latexalign(a; separator=" ", kwargs...)
end

end