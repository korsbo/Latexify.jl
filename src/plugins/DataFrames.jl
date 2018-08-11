##################################################
#   Override default handling (default = inline) #
##################################################

get_latex_function(r::DataFrames.DataFrame) = mdtable
get_md_function(args::DataFrames.DataFrame) = mdtable

###############################################
#         Overload environment functions      #
###############################################

latextabular(d::DataFrames.DataFrame; kwargs...) =latextabular(hcat(d.columns...); head=keys(d.colindex), kwargs...)
mdtable(d::DataFrames.DataFrame; kwargs...) = mdtable(hcat(d.columns...); head=keys(d.colindex), kwargs...)
