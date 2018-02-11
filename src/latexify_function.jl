function latexify(x)
    latexstr = latexstring( latexraw(x) )
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end


"""
    latexify(::AbstractArray)

Return a latex array.
"""
latexify(x::AbstractArray) = latexarray(x)


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

@require DiffEqBase begin
"""
    latexify(ode::AbstractParameterizedFunction)

Display ODE as a latex align.
"""
latexify(ode::DiffEqBase.AbstractParameterizedFunction; kwargs...) = latexalign(ode; kwargs...)
end
