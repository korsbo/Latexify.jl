
@require DiffEqBase begin
    function chemical_arrows(rn::DiffEqBase.AbstractReactionNetwork; mathjax=true, kwargs...)
        result = mathjax ? "\\require{mhchem} \\\\ " : ""
        for r in rn.reactions
            result *= "\\ce{ "

            substrates = [p.reactant for p in r.substrates]
            isempty(substrates) && (substrates = ["\\varnothing"])
            result *= join(substrates, " ")

            result *= " ->"
            result *= "[" * latexraw(r.rate_org) * "] "

            products = [p.reactant for p in r.products]
            isempty(products) && (products = ["\\varnothing"])
            result *= join(products, " ")
            result *= "} \\\\"
        end
        return latexstring(result)
    end
end
