macro latexify(oneliner)
    display(latexify(:($(oneliner.args[1]) = $(oneliner.args[2].args[2]))))
    return oneliner
end
