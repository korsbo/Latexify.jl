module SymEngineExt

using Latexify
isdefined(Base, :get_extension) ? (using SymEngine) : (using ..SymEngine)

##################################################
#   Override default handling (default = inline) #
##################################################


###############################################
#         Overload environment functions      #
###############################################

function Latexify.latexraw(x::SymEngine.Basic; kwargs...)
    str = string(x)
    ex = Meta.parse(str)
    latexraw(ex; kwargs...)
end

###############################################
#         Overload utilities                  #
###############################################

Latexify.add_brackets(syms::SymEngine.Basic, vars) = add_brackets(Meta.parse("$syms"), vars)

end