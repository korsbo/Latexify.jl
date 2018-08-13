##################################################
#   Override default handling (default = inline) #
##################################################

get_latex_function(r::DataFrames.DataFrame) = mdtable
get_md_function(args::DataFrames.DataFrame) = mdtable

###############################################
#         Overload environment functions      #
###############################################


latextabular(d::DataFrames.DataFrame; kwargs...) =latextabular(convert(Matrix, d); head=propertynames(d), kwargs...)
mdtable(d::DataFrames.DataFrame; kwargs...) = mdtable(convert(Matrix, d); head=propertynames(d), kwargs...)
