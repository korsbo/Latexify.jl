module DataFramesExt

using Latexify
isdefined(Base, :get_extension) ? (using DataFrames) : (using ..DataFrames)

##################################################
#   Override default handling (default = inline) #
##################################################

Latexify.get_latex_function(r::DataFrames.DataFrame) = mdtable
Latexify.get_md_function(args::DataFrames.DataFrame) = mdtable

###############################################
#         Overload environment functions      #
###############################################


function Latexify.mdtable(d::DataFrames.DataFrame; kwargs...)
    body = Matrix(d)
    head = propertynames(d)
    mdtable(body; head=head, kwargs...)
end

function Latexify._latextabular(d::DataFrames.DataFrame; kwargs...)
    body = Matrix(d)
    head = propertynames(d)
    Latexify._latextabular(body; head=head, kwargs...)
end

function Latexify._latexarray(d::DataFrames.DataFrame; kwargs...)
    body = Matrix(d)
    head = permutedims(propertynames(d))
    result = vcat(head, body)
    Latexify._latexarray(result; kwargs...)
end

end