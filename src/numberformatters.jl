abstract type AbstractNumberFormatter end

const float_regex = r"(?'mantissa'(?'before_dp'(?'sign'-?)(?'before_dp_nosign'\d+))(\.(?'after_dp'\d+))?)(?'e_or_E'e)(?'raw_exp'(?'sign_exp'-?)\+?0*(?'mag_exp'\d+))"i

struct PlainNumberFormatter <: AbstractNumberFormatter end

(::PlainNumberFormatter)(x) = string(x)


struct PrintfNumberFormatter <: AbstractNumberFormatter
    fmt::AbstractString
    f::Function
end
PrintfNumberFormatter(fmt::AbstractString) = PrintfNumberFormatter(fmt, Formatting.generate_formatter(fmt))
(f::PrintfNumberFormatter)(x) = f.f(x)


struct StyledNumberFormatter <: AbstractNumberFormatter
    fmt::AbstractString

    StyledNumberFormatter(fmt::AbstractString="%.4g") = new(fmt)

end

function StyledNumberFormatter(significant_digits::Int)
    return StyledNumberFormatter("%.$(significant_digits)g")
end

(f::StyledNumberFormatter)(x) = string(x)
function (f::StyledNumberFormatter)(x::AbstractFloat)
    s = @eval @sprintf $(f.fmt) $x
    return replace(s, float_regex => s"\g<mantissa> \\mathrm{\g<e_or_E>}{\g<sign_exp>\g<mag_exp>}")
end

(f::StyledNumberFormatter)(x::Unsigned) = "\\mathtt{0x$(string(x; base=16, pad=2sizeof(x)))}"


struct FancyNumberFormatter <: AbstractNumberFormatter
    fmt::AbstractString
    exponent_format::SubstitutionString

    function FancyNumberFormatter(fmt::AbstractString="%.4g",
                                  exponent_format::SubstitutionString=s"\g<mantissa> \\cdot 10^{\g<sign_exp>\g<mag_exp>}")
        return new(fmt, exponent_format)
    end
end

function FancyNumberFormatter(fmt::AbstractString, mult_symbol)
    return FancyNumberFormatter(fmt, SubstitutionString("\\g<mantissa> $(escape_string(mult_symbol)) 10^{\\g<sign_exp>\\g<mag_exp>}"))
end
function FancyNumberFormatter(significant_digits, mult_symbol="\\cdot")
    return FancyNumberFormatter("%.$(significant_digits)g", mult_symbol)
end

(f::FancyNumberFormatter)(x) = string(x)

function (f::FancyNumberFormatter)(x::AbstractFloat)
    s = @eval @sprintf $(f.fmt) $x
    return replace(s, float_regex => f.exponent_format)
end

(f::FancyNumberFormatter)(x::Unsigned) = "\\mathtt{0x$(string(x; base=16, pad=2sizeof(x)))}"
