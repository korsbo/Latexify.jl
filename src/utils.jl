function parse_function_expression(f::Function, args)
    c = @code_lowered f(args...)

    expressions = c.code[typeof.(c.code) .!= LineNumberNode ]
    expressions[end] == c.code[end] && (expressions[end] = c.code[end].args[1])
    expressions[end] isa SSAValue && (expressions = expressions[1:end-1])

    result_expr = []
    ssaval = nothing

    for ex in expressions
        ex = postwalk(x -> x isa SlotNumber ? c.slotnames[parse("$x"[2:end])] : x, ex)
        ex = postwalk(x -> x isa GlobalRef ? x.name : x, ex)

        if ex isa Expr && ex.args[1] isa SSAValue
            ssaval = ex.args[2]
        elseif ex isa Expr && length(ex.args) >= 3 && ex.args[3] isa SSAValue
            ex.args[3] = ssaval
            push!(result_expr, ex)
        elseif ex != nothing
            push!(result_expr, ex)
        end
    end
    return result_expr
end
