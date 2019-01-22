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

function latextabular(d::DataFrames.DataFrame; kwargs...)
    body = convert(Matrix, d)
    head = propertynames(d)
    latextabular(body; head=head, kwargs...)
end

function latexarray(d::DataFrames.DataFrame; kwargs...)
    body = convert(Matrix, d)
    head = permutedims(propertynames(d))
    result = vcat(head, body)
    latexarray(result; kwargs...)
end
