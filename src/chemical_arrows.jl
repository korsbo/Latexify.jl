
@require DiffEqBiological begin
    function chemical_arrows(rn::DiffEqBase.AbstractReactionNetwork;
            expand = true, mathjax=true, md=false, kwargs...)

        str = "\\begin{equation}\n"
        eol = md ? "\\\\\\\\\n" : "\\\\\n"
        mathjax && (str *= "\\require{mhchem} $eol")


        for r in rn.reactions
            rate = deepcopy(r.rate_org)
            expand && (rate = DiffEqBiological.recursive_clean!(rate))
            expand && (rate = DiffEqBiological.recursive_clean!(rate))

            str *= "\\ce{ "

            substrates = [p.reactant for p in r.substrates]
            isempty(substrates) && (substrates = ["\\varnothing"])
            str *= join(substrates, " ")

            str *= " ->"
            str *= "[" * latexraw(rate) * "] "

            products = [p.reactant for p in r.products]
            isempty(products) && (products = ["\\varnothing"])
            str *= join(products, " ")
            str *= "} $eol"
        end
        str *= "\\end{equation}"
        return LaTeXString(str)
    end
end
