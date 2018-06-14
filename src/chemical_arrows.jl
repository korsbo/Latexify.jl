
@require DiffEqBiological begin
    function chemical_arrows(rn::DiffEqBase.AbstractReactionNetwork;
            expand = true, md=false, mathjax=true, starred=false, kwargs...)

        str = starred ? "\\begin{align*}\n" : "\\begin{align}\n"
        eol = md ? "\\\\\\\\\n" : "\\\\\n"

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
            substrates = [latexraw("$(substrate.stoichiometry== 1 ? "" : "$(substrate.stoichiometry) * ") $(substrate.reactant)") for substrate in r.substrates ]
            isempty(substrates) && (substrates = ["\\varnothing"])

            str *= join(substrates, " + ")

            ### Generate reaction arrows
            if i + 1 <= length(rn.reactions) && r.products == rn.reactions[i+1].substrates && r.substrates == rn.reactions[i+1].products 
                ### Bi-directional arrows
                rate_backwards = deepcopy(rn.reactions[i+1].rate_org)
                expand && (rate_backwards = DiffEqBiological.recursive_clean!(rate_backwards))
                expand && (rate_backwards = DiffEqBiological.recursive_clean!(rate_backwards))
                str *= " &<=>"
                str *= "[{" * latexraw(rate) * "}]"
                str *= "[{" * latexraw(rate_backwards) * "}] "
                backwards_reaction = true
            else
                ### Uni-directional arrows
                str *= " &->"
                str *= "[" * latexraw(rate) * "] "
            end

            ### Generate formatted string of products
            products = [latexraw("$(product.stoichiometry== 1 ? "" : "$(product.stoichiometry) * ") $(product.reactant)") for product in r.products ]
            isempty(products) && (products = ["\\varnothing"])
            str *= join(products, " + ")
            str *= "}$eol"
        end
        str *= starred ? "\\end{align*}\n" : "\\end{align}\n"

        latexstr = LaTeXString(str)
        COPY_TO_CLIPBOARD && clipboard(latexstr)
        return latexstr
    end
end
