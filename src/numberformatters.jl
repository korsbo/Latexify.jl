abstract type AbstractNumberFormatter end

(::AbstractNumberFormatter)(x) = string(x)

const float_regex = r"(?'mantissa'(?'before_dp'(?'sign'-?)(?'before_dp_nosign'\d+))(\.(?'after_dp'\d+))?)(?'e_or_E'e)(?'raw_exp'(?'sign_exp'-?)\+?0*(?'mag_exp'\d+))"i

struct PlainNumberFormatter <: AbstractNumberFormatter end

struct PrintfNumberFormatter <: AbstractNumberFormatter
    fmt::String
    f::Function

    PrintfNumberFormatter(fmt::String) = new(fmt, Format.generate_formatter(fmt))
end

(f::PrintfNumberFormatter)(x) = f.f(x)

struct StyledNumberFormatter <: AbstractNumberFormatter
    fmt::String
    f::Function

    StyledNumberFormatter(fmt::String="%.4g") = new(fmt, Format.generate_formatter(fmt))
end

StyledNumberFormatter(significant_digits::Int) = StyledNumberFormatter("%.$(significant_digits)g")

(f::StyledNumberFormatter)(x::AbstractFloat) =
    replace(f.f(x), float_regex => s"\g<mantissa> \\mathrm{\g<e_or_E>}{\g<sign_exp>\g<mag_exp>}")
(f::StyledNumberFormatter)(x::Unsigned) = "\\mathtt{0x$(string(x; base=16, pad=2sizeof(x)))}"


struct FancyNumberFormatter <: AbstractNumberFormatter
    fmt::String
    f::Function
    exponent_format::SubstitutionString

    FancyNumberFormatter(fmt::String="%.4g",
                         exponent_format::SubstitutionString=s"\g<mantissa> \\cdot 10^{\g<sign_exp>\g<mag_exp>}") = new(fmt, Format.generate_formatter(fmt), exponent_format)
end

FancyNumberFormatter(fmt::String, mult_symbol) =
    FancyNumberFormatter(fmt, SubstitutionString("\\g<mantissa> $(escape_string(mult_symbol)) 10^{\\g<sign_exp>\\g<mag_exp>}"))
FancyNumberFormatter(significant_digits, mult_symbol="\\cdot") =
    FancyNumberFormatter("%.$(significant_digits)g", mult_symbol)


(f::FancyNumberFormatter)(x::AbstractFloat) = replace(f.f(x), float_regex => f.exponent_format)
(f::FancyNumberFormatter)(x::Unsigned) = "\\mathtt{0x$(string(x; base=16, pad=2sizeof(x)))}"

struct SiunitxNumberFormatter <: AbstractNumberFormatter
    format_options::String
    version::Int
    simple::Bool
end
function SiunitxNumberFormatter(;format_options="", version=3, simple=false)
    if ~isempty(format_options) && (~startswith(format_options, '[') || ~endswith(format_options, ']'))
        format_options = "[$format_options]"
    end
    SiunitxNumberFormatter(format_options, version, simple)
end

function (f::SiunitxNumberFormatter)(x::Number)
    return "\\num$(f.format_options){$x}"
end
function (f::SiunitxNumberFormatter)(x::Vector{<:Number})
    return "\\numlist$(f.format_options){$(join(x,';'))}"
end
function (f::SiunitxNumberFormatter)(x::AbstractRange{<:Number})
    return "\\numrange$(f.format_options){$(x.start)}{$(x.stop)}"
end
