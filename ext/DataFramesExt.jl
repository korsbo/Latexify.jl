module DataFramesExt

using Latexify
isdefined(Base, :get_extension) ? (using DataFrames) : (using ..DataFrames)

@latexrecipe function f(d::DataFrame)
    env --> :mdtable
    head := propertynames(d)
    if kwargs[:env] == :array
        return vcat(permutedims(propertynames(d)), Matrix(d))
    end
    return Matrix(d)
end

end
