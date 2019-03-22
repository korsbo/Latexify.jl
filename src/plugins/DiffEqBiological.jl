##################################################
#   Override default handling (default = inline) #
##################################################

get_latex_function(r::DiffEqBase.AbstractReactionNetwork) = latexalign

get_md_function(args::DiffEqBase.AbstractReactionNetwork) = mdalign


###############################################
#         Overload environment functions      #
###############################################

"""
latexalign(r::AbstractReactionNetwork; noise=false, symbolic=true)

Generate an align environment from a reaction network.

### kwargs
- noise::Bool - output the noise function?
- symbolic::Bool - use symbolic calculation to reduce the expression?
- bracket::Bool - Surround the variables with square brackets to denote concentrations.
"""
function latexalign(r::DiffEqBase.AbstractReactionNetwork; bracket=false, noise=false, symbolic=false, kwargs...)
    lhs = [Meta.parse("d$x/dt") for x in r.syms]
    if !noise
        symbolic ? (rhs = r.f_symfuncs) : (rhs = clean_subtractions.(r.f_func))
    else
        vec = r.g_func
        M = reshape(vec, :, length(r.syms))
        M = permutedims(M, [2,1])
        expr_arr = Meta.parse.([join(M[i,:], " + ") for i in 1:size(M,1)])

        if symbolic
            rhs = [SymEngine.Basic(ex) for ex in expr_arr]
        else
            for i in 1:length(expr_arr)
                filter!(x -> x != 0, expr_arr[i].args)
            end
            rhs = expr_arr
        end
    end
    if bracket
        rhs = add_brackets(rhs, r.syms)
        lhs = [:(d[$x]/dt) for x in r.syms]
    end
    return latexalign(lhs, rhs; kwargs...)
end


function chemical_arrows(rn::DiffEqBase.AbstractReactionNetwork;
    expand = true, double_linebreak=false, mathjax=true, starred=false, kwargs...)
    str = starred ? "\\begin{align*}\n" : "\\begin{align}\n"
    eol = double_linebreak ? "\\\\\\\\\n" : "\\\\\n"

    mathjax && (str *= "\\require{mhchem}\n")


    backwards_reaction = false
    for (i, r) in enumerate(rn.reactions)
        if backwards_reaction
            backwards_reaction = false
            continue
        end
        str *= "\\ce{ "

        ### Expand functions to maths expressions
        rate = deepcopy(r.rate_org)
        expand && (rate = DiffEqBiological.recursive_clean!(rate))
        expand && (rate = DiffEqBiological.recursive_clean!(rate))

        ### Generate formatted string of substrates
        substrates = [latexraw("$(substrate.stoichiometry== 1 ? "" : "$(substrate.stoichiometry) * ") $(substrate.reactant)"; kwargs...) for substrate in r.substrates ]
        isempty(substrates) && (substrates = ["\\varnothing"])

        str *= join(substrates, " + ")

        ### Generate reaction arrows
        if i + 1 <= length(rn.reactions) && r.products == rn.reactions[i+1].substrates && r.substrates == rn.reactions[i+1].products
            ### Bi-directional arrows
            rate_backwards = deepcopy(rn.reactions[i+1].rate_org)
            expand && (rate_backwards = DiffEqBiological.recursive_clean!(rate_backwards))
            expand && (rate_backwards = DiffEqBiological.recursive_clean!(rate_backwards))
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
        products = [latexraw("$(product.stoichiometry== 1 ? "" : "$(product.stoichiometry) * ") $(product.reactant)"; kwargs...) for product in r.products ]
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
