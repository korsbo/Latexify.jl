module LatexifySymEngineExt

if isdefined(Base, :get_extension)
    using SymEngine
    using Latexify
else
    using ..SymEngine
    using ..Latexify
end

##################################################
#   Override default handling (default = inline) #
##################################################


###############################################
#         Overload environment functions      #
###############################################

function Latexify.latexraw(x::SymEngine.Basic; kwargs...)
    str = string(x)
    ex = Meta.parse(str)
    Latexify.latexraw(ex; kwargs...)
end

###############################################
#         Overload utilities                  #
###############################################

Latexify.add_brackets(syms::SymEngine.Basic, vars) = Latexify.add_brackets(Meta.parse("$syms"), vars)

end
