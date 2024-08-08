module SparseArraysExt

using Latexify
isdefined(Base, :get_extension) ? (using SparseArrays) : (using ..SparseArrays)

@latexrecipe function f(x::AbstractSparseArray)
    return collect(x)
end

end
