


add_brackets(arr::AbstractArray, vars) = [add_brackets(element, vars) for element in arr]

add_brackets(s::Any, vars) = return s

function add_brackets(ex::Expr, vars)
    ex = postwalk(x -> x in vars ? "\\left[ $(convertSubscript(x)) \\right]" : x, ex)
    return ex
end
