# This is where we put recipes for base and stdlib types

using SparseArrays: AbstractSparseArray
@latexrecipe function f(x::AbstractSparseArray)
    return collect(x)
end
