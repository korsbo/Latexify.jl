##################################################
#   Override default handling (default = inline) #
##################################################

get_latex_function(r::DataFrames.DataFrame) = mdtable
get_md_function(args::DataFrames.DataFrame) = mdtable

###############################################
#         Overload environment functions      #
###############################################


function mdtable(d::DataFrames.DataFrame; kwargs...)
    body = convert(Matrix, d)
    head = propertynames(d)
    mdtable(body; head=head, kwargs...)
end

function _latextabular(d::DataFrames.DataFrame; kwargs...)
    body = convert(Matrix, d)
    head = propertynames(d)
    _latextabular(body; head=head, kwargs...)
end

function _latexarray(d::DataFrames.DataFrame; kwargs...)
    body = convert(Matrix, d)
    head = permutedims(propertynames(d))
    result = vcat(head, body)
    _latexarray(result; kwargs...)
end
