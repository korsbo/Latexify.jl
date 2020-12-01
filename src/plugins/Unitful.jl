const mathrmprefixes = Dict(
                            -24 => "y",
                            -21 => "z",
                            -18 => "a",
                            -15 => "f",
                            -12 => "p",
                            -9  => "n",
                            -6  => "\\mu",
                            -3  => "m",
                            -2  => "c",
                            -1  => "d",
                            0   => "",
                            1   => "D",
                            2   => "h",
                            3   => "k",
                            6   => "M",
                            9   => "G",
                            12  => "T",
                            15  => "P",
                            18  => "E",
                            21  => "Z",
                            24  => "Y"
                           )
const siunitxprefixes = Dict(
                             -24 => "\\yocto",
                             -21 => "\\zepto",
                             -18 => "\\atto",
                             -15 => "\\femto",
                             -12 => "\\pico",
                             -9  => "\\nano",
                             -6  => "\\micro",
                             -3  => "\\milli",
                             -2  => "\\centi",
                             -1  => "\\deci",
                             0   => "",
                             1   => "\\deka",
                             2   => "\\hecto",
                             3   => "\\kilo",
                             6   => "\\mega",
                             9   => "\\giga",
                             12  => "\\tera",
                             15  => "\\peta",
                             18  => "\\exa",
                             21  => "\\zetta",
                             24  => "\\yotta"
                            )

function latexify(q::Union{Unitful.Quantity,Unitful.FreeUnits})
    return LaTeXString("\$$(latexraw(q))\$")
end

function latexraw(q::Unitful.Quantity; unitformat=:mathrm, kwargs...)
    io = IOBuffer()
    unitformat == :mathrm && print(io,latexraw(q.val;kwargs...),"\\;")
    unitformat == :siunitx && print(io,"\\SI{",latexraw(q.val;kwargs...),"}{")
    printunit.(Ref(io),Unitful.sortexp(typeof(Unitful.unit(q)).parameters[1]),Val(unitformat))
    unitformat == :siunitx && print(io,"}")
    return String(take!(io))
end

function latexraw(u::Unitful.FreeUnits; unitformat=:mathrm)
    io = IOBuffer()
    unitformat == :siunitx && print(io,"\\si{")
    printunit.(Ref(io),Unitful.sortexp(typeof(u).parameters[1]),Val(unitformat))
    unitformat == :siunitx && print(io,"}")
    return String(take!(io))
end

function printunit(io::IO,u::Unitful.Unit,::Val{:mathrm})
    print(io,"\\mathrm{")
    iszero(u.tens) || print(io,mathrmprefixes[u.tens])
    print(io,Unitful.abbr(u))
    print(io,"}")
    u.power==1//1 || print(io,"^{",latexraw(u.power),"}")
end

function printunit(io::IO,u::Unitful.Unit,::Val{:siunitx})
    u.power<0 && print(io,"\\per")
    iszero(u.tens) || print(io,siunitxprefixes[u.tens])
    print(io,"\\",lowercase(String(Unitful.name(u))))
    abs(u.power)==1//1 || print(io,"\\tothe{",Int64(abs(u.power)),"}")
end
