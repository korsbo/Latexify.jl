
@latexrecipe function f(x::UnitRange; expand_ranges=false)
    expand_ranges && return collect(x)
    return :($(x.start) : $(x.stop))
end

@latexrecipe function f(x::StepRange; expand_ranges=false, expand_step_ranges=true)
    (expand_ranges || expand_step_ranges) && return collect(x)
    return :($(x.start) : $(step(x)) : $(x.stop))
end

@latexrecipe function f(x::StepRangeLen{T, R, S, L}; expand_ranges=false, expand_step_ranges=true) where {T, R, S, L}
    (expand_ranges || expand_step_ranges) && return collect(x)
    return :($(T(x.ref + (x.offset-1)*step(x))) : $(T(x.step)) : $(T(x.ref + (x.len-1)*x.step)))
end



