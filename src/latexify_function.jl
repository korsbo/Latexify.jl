function latexify(x)
    latexstr = latexstring( latexraw(x) )
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end


"""
    latexify(::AbstractArray)

Return a latex array.
"""
latexify(x::AbstractArray; kwargs...) = latexarray(x; kwargs...)


"""
    latexify( nested vector )

If the vector can be converted to a matrix, return a latex array.
Otherwise, convert all non-container elements to inline latex equations.
"""
function latexify(x::AbstractArray{T}; kwargs...) where T <: AbstractArray
    try
        x = hcat(x...)
        return latexarray(x; kwargs...)
    catch
        return latexinline(x)
    end
end

"""
    latexify(lhs::AbstractVector, rhs::AbstractVector)

return a latex align environment with lhs = rhs.
"""
latexify(lhs::AbstractVector, rhs::AbstractVector) = latexalign(lhs, rhs)

@require DiffEqBase begin
"""
    latexify(ode::AbstractParameterizedFunction)

Display an ODE defined by @ode_def as a latex align.
"""
    latexify(ode::DiffEqBase.AbstractParameterizedFunction; kwargs...) = latexalign(ode; kwargs...)

"""
    latexify(::AbstractArray{ParameterizedFunction})

Display ODEs defined by @ode_def side-by-side in a latex align.
"""
    function latexify(x::AbstractArray{T}) where T <: DiffEqBase.AbstractParameterizedFunction
        latexalign(x)
    end


"""
    latexify(r::AbstractReactionNetwork; noise=false, symbolic=true)

Generate an align environment from a reaction network.

### kwargs
- noise::Bool - output the noise function?
- symbolic::Bool - use symbolic calculation to reduce the expression?
"""
    latexify(r::DiffEqBase.AbstractReactionNetwork; kwargs...) = latexalign(r; kwargs...)
end
