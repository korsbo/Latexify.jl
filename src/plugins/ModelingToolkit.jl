
##################################################
#   Override default handling (default = inline) #
##################################################
get_latex_function(eqs::Vector{ModelingToolkit.Equation}) = latexalign

get_md_function(eqs::Vector{ModelingToolkit.Equation}) = mdalign

###############################################
#         Overload environment functions      #
###############################################

function latexalign(eqs::Vector{ModelingToolkit.Equation}; iw=:t, kwargs...)
    rhs = getfield.(eqs, :rhs)
    rhs = convert.(Expr, rhs)
    rhs = [postwalk(x -> x isa ModelingToolkit.Constant ? x.value : x, eq) for eq in rhs]
    rhs = [postwalk(x -> x isa Expr && length(x.args) == 1 ? x.args[1] : x, eq) for eq in rhs]
    rhs = [postwalk(x -> x isa Expr && x.args[1] == :Differential && length(x.args[2].args) == 2 ? :($(Symbol(:d, x.args[2]))/($(Symbol(:d, x.args[2].args[2])))) : x, eq) for eq in rhs]
    rhs = [postwalk(x -> x isa Expr && x.args[1] == :Differential ? "\\frac{d\\left($(latexraw(x.args[2]))\\right)}{d$iv}" : x, eq) for eq in rhs]
    
    lhs = getfield.(eqs, :lhs)
    lhs = convert.(Expr, lhs)
    lhs = [postwalk(x -> x isa ModelingToolkit.Constant ? x.value : x, eq) for eq in lhs]
    lhs = [postwalk(x -> x isa Expr && length(x.args) == 1 ? x.args[1] : x, eq) for eq in lhs]
    lhs = [postwalk(x -> x isa Expr && x.args[1] == :Differential && length(x.args[2].args) == 2 ? :($(Symbol(:d, x.args[2]))/($(Symbol(:d, x.args[2].args[2])))) : x, eq) for eq in lhs]
    lhs = [postwalk(x -> x isa Expr && x.args[1] == :Differential ? "\\frac{d\\left($(latexraw(x.args[2]))\\right)}{d$iv}" : x, eq) for eq in lhs]
   

    latexify(lhs, rhs; kwargs...)
end
