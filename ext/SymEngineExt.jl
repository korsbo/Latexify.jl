module SymEngineExt

using Latexify
isdefined(Base, :get_extension) ? (using SymEngine) : (using ..SymEngine)

@latexrecipe function f(x::SymEngine.Basic)
    return string(x)
end

end
