##################################################
#   Override default handling (default = inline) #
##################################################


###############################################
#         Overload environment functions      #
###############################################

function latexraw(x::SymEngine.Basic; kwargs...)
    str = string(x)
    ex = Meta.parse(str)
    latexraw(ex; kwargs...)
end

###############################################
#         Overload utilities                  #
###############################################

add_brackets(syms::SymEngine.Basic, vars) = add_brackets(Meta.parse("$syms"), vars)
