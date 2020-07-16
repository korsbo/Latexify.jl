##################################################
#   Override default handling (default = inline) #
##################################################

get_latex_function(r::ModelingToolkit.ReactionSystem) = latexalign

get_md_function(args::ModelingToolkit.ReactionSystem) = mdalign


###############################################
#         Overload environment functions      #
###############################################

"""
latexalign(r::AbstractReactionSystem; noise=false, symbolic=true)

Generate an align environment from a reaction network.

### kwargs
- noise::Bool - output the noise function?
- symbolic::Bool - use symbolic calculation to reduce the expression?
- bracket::Bool - Surround the variables with square brackets to denote concentrations.
- clean::Bool - Clean out redundant "1*". Only useful for DiffEqBiological@v3.4.2 or earlier.
"""
# function latexalign(r::ModelingToolkit.ReactionSystem; bracket=false, noise=false, clean=false, kwargs...)
#     osys = convert(ODES)
#     syms = Symbol.(states(r))
#     lhs = [Meta.parse("d$x/dt") for x in syms]
#     # if !noise
#         f_func = [Expr(ode.rhs) for ode in equations(osys)]
#         if clean
#             rhs = clean_subtractions.(r.f_func)
#         else
#             rhs = r.f_func
#         end
#     # else
#     #     vec = r.g_func
#     #     M = reshape(vec, :, length(r.syms))
#     #     M = permutedims(M, [2,1])
#     #     expr_arr = Meta.parse.([join(M[i,:], " + ") for i in 1:size(M,1)])

#     #     if symbolic
#     #         rhs = [SymEngine.Basic(ex) for ex in expr_arr]
#     #     else
#     #         for i in 1:length(expr_arr)
#     #             filter!(x -> x != 0, expr_arr[i].args)
#     #         end
#     #         rhs = expr_arr
#     #     end
#     # end
#     if bracket
#         rhs = add_brackets(rhs, syms)
#         lhs = [:(d[$x]/dt) for x in syms]
#     end
#     return latexalign(lhs, rhs; kwargs...)
# end

# #Recursively traverses an expression and removes things like X^1, 1*X. Will not actually have any affect on the expression when used as a function, but will make it much easier to look at it for debugging, as well as if it is transformed to LaTeX code.
function recursive_clean!(expr)
    (expr isa Symbol) && (expr == :no___noise___scaling) && (return 1)
    (typeof(expr)!=Expr) && (return expr)
    for i = 1:length(expr.args)
        expr.args[i] = recursive_clean!(expr.args[i])
    end
    (expr.args[1] == :^) && (expr.args[3] == 1) && (return expr.args[2])
    if expr.args[1] == :*
        in(0,expr.args) && (return 0)
        i = 1
        while (i = i + 1) <= length(expr.args)
             if (typeof(expr.args[i]) == Expr) && (expr.args[i].head == :call) && (expr.args[i].args[1] == :*)
                 for arg in expr.args[i].args
                     (arg != :*) && push!(expr.args, arg)
                 end
             end
        end
        for i = length(expr.args):-1:2
            (typeof(expr.args[i]) == Expr) && (expr.args[i].head == :call) && (expr.args[i].args[1] == :*) && deleteat!(expr.args,i)
            (expr.args[i] == 1) && deleteat!(expr.args,i)
        end
        (length(expr.args) == 2) && (return expr.args[2])                   # We have a multiplication of only one thing, return only that thing.
        (length(expr.args) == 1) && (return 1)                              #We have only * and no real argumenys.
        (length(expr.args) == 3) && (expr.args[2] == -1) && return :(-$(expr.args[3]))
        (length(expr.args) == 3) && (expr.args[3] == -1) && return :(-$(expr.args[2]))
    end
    if expr.head == :call
        (expr.args[1] == :/) && (expr.args[3] == 1) && (return expr.args[2])
        haskey(funcdict, expr.args[1]) && return funcdict[expr.args[1]](expr.args[2:end])
        in(expr.args[1],hill_name) && return hill(expr)
        in(expr.args[1],hillR_name) && return hillR(expr)
        in(expr.args[1],mm_name) && return mm(expr)
        in(expr.args[1],mmR_name) && return mmR(expr)
        (expr.args[1] == :binomial) && (expr.args[3] == 1) && return expr.args[2]
        #@isdefined($(expr.args[1])) || error("Function $(expr.args[1]) not defined.")
    end
    return expr
end


function chemical_arrows(rn::ModelingToolkit.ReactionSystem;
    expand = true, double_linebreak=false, mathjax=true, starred=false, kwargs...)
    str = starred ? "\\begin{align*}\n" : "\\begin{align}\n"
    eol = double_linebreak ? "\\\\\\\\\n" : "\\\\\n"

    mathjax && (str *= "\\require{mhchem}\n")


    backwards_reaction = false
    rxs = ModelingToolkit.equations(rn)
    for (i, r) in enumerate(rxs)
        if backwards_reaction
            backwards_reaction = false
            continue
        end
        str *= "\\ce{ "

        ### Expand functions to maths expressions
        rate = Expr(r.rate)
        expand && (rate = recursive_clean!(rate))
        expand && (rate = recursive_clean!(rate))

        ### Generate formatted string of substrates
        substrates = [latexraw("$(substrate[2]== 1 ? "" : "$(substrate[2]) * ") $(substrate[1].op.name)"; kwargs...) for substrate in zip(r.substrates,r.substoich)]
        isempty(substrates) && (substrates = ["\\varnothing"])

        str *= join(substrates, " + ")

        ### Generate reaction arrows
        if i + 1 <= length(rxs) && issetequal(r.products,rxs[i+1].substrates) && issetequal(r.substrates,rxs[i+1].products)
            ### Bi-directional arrows
            rate_backwards = Expr(rxs[i+1].rate)
            expand && (rate_backwards = recursive_clean!(rate_backwards))
            expand && (rate_backwards = recursive_clean!(rate_backwards))
            str *= " &<=>"
            str *= "[" * latexraw(rate; kwargs...) * "]"
            str *= "[" * latexraw(rate_backwards; kwargs...) * "] "
            backwards_reaction = true
        else
            ### Uni-directional arrows
            str *= " &->"
            str *= "[" * latexraw(rate; kwargs...) * "] "
        end

        ### Generate formatted string of products
        products = [latexraw("$(product[2]== 1 ? "" : "$(product[2]) * ") $(product[1].op.name)"; kwargs...) for product in zip(r.products,r.prodstoich) ]
        isempty(products) && (products = ["\\varnothing"])
        str *= join(products, " + ")
        str *= "}$eol"
    end
    str = str[1:end-length(eol)] * "\n"

    str *= starred ? "\\end{align*}\n" : "\\end{align}\n"

    latexstr = LaTeXString(str)
    COPY_TO_CLIPBOARD && clipboard(latexstr)
    return latexstr
end



"""
clean_subtractions(ex::Expr)

Replace additions of negative terms with subtractions.

This is a fairly stupid function which is designed for a specific problem
with reaction networks. It is neither recursive nor very general.

Note: this function was moved to DiffEqBiological and is only retained here for
compatibility with older versions.

Return :: cleaned out expression
"""
function clean_subtractions(ex::Expr)
    ex.args[1] != :+ && return ex

    term = ex.args[2]

    ### Sort out the first term
    if term isa Expr && length(term.args) >= 3 && term.args[1:2] == [:*, -1]
        result = :(- *($(term.args[3:end]...)))
    else
        result = :($term)
    end


    ### Sort out the other terms
    for term in ex.args[3:end]
        if term isa Expr && length(term.args) >= 3 && term.args[1:2] == [:*, -1]
            result = :($result - *($(term.args[3:end]...)))
        else
            result = :($result + $term)
        end
    end
    return result
end

function clean_subtractions(arg)
    @warn "It appears that you are using a version of DiffEqBiological which does not require the latexify `clean` keyword argument. The `clean=true` specification will be ignored."
    return arg
end
