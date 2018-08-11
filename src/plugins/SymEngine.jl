##################################################
#   Override default handling (default = inline) #
##################################################


###############################################
#         Overload environment functions      #
###############################################

function latexraw(x::SymEngine.Basic)
    str = string(x)
    ex = Meta.parse(str)
    latexraw(ex)
end

###############################################
#         Overload utilities                  #
###############################################

add_brackets(syms::SymEngine.Basic, vars) = add_brackets(Meta.parse("$syms"), vars)
