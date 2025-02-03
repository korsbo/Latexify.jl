import OrderedCollections: OrderedDict
import Base.Unicode

mathup(c::Char, bold) = Char(
    UInt32(c) + if isuppercase(c)
        (bold ? #='𝐀'=#0x1d400 : #='A'=#0x0041) - #='A'=#0x0041  # Mathematical (Bold) Capital
    elseif islowercase(c)
        (bold ? #='𝐚'=#0x1d41a : #='a'=#0x0061) - #='a'=#0x0061  # Mathematical (Bold) Small
    else
        (bold ? #='𝟎'=#0x1d7ce : #='0'=#0x0030) - #='0'=#0x0030  # Mathematical (Bold) Digit
    end
)
mathscr(c::Char, bold) = Char(
    UInt32(c) + if isuppercase(c)
        (bold ? #='𝓐'=#0x1d4d0 : #='𝒜'=#0x1d49c) - #='A'=#0x0041  # Mathematical (Bold) Script Capital
    elseif islowercase(c)
        (bold ? #='𝓪'=#0x1d4ea : #='𝒶'=#0x1d4b6) - #='a'=#0x0061  # Mathematical (Bold) Script Small
    else
        -UInt32(c)
    end
)
mathit(c::Char, bold) = Char(
    UInt32(c) + if isuppercase(c)
        (bold ? #='𝑨'=#0x1d468 : #='𝐴'=#0x1d434) - #='A'=#0x0041  # Mathematical (Bold) Italic Capital
    elseif islowercase(c)
        (bold ? #='𝒂'=#0x1d482 : #='𝑎'=#0x1d44e) - #='a'=#0x0061  # Mathematical (Bold) Italic Small
    else
        -UInt32(c)
    end
)
mathfrak(c::Char, bold) = Char(
    UInt32(c) + if isuppercase(c)
        (bold ? #='𝕬'=#0x1d56c : #='𝔄'=#0x1d504) - #='A'=#0x0041  # Mathematical (Bold) Fraktur Capital
    elseif islowercase(c)
        (bold ? #='𝖆'=#0x1d586 : #='𝔞'=#0x1d51e) - #='a'=#0x0061  # Mathematical (Bold) Fraktur Small
    else
        -UInt32(c)
    end
)
mathsfup(c::Char, bold) = Char(
    UInt32(c) + if isuppercase(c)
        (bold ? #='𝗔'=#0x1d5d4 : #='𝖠'=#0x1d5a0) - #='A'=#0x0041  # Mathematical (Bold) Sans-Serif Capital
    elseif islowercase(c)
        (bold ? #='𝗮'=#0x1d5ee : #='𝖺'=#0x1d5ba) - #='a'=#0x0061  # Mathematical (Bold) Sans-Serif Small
    else
        (bold ? #='𝟬'=#0x1d7ec : #='𝟢'=#0x1d7e2) - #='0'=#0x0030  # Mathematical (Bold) Sans-Serif Digit
    end
)
mathsfit(c::Char, bold) = Char(
    UInt32(c) + if isuppercase(c)
        (bold ? #='𝘼'=#0x1d63c : #='𝘈'=#0x1d608) - #='A'=#0x0041  # Mathematical (Bold) Sans-Serif Italic Capital
    elseif islowercase(c)
        (bold ? #='𝙖'=#0x1d656 : #='𝘢'=#0x1d622) - #='a'=#0x0061  # Mathematical (Bold) Sans-Serif Italic Small
    else
        -UInt32(c)
    end
)
mathtt(c::Char) = Char(
    UInt32(c) + if isuppercase(c)
        #='𝙰'=#0x1d670 - #='A'=#0x0041  # Mathematical Monospace Capital
    elseif islowercase(c)
        #='𝚊'=#0x1d68a - #='a'=#0x0061  # Mathematical Monospace Small
    else
        #='𝟶'=#0x1d7f6 - #='0'=#0x0030  # Mathematical Monospace Digit
    end
)
mathbb(c::Char) = Char(
    UInt32(c) + if isuppercase(c)
        #='𝔸'=#0x1d538 - #='A'=#0x0041  # Mathematical Double-Struck Capital
    elseif islowercase(c)
        #='𝕒'=#0x1d552 - #='a'=#0x0061  # Mathematical Double-Struck Small
    else
        #='𝟘'=#0x1d7d8 - #='0'=#0x0030  # Mathematical Double-Struck Digit
    end
)

const greek_seq = (  # contiguous unicode sequence
    raw"\Alpha",
    raw"\Beta",
    raw"\Gamma",
    raw"\Delta",
    raw"\Epsilon",
    raw"\Zeta",
    raw"\Eta",
    raw"\Theta",
    raw"\Iota",
    raw"\Kappa",
    raw"\Lambda",
    raw"\Mu",
    raw"\Nu",
    raw"\Xi",
    raw"\Omicron",
    raw"\Pi",
    raw"\Rho",
    raw"\varTheta",
    raw"\Sigma",
    raw"\Tau",
    raw"\Upsilon",
    raw"\Phi",
    raw"\Chi",
    raw"\Psi",
    raw"\Omega",
    raw"\nabla",
    raw"\alpha",
    raw"\beta",
    raw"\gamma",
    raw"\delta",
    raw"\varepsilon",
    raw"\zeta",
    raw"\eta",
    raw"\theta",
    raw"\iota",
    raw"\kappa",
    raw"\lambda",
    raw"\mu",
    raw"\nu",
    raw"\xi",
    raw"\omicron",
    raw"\pi",
    raw"\rho",
    raw"\varsigma",
    raw"\sigma",
    raw"\tau",
    raw"\upsilon",
    raw"\varphi",
    raw"\chi",
    raw"\psi",
    raw"\omega",
    raw"\partial",
    raw"\epsilon",
    raw"\vartheta",
    raw"\varkappa",
    raw"\phi",
    raw"\varrho",
    raw"\varpi",
)

const emphases = (
    # ("mathup", ("textup",)) => identity,
    ("", ("textnormal",)) => identity,
    ("mathbf", ("textbf",)) => c -> mathup(c, true),
    ("mathit", ("textit",)) => c -> mathit(c, false),
    ("mathbfit", ("textit", "textbf")) => c -> mathit(c, true),
    ("mathscr", ()) => c -> mathscr(c, false),
    ("mathbfscr", ()) => c -> mathscr(c, true),
    ("mathfrak", ()) => c -> mathfrak(c, false),
    ("mathbffrak", ()) => c -> mathfrak(c, true),
    ("mathsfup", ()) => c -> mathsfup(c, false),
    ("mathbfsfup", ()) => c -> mathsfup(c, true),
    ("mathsfit", ()) => c -> mathsfit(c, false),
    ("mathbfsfit", ()) => c -> mathsfit(c, true),
    ("mathbb", ()) => mathbb,
    ("mathtt", ("texttt",)) => mathtt,
)

"""
    latex_diacritics(c::Char)

- generate latex escape codes for diacritics of the latin alphabet (upper and lower case), see https://en.wikibooks.org/wiki/LaTeX/Special_Characters#Escaped_codes
- also generate a subset of the following sequence, when the single char normalization is available:
    - 'à' => "\\`{a}"  # grave
    - 'á' => "\\'{a}"  # acute
    - 'ä' => "\\"{a}"  # umlaut (trema, dieresis)
    - 'a̋' => "\\H{a}"  # hungarian umlaut (double acute)
    - 'a̧' => "\\c{a}"  # cedilla
    - 'ą' => "\\k{a}"  # ogonek
    - 'a̱' => "\\b{a}"  # bar under
    - 'ạ' => "\\d{a}"  # dot under
    - 'å' => "\\r{a}"  # ring
    - 'ă' => "\\u{a}"  # breve
    - 'ǎ' => "\\v{a}"  # caron (háček)
    - Some more diacritics are ignored, and rather treated like math modifiers:
        - 'â' => "\\hat{a}" # rather than "\\^{a}", circumflex
        - 'ã' => "\\tilde{a}" # rather than "\\~{a}", tilde
        - 'ā' => "\\bar{a}" # rather than "\\={a}", macron (bar above)
        - 'ȧ' => "\\dot{a}" # rather than "\\.{a}", dot above
"""
function latex_diacritics(chars::AbstractVector)
    out = []
    for c ∈ chars, (mod, mark) ∈ (
        '`' => Char(0x300),  # latex sequence \`{c} maps to 'c' * Char(0x300) := "c̀"
        "'" => Char(0x301),
        #'^' => Char(0x302),
        #'~' => Char(0x303),
        #'=' => Char(0x304),
        'u' => Char(0x306),
        #'.' => Char(0x307),
        '"' => Char(0x308),
        'r' => Char(0x30a),
        'H' => Char(0x30b),
        'v' => Char(0x30c),
        'd' => Char(0x323),
        'c' => Char(0x327),
        'k' => Char(0x328),
        'b' => Char(0x331),
    )
        for ((_, et), func) ∈ emphases
            isempty(et) && continue
            repl = "\\$mod{$c}"
            for emph ∈ et
                isempty(emph) && continue
                repl = "\\$emph{$repl}"
            end
            dia = func(c) * mark
            # e.g. ('y' * Char(0x30a) == "ẙ") != (Char(0x1e99) == 'ẙ'), although they look the same
            push!(out, dia => repl)
            alias = length(dia) == 1 ? dia : Unicode.normalize(dia)
            if alias != dia
                push!(out, (length(alias) == 1 ? first(alias) : alias) => repl)
            end
        end
    end
    out
end

function latex_emphasis(chars::AbstractVector)
    out = []
    for ((em, _), f) ∈ emphases
        isempty(em) && continue
        for c ∈ chars
            push!(out, f(c) => isempty(em) ? c : "\\$em{$c}")
        end
    end
    filter(p -> isprint(p.first), out)
end

# [`LaTeX`] https://tug.ctan.org/info/symbols/comprehensive/symbols-a4.pdf
# \mathrm: normal upright Roman font
# \mathnormal: normal math italic font
# \mathbf: upright Roman boldface letters
# \mathsf: upright sans serif letters
# [`unicode-math`] https://mirrors.ctan.org/macros/unicodetex/latex/unicode-math/unicode-math.pdf
# \mathup Upright serif                 ✘ regular text
# \mathbfup Bold upright serif          ✘ \mathbf instead
# \mathit Italic serif                  ✔
# \mathbfit Bold italic serif           ✔
# \mathsfup Upright sans-serif          ✔
# \mathsfit Italic sans-serif           ✔
# \mathbfsfup Bold upright sans-serif   ✔
# \mathbfsfit Bold italic sans-serif    ✔
# \mathtt Typewriter                    ✔
# \mathbb Blackboard bold               ✔
# \mathbbit Blackboard bold italic      ✔
# \mathscr Script                       ✔
# \mathbfscr Bold script                ✔
# \mathcal Calligraphic                 ✘ \mathscr instead
# \mathbfcal Bold calligraphic          ✘ \mathbfscr instead
# \mathfrak Fraktur                     ✔
# \mathbffrak Bold Fraktur              ✔
# [`amssymb`] https://mirrors.ctan.org/fonts/amsfonts/doc/amssymb.pdf

const unicodedict = OrderedDict{Union{Char,String}, String}(
    # ↓↓↓ unicode, in increasing order (see https://docs.julialang.org/en/v1/manual/unicode-input)
    # commented lines are either unsupported in `LaTeX` (or only through a package such as `marvosym` for e.g. `\jupiter`)
    # or don't make sense here (letter modifiers such as `\enclosecircle`)
    '¡' => raw"\textnormal{\textexclamdown}",  # \exclamdown
    '£' => raw"\mathsterling",  # \sterling
    '¥' => raw"\mathyen",  # \yen
    '¦' => raw"\textnormal{\textbrokenbar}",  # \brokenbar
    '§' => raw"\S",
    '©' => raw"\copyright",
    'ª' => raw"\textnormal{\textordfeminine}",  # \ordfeminine
    '¬' => raw"\neg",  # \lnot
    '®' => raw"\circledR",
    # '¯' => raw"\highminus",
    '°' => raw"\textnormal{\textdegree}",  # {^{\circ}}, \degree
    '±' => raw"\pm",
    '²' => raw"{^2}",
    '³' => raw"{^3}",
    '¶' => raw"\P",
    '·' => raw"\cdotp",
    '¹' => raw"{^1}",
    'º' => raw"\textnormal{\textordmasculine}",  # \ordmasculine
    '¼' => raw"\tfrac{1}{4}",
    '½' => raw"\tfrac{1}{2}",
    '¾' => raw"\tfrac{3}{4}",
    '¿' => raw"\textnormal{\textquestiondown}",  # \questiondown
    'Å' => raw"\textnormal{\AA}",
    'Æ' => raw"\textnormal{\AE}",
    'Ð' => raw"\textnormal{\DH}",
    '×' => raw"\times",
    'Ø' => raw"\textnormal{\O}",
    'Þ' => raw"\textnormal{\TH}",
    'ß' => raw"\textnormal{\ss}",
    'å' => raw"\textnormal{\aa}",
    'æ' => raw"\textnormal{\ae}",
    'ð' => raw"\eth",  # \dh
    '÷' => raw"\div",
    'ø' => raw"\emptyset",
    'þ' => raw"\textnormal{\th}",
    'Đ' => raw"\textnormal{\DJ}",
    'đ' => raw"\textnormal{\dj}",
    'ħ' => raw"\hslash",  # \hbar
    'ı' => raw"\imath",
    'Ł' => raw"\textnormal{\L}",
    'ł' => raw"\textnormal{\l}",
    'Ŋ' => raw"\textnormal{\NG}",
    'ŋ' => raw"\textnormal{\ng}",
    'Œ' => raw"\textnormal{\OE}",
    'œ' => raw"\textnormal{\oe}",
    # 'ƕ' => raw"\hvlig",
    # 'ƞ' => raw"\nrleg",
    'Ƶ' => raw"\Zbar",
    # 'ǂ' => raw"\doublepipe",
    'ȷ' => raw"\jmath",
    # 'ɐ' => raw"\trna",
    # 'ɒ' => raw"\trnsa",
    # 'ɔ' => raw"\openo",
    # 'ɖ' => raw"\rtld",
    # 'ə' => raw"\schwa",
    # 'ɣ' => raw"\pgamma",
    # 'ɤ' => raw"\pbgam",
    # 'ɥ' => raw"\trnh",
    # 'ɬ' => raw"\btdl",
    # 'ɭ' => raw"\rtll",
    # 'ɯ' => raw"\trnm",
    # 'ɰ' => raw"\trnmlr",
    # 'ɱ' => raw"\ltlmr",
    # 'ɲ' => raw"\ltln",
    # 'ɳ' => raw"\rtln",
    # 'ɷ' => raw"\clomeg",
    # 'ɸ' => raw"\ltphi",
    # 'ɹ' => raw"\trnr",
    # 'ɺ' => raw"\trnrl",
    # 'ɻ' => raw"\rttrnr",
    # 'ɼ' => raw"\rl",
    # 'ɽ' => raw"\rtlr",
    # 'ɾ' => raw"\fhr",
    # 'ʂ' => raw"\rtls",
    # 'ʃ' => raw"\esh",
    # 'ʇ' => raw"\trnt",
    # 'ʈ' => raw"\rtlt",
    # 'ʊ' => raw"\pupsil",
    # 'ʋ' => raw"\pscrv",
    # 'ʌ' => raw"\invv",
    # 'ʍ' => raw"\invw",
    # 'ʎ' => raw"\trny",
    # 'ʐ' => raw"\rtlz",
    # 'ʒ' => raw"\yogh",
    # 'ʔ' => raw"\glst",
    # 'ʕ' => raw"\reglst",
    # 'ʖ' => raw"\inglst",
    # 'ʞ' => raw"\turnk",
    # 'ʤ' => raw"\dyogh",
    # 'ʧ' => raw"\tesh",
    'ʰ' => raw"{^h}",
    'ʲ' => raw"{^j}",
    'ʳ' => raw"{^r}",
    'ʷ' => raw"{^w}",
    'ʸ' => raw"{^y}",
    'ʼ' => raw"{'}",  # \rasp
    # 'ˈ' => raw"\sverts",
    # 'ˌ' => raw"\verti",
    # 'ː' => raw"\lmrk",  # \textlengthmark
    # 'ˑ' => raw"\hlmrk",  # \texthalflength
    # '˒' => raw"\sbrhr",
    # '˓' => raw"\sblhr",
    # '˔' => raw"\rais",  # \textraised
    # '˕' => raw"\low",  # \textlowered
    '˘' => raw"\textnormal{\u{}}",
    '˜' => raw"\textnormal{\texttildelow}",  # \tildelow
    'ˡ' => raw"{^l}",
    'ˢ' => raw"{^s}",
    'ˣ' => raw"{^x}",
    # '̀' => raw"\grave{}",
    # '́' => raw"\acute{}",
    # '̂' => raw"\hat{}",
    # '̃' => raw"\tilde{}",
    # '̄' => raw"\bar{}",
    # '̅' => raw"\overbar{}",
    # '̆' => raw"\breve{}",
    # '̇' => raw"\dot{}",
    # '̈' => raw"\ddot{}",
    # '̉' => raw"\ovhook{}",
    # '̊' => raw"\ocirc{}",
    # '̋' => raw"\H{}",
    # '̌' => raw"\check{}",
    # '̐' => raw"\candra{}",
    # '̒' => raw"\oturnedcomma{}",
    # '̕' => raw"\ocommatopright{}",
    # '̚' => raw"\droang{}",
    # '̡' => raw"\palh{}",
    # '̢' => raw"\rh{}",
    # '̧' => raw"\c{}",
    # '̨' => raw"\k{}",
    # '̪' => raw"\sbbrg{}",
    # '̰' => raw"\wideutilde{}",
    # '̲' => raw"\underbar{}",
    # '̶' => raw"\strike{}",  # \sout
    # '̸' => raw"\not{}",
    # '͍' => raw"\underleftrightarrow{}",
    # greek without emphasis
    'Α' => raw"\Alpha",
    'Β' => raw"\Beta",
    'Γ' => raw"\Gamma",
    'Δ' => raw"\Delta",
    'Ε' => raw"\Epsilon",
    'Ζ' => raw"\Zeta",
    'Η' => raw"\Eta",
    'Θ' => raw"\Theta",
    'Ι' => raw"\Iota",
    'Κ' => raw"\Kappa",
    'Λ' => raw"\Lambda",
    'Μ' => raw"\Mu",  # \upMu
    'Ν' => raw"\Nu",  # \upNu
    'Ξ' => raw"\Xi",
    'Ο' => raw"\Omicron",  # \upOmicron
    'Π' => raw"\Pi",
    'Ρ' => raw"\Rho",
    'Σ' => raw"\Sigma",
    'Τ' => raw"\Tau",
    'Υ' => raw"\Upsilon",
    'Φ' => raw"\Phi",
    'Χ' => raw"\Chi",
    'Ψ' => raw"\Psi",
    'Ω' => raw"\Omega",
    'α' => raw"\alpha",
    'β' => raw"\beta",
    'γ' => raw"\gamma",
    'δ' => raw"\delta",
    'ε' => raw"\varepsilon",
    'ζ' => raw"\zeta",
    'η' => raw"\eta",
    'θ' => raw"\theta",
    'ι' => raw"\iota",
    'κ' => raw"\kappa",
    'λ' => raw"\lambda",
    'μ' => raw"\mu",
    'ν' => raw"\nu",
    'ξ' => raw"\xi",
    'ο' => raw"\omicron",  # \upomicron
    'π' => raw"\pi",
    'ρ' => raw"\rho",
    'ς' => raw"\varsigma",
    'σ' => raw"\sigma",
    'τ' => raw"\tau",
    'υ' => raw"\upsilon",
    'φ' => raw"\varphi",
    'χ' => raw"\chi",
    'ψ' => raw"\psi",
    'ω' => raw"\omega",
    # 'ϐ' => raw"\varbeta",
    'ϑ' => raw"\vartheta",
    'ϕ' => raw"\phi",
    'ϖ' => raw"\varpi",
    # 'Ϙ' => raw"\oldKoppa",
    # 'ϙ' => raw"\oldkoppa",
    # 'Ϛ' => raw"\Stigma",
    # 'ϛ' => raw"\upstigma",
    'Ϝ' => raw"\upDigamma",
    'ϝ' => raw"\updigamma",
    # 'Ϟ' => raw"\Koppa",
    # 'ϟ' => raw"\koppa",
    # 'Ϡ' => raw"\Sampi",
    # 'ϡ' => raw"\upsampi",
    'ϰ' => raw"\varkappa",
    'ϱ' => raw"\varrho",
    'ϴ' => raw"\varTheta",
    'ϵ' => raw"\epsilon",
    '϶' => raw"\backepsilon",
    'ᴬ' => raw"{^A}",
    'ᴮ' => raw"{^B}",
    'ᴰ' => raw"{^D}",
    'ᴱ' => raw"{^E}",
    'ᴳ' => raw"{^G}",
    'ᴴ' => raw"{^H}",
    'ᴵ' => raw"{^I}",
    'ᴶ' => raw"{^J}",
    'ᴷ' => raw"{^K}",
    'ᴸ' => raw"{^L}",
    'ᴹ' => raw"{^M}",
    'ᴺ' => raw"{^N}",
    'ᴼ' => raw"{^O}",
    'ᴾ' => raw"{^P}",
    'ᴿ' => raw"{^R}",
    'ᵀ' => raw"{^T}",
    'ᵁ' => raw"{^U}",
    'ᵂ' => raw"{^W}",
    'ᵃ' => raw"{^a}",
    'ᵅ' => raw"{^\alpha}",
    'ᵇ' => raw"{^b}",
    'ᵈ' => raw"{^d}",
    'ᵉ' => raw"{^e}",
    'ᵋ' => raw"{^\epsilon}",
    'ᵍ' => raw"{^g}",
    'ᵏ' => raw"{^k}",
    'ᵐ' => raw"{^m}",
    'ᵒ' => raw"{^o}",
    'ᵖ' => raw"{^p}",
    'ᵗ' => raw"{^t}",
    'ᵘ' => raw"{^u}",
    'ᵛ' => raw"{^v}",
    'ᵝ' => raw"{^\beta}",
    'ᵞ' => raw"{^\gamma}",
    'ᵟ' => raw"{^\delta}",
    'ᵠ' => raw"{^\phi}",
    'ᵡ' => raw"{^\chi}",
    'ᵢ' => raw"{_i}",
    'ᵣ' => raw"{_r}",
    'ᵤ' => raw"{_u}",
    'ᵥ' => raw"{_v}",
    'ᵦ' => raw"{_\beta}",
    'ᵧ' => raw"{_\gamma}",
    'ᵨ' => raw"{_\rho}",
    'ᵩ' => raw"{_\phi}",
    'ᵪ' => raw"{_\chi}",
    'ᶜ' => raw"{^c}",
    'ᶠ' => raw"{^f}",
    'ᶥ' => raw"{^\iota}",
    'ᶲ' => raw"{^\phi}",  # \ltphi
    'ᶻ' => raw"{^z}",
    'ᶿ' => raw"{^\theta}",
    # see https://mirrors.ctan.org/macros/latex/contrib/uspace/uspace.pdf
    ' ' => raw"\enspace",  # 0.5em
    ' ' => raw"\quad",  # 1em
    ' ' => raw"\thickspace",  # \;
    ' ' => raw"\thinspace",  # \,
    ' ' => raw"\hspace{0.08333em}",  # hair space
    '–' => raw"\textnormal{\textendash}",  # \endash
    '—' => raw"\textnormal{\textemdash}",  # \emdash
    '‖' => raw"\Vert",  # \|
    '‘' => raw"\textnormal{\textquoteleft}",  # \lq
    '’' => raw"\textnormal{\textquoteright}",  # \rq
    # '‛' => raw"\reapos",
    '“' => raw"\textnormal{\textquotedblleft}",  # \ldq
    '”' => raw"\textnormal{\textquotedblright}",  # \rdq
    '†' => raw"\dagger",
    '‡' => raw"\ddagger",
    '•' => raw"\bullet",
    '…' => raw"\dots",  # \ldots
    '‰' => raw"\textnormal{\textperthousand}",  # \perthousand
    '‱' => raw"\textnormal{\textpertenthousand}",  # \pertenthousand
    '′' => raw"\prime",
    '″' => raw"\dprime",  # \pprime
    '‴' => raw"\trprime",  # \ppprime
    '‵' => raw"\backprime",
    '‶' => raw"\backdprime",  # \backpprime
    '‷' => raw"\backtrprime",  # \backppprime
    '‹' => raw"\textnormal{\guilsinglleft}",
    '›' => raw"\textnormal{\guilsinglright}",
    '⁀' => raw"\tieconcat",
    '⁗' => raw"\qprime",  # \pppprime
    # '⁝' => raw"\tricolon",
    '⁠' => raw"\nolinebreak",
    '⁰' => raw"{^0}",
    'ⁱ' => raw"{^i}",
    '⁴' => raw"{^4}",
    '⁵' => raw"{^5}",
    '⁶' => raw"{^6}",
    '⁷' => raw"{^7}",
    '⁸' => raw"{^8}",
    '⁹' => raw"{^9}",
    '⁺' => raw"{^+}",
    '⁻' => raw"{^-}",
    '⁼' => raw"{^=}",
    '⁽' => raw"{^(}",
    '⁾' => raw"{^)}",
    'ⁿ' => raw"{^n}",
    '₀' => raw"{_0}",
    '₁' => raw"{_1}",
    '₂' => raw"{_2}",
    '₃' => raw"{_3}",
    '₄' => raw"{_4}",
    '₅' => raw"{_5}",
    '₆' => raw"{_6}",
    '₇' => raw"{_7}",
    '₈' => raw"{_8}",
    '₉' => raw"{_9}",
    '₊' => raw"{_+}",
    '₋' => raw"{_-}",
    '₌' => raw"{_=}",
    '₍' => raw"{_(}",
    '₎' => raw"{_)}",
    'ₐ' => raw"{_a}",
    'ₑ' => raw"{_e}",
    'ₒ' => raw"{_o}",
    'ₓ' => raw"{_x}",
    # 'ₔ' => raw"{_\schwa}",
    'ₕ' => raw"{_h}",
    'ₖ' => raw"{_k}",
    'ₗ' => raw"{_l}",
    'ₘ' => raw"{_m}",
    'ₙ' => raw"{_n}",
    'ₚ' => raw"{_p}",
    'ₛ' => raw"{_s}",
    'ₜ' => raw"{_t}",
    # '₧' => raw"\pes",
    '€' => raw"\euro",
    # '⃐' => raw"\leftharpoonaccent{}",
    # '⃑' => raw"\rightharpoonaccent{}",
    # '⃒' => raw"\vertoverlay{}",
    # '⃖' => raw"\overleftarrow{}",
    # '⃗' => raw"\vec{}",
    # '⃛' => raw"\dddot{}",
    # '⃜' => raw"\ddddot{}",
    # '⃝' => raw"\enclosecircle{}",
    # '⃞' => raw"\enclosesquare{}",
    # '⃟' => raw"\enclosediamond{}",
    # '⃡' => raw"\overleftrightarrow{}",
    # '⃤' => raw"\enclosetriangle{}",
    # '⃧' => raw"\annuity{}",
    # '⃨' => raw"\threeunderdot{}",
    # '⃩' => raw"\widebridgeabove{}",
    # '⃬' => raw"\underrightharpoondown{}",
    # '⃭' => raw"\underleftharpoondown{}",
    # '⃮' => raw"\underleftarrow{}",
    # '⃯' => raw"\underrightarrow{}",
    # '⃰' => raw"\asteraccent{}",
    'ℂ' => raw"\mathbb{C}",
    'ℇ' => raw"\Eulerconst",  # \eulermascheroni
    'ℊ' => raw"\mathscr{g}",
    'ℋ' => raw"\mathscr{H}",
    'ℌ' => raw"\mathfrak{H}",
    'ℍ' => raw"\mathbb{H}",
    'ℎ' => raw"\Planckconst",  # \mathit{h}, \ith, \planck
    'ℏ' => raw"\hslash",
    'ℐ' => raw"\mathscr{I}",
    'ℑ' => raw"\Im",  # \mathfrak{I}
    'ℒ' => raw"\mathscr{L}",
    'ℓ' => raw"\ell",
    'ℕ' => raw"\mathbb{N}",
    '№' => raw"\textnormal{\textnumero}",  # \numero
    '℘' => raw"\wp",
    'ℙ' => raw"\mathbb{P}",
    'ℚ' => raw"\mathbb{Q}",
    'ℛ' => raw"\mathscr{R}",
    'ℜ' => raw"\Re",  # \mathfrak{R}
    'ℝ' => raw"\mathbb{R}",
    '℞' => raw"\textnormal{\textrecipe}",  # \xrat
    '™' => raw"\textnormal{\texttrademark}",  # \trademark
    'ℤ' => raw"\mathbb{Z}",
    'Ω' => raw"\Omega",  # \ohm
    '℧' => raw"\mho",
    'ℨ' => raw"\mathfrak{Z}",
    '℩' => raw"\turnediota",
    'Å' => raw"\Angstrom",
    'ℬ' => raw"\mathscr{B}",
    'ℭ' => raw"\mathfrak{C}",
    'ℯ' => raw"\mathscr{e}",  # \euler
    'ℰ' => raw"\mathscr{E}",
    'ℱ' => raw"\mathscr{F}",
    'Ⅎ' => raw"\Finv",
    'ℳ' => raw"\mathscr{M}",
    'ℴ' => raw"\mathscr{o}",
    'ℵ' => raw"\aleph",
    'ℶ' => raw"\beth",
    'ℷ' => raw"\gimel",
    'ℸ' => raw"\daleth",
    'ℼ' => raw"\mathbb{\pi}",
    'ℽ' => raw"\mathbb{\gamma}",
    'ℾ' => raw"\mathbb{\Gamma}",
    'ℿ' => raw"\mathbb{\Pi}",
    '⅀' => raw"\mathbb{\sum}",
    '⅁' => raw"\Game",
    '⅂' => raw"\sansLturned",
    '⅃' => raw"\sansLmirrored",
    '⅄' => raw"\Yup",
    'ⅅ' => raw"\mathbbit{D}",
    'ⅆ' => raw"\mathbbit{d}",
    'ⅇ' => raw"\mathbbit{e}",
    'ⅈ' => raw"\mathbbit{i}",
    'ⅉ' => raw"\mathbbit{j}",
    '⅊' => raw"\PropertyLine",
    '⅋' => raw"\upand",
    '⅐' => raw"\tfrac{1}{7}",
    '⅑' => raw"\tfrac{1}{9}",
    '⅒' => raw"\tfrac{1}{10}",
    '⅓' => raw"\tfrac{1}{3}",
    '⅔' => raw"\tfrac{2}{3}",
    '⅕' => raw"\tfrac{1}{5}",
    '⅖' => raw"\tfrac{2}{5}",
    '⅗' => raw"\tfrac{3}{5}",
    '⅘' => raw"\tfrac{4}{5}",
    '⅙' => raw"\tfrac{1}{6}",
    '⅚' => raw"\tfrac{5}{6}",
    '⅛' => raw"\tfrac{1}{8}",
    '⅜' => raw"\tfrac{3}{8}",
    '⅝' => raw"\tfrac{5}{8}",
    '⅞' => raw"\tfrac{7}{8}",
    '⅟' => raw"\tfrac{1}{}",
    '↉' => raw"\tfrac{0}{3}",
    '←' => raw"\leftarrow",  # \gets
    '↑' => raw"\uparrow",
    '→' => raw"\rightarrow",  # \to
    '↓' => raw"\downarrow",
    '↔' => raw"\leftrightarrow",
    '↕' => raw"\updownarrow",
    '↖' => raw"\nwarrow",
    '↗' => raw"\nearrow",
    '↘' => raw"\searrow",
    '↙' => raw"\swarrow",
    '↚' => raw"\nleftarrow",
    '↛' => raw"\nrightarrow",
    '↜' => raw"\leftwavearrow",
    '↝' => raw"\rightwavearrow",
    '↞' => raw"\twoheadleftarrow",
    '↟' => raw"\twoheaduparrow",
    '↠' => raw"\twoheadrightarrow",
    '↡' => raw"\twoheaddownarrow",
    '↢' => raw"\leftarrowtail",
    '↣' => raw"\rightarrowtail",
    '↤' => raw"\mapsfrom",
    '↥' => raw"\mapsup",
    '↦' => raw"\mapsto",
    '↧' => raw"\mapsdown",
    '↨' => raw"\updownarrowbar",
    '↩' => raw"\hookleftarrow",
    '↪' => raw"\hookrightarrow",
    '↫' => raw"\looparrowleft",
    '↬' => raw"\looparrowright",
    '↭' => raw"\leftrightsquigarrow",
    '↮' => raw"\nleftrightarrow",
    '↯' => raw"\downzigzagarrow",
    '↰' => raw"\Lsh",
    '↱' => raw"\Rsh",
    '↲' => raw"\Ldsh",
    '↳' => raw"\Rdsh",
    '↴' => raw"\linefeed",
    '↵' => raw"\carriagereturn",
    '↶' => raw"\curvearrowleft",
    '↷' => raw"\curvearrowright",
    '↸' => raw"\barovernorthwestarrow",
    '↹' => raw"\barleftarrowrightarrowbar",
    '↺' => raw"\circlearrowleft",
    '↻' => raw"\circlearrowright",
    '↼' => raw"\leftharpoonup",
    '↽' => raw"\leftharpoondown",
    '↾' => raw"\upharpoonright",
    '↿' => raw"\upharpoonleft",
    '⇀' => raw"\rightharpoonup",
    '⇁' => raw"\rightharpoondown",
    '⇂' => raw"\downharpoonright",
    '⇃' => raw"\downharpoonleft",
    '⇄' => raw"\rightleftarrows",
    '⇅' => raw"\updownarrows",  # \dblarrowupdown
    '⇆' => raw"\leftrightarrows",
    '⇇' => raw"\leftleftarrows",
    '⇈' => raw"\upuparrows",
    '⇉' => raw"\rightrightarrows",
    '⇊' => raw"\downdownarrows",
    '⇋' => raw"\leftrightharpoons",
    '⇌' => raw"\rightleftharpoons",
    '⇍' => raw"\nLeftarrow",
    '⇎' => raw"\nLeftrightarrow",
    '⇏' => raw"\nRightarrow",
    '⇐' => raw"\Leftarrow",
    '⇑' => raw"\Uparrow",
    '⇒' => raw"\Rightarrow",
    '⇓' => raw"\Downarrow",
    '⇔' => raw"\Leftrightarrow",
    '⇕' => raw"\Updownarrow",
    '⇖' => raw"\Nwarrow",
    '⇗' => raw"\Nearrow",
    '⇘' => raw"\Searrow",
    '⇙' => raw"\Swarrow",
    '⇚' => raw"\Lleftarrow",
    '⇛' => raw"\Rrightarrow",
    '⇜' => raw"\leftsquigarrow",
    '⇝' => raw"\rightsquigarrow",
    '⇞' => raw"\nHuparrow",
    '⇟' => raw"\nHdownarrow",
    '⇠' => raw"\leftdasharrow",
    '⇡' => raw"\updasharrow",
    '⇢' => raw"\rightdasharrow",
    '⇣' => raw"\downdasharrow",
    '⇤' => raw"\barleftarrow",
    '⇥' => raw"\rightarrowbar",
    '⇦' => raw"\leftwhitearrow",
    '⇧' => raw"\upwhitearrow",
    '⇨' => raw"\rightwhitearrow",
    '⇩' => raw"\downwhitearrow",
    '⇪' => raw"\whitearrowupfrombar",
    '⇴' => raw"\circleonrightarrow",
    '⇵' => raw"\downuparrows",  # \DownArrowUpArrow
    '⇶' => raw"\rightthreearrows",
    '⇷' => raw"\nvleftarrow",
    '⇸' => raw"\nvrightarrow",
    '⇹' => raw"\nvleftrightarrow",
    '⇺' => raw"\nVleftarrow",
    '⇻' => raw"\nVrightarrow",
    '⇼' => raw"\nVleftrightarrow",
    '⇽' => raw"\leftarrowtriangle",
    '⇾' => raw"\rightarrowtriangle",
    '⇿' => raw"\leftrightarrowtriangle",
    '∀' => raw"\forall",
    '∁' => raw"\complement",
    '∂' => raw"\partial",
    '∃' => raw"\exists",
    '∄' => raw"\nexists",
    '∅' => raw"\emptyset",  # \O, \varnothing
    '∆' => raw"\increment",
    '∇' => raw"\nabla",  # \del
    '∈' => raw"\in",
    '∉' => raw"\notin",
    '∊' => raw"\smallin",
    '∋' => raw"\ni",
    '∌' => raw"\nni",
    '∍' => raw"\smallni",
    '∎' => raw"\QED",
    '∏' => raw"\prod",
    '∐' => raw"\coprod",
    '∑' => raw"\sum",
    '−' => raw"\minus",
    '∓' => raw"\mp",
    '∔' => raw"\dotplus",
    '∖' => raw"\setminus",
    '∗' => raw"\ast",
    '∘' => raw"\circ",
    '∙' => raw"\vysmblkcircle",
    '√' => raw"\sqrt{}",  # \surd
    '∛' => raw"\cuberoot{}",  # \cbrt
    '∜' => raw"\fourthroot{}",
    '∝' => raw"\propto",
    '∞' => raw"\infty",
    '∟' => raw"\rightangle",
    '∠' => raw"\angle",
    '∡' => raw"\measuredangle",
    '∢' => raw"\sphericalangle",
    '∣' => raw"\mid",
    '∤' => raw"\nmid",
    '∥' => raw"\parallel",
    '∦' => raw"\nparallel",
    '∧' => raw"\wedge",
    '∨' => raw"\vee",
    '∩' => raw"\cap",
    '∪' => raw"\cup",
    '∫' => raw"\int",
    '∬' => raw"\iint",
    '∭' => raw"\iiint",
    '∮' => raw"\oint",
    '∯' => raw"\oiint",
    '∰' => raw"\oiiint",
    '∱' => raw"\intclockwise",  # \clwintegral
    '∲' => raw"\varointclockwise",
    '∳' => raw"\ointctrclockwise",
    '∴' => raw"\therefore",
    '∵' => raw"\because",
    '∷' => raw"\Colon",
    '∸' => raw"\dotminus",
    '∺' => raw"\dotsminusdots",
    '∻' => raw"\kernelcontraction",
    '∼' => raw"\sim",
    '∽' => raw"\backsim",
    '∾' => raw"\invlazys",  # \lazysinv
    '∿' => raw"\sinewave",
    '≀' => raw"\wr",
    '≁' => raw"\nsim",
    '≂' => raw"\eqsim",
    "≂̸" => raw"\not\eqsim",  # \neqsim
    '≃' => raw"\simeq",
    '≄' => raw"\nsime",
    '≅' => raw"\cong",
    '≆' => raw"\simneqq",  # \approxnotequal
    '≇' => raw"\ncong",
    '≈' => raw"\approx",
    '≉' => raw"\napprox",
    '≊' => raw"\approxeq",
    '≋' => raw"\approxident",  # \tildetrpl
    '≌' => raw"\backcong",  # \allequal
    '≍' => raw"\asymp",
    '≎' => raw"\Bumpeq",
    "≎̸" => raw"\not\Bumpeq",  # \nBumpeq
    '≏' => raw"\bumpeq",
    "≏̸" => raw"\not\bumpeq",  # \nbumpeq
    '≐' => raw"\doteq",
    '≑' => raw"\Doteq",
    '≒' => raw"\fallingdotseq",
    '≓' => raw"\risingdotseq",
    '≔' => raw"\coloneq",
    '≕' => raw"\eqcolon",
    '≖' => raw"\eqcirc",
    '≗' => raw"\circeq",
    '≘' => raw"\arceq",
    '≙' => raw"\wedgeq",
    '≚' => raw"\veeeq",
    '≛' => raw"\stareq",  # \starequal
    '≜' => raw"\triangleq",
    '≝' => raw"\eqdef",
    '≞' => raw"\measeq",
    '≟' => raw"\questeq",
    '≠' => raw"\ne",
    '≡' => raw"\equiv",
    '≢' => raw"\nequiv",
    '≣' => raw"\Equiv",
    '≤' => raw"\leq",  # \les \le
    '≥' => raw"\geq",  # \le
    '≦' => raw"\leqq",
    '≧' => raw"\geqq",
    '≨' => raw"\lneqq",
    "≨︀" => raw"\lvertneqq",
    '≩' => raw"\gneqq",
    "≩︀" => raw"\gvertneqq",
    '≪' => raw"\ll",
    "≪̸" => raw"\not\ll",  # \NotLessLess
    '≫' => raw"\gg",
    "≫̸" => raw"\not\gg",  # \NotGreaterGreater
    '≬' => raw"\between",
    '≭' => raw"\nasymp",
    '≮' => raw"\nless",
    '≯' => raw"\ngtr",
    '≰' => raw"\nleq",
    '≱' => raw"\ngeq",
    '≲' => raw"\lesssim",
    '≳' => raw"\gtrsim",
    '≴' => raw"\nlesssim",
    '≵' => raw"\ngtrsim",
    '≶' => raw"\lessgtr",
    '≷' => raw"\gtrless",
    '≸' => raw"\not\lessgtr",  # \notlessgreater
    '≹' => raw"\not\gtrless",  # \notgreaterless
    '≺' => raw"\prec",
    '≻' => raw"\succ",
    '≼' => raw"\preccurlyeq",
    '≽' => raw"\succcurlyeq",
    '≾' => raw"\precsim",
    "≾̸" => raw"\not\precsim",  # \nprecsim
    '≿' => raw"\succsim",
    "≿̸" => raw"\not\succsim",  # \nsuccsim
    '⊀' => raw"\nprec",
    '⊁' => raw"\nsucc",
    '⊂' => raw"\subset",
    '⊃' => raw"\supset",
    '⊄' => raw"\nsubset",
    '⊅' => raw"\nsupset",
    '⊆' => raw"\subseteq",
    '⊇' => raw"\supseteq",
    '⊈' => raw"\nsubseteq",
    '⊉' => raw"\nsupseteq",
    '⊊' => raw"\subsetneq",
    "⊊︀" => raw"\varsubsetneqq",
    '⊋' => raw"\supsetneq",
    "⊋︀" => raw"\varsupsetneq",
    '⊍' => raw"\cupdot",
    '⊎' => raw"\uplus",
    '⊏' => raw"\sqsubset",
    "⊏̸" => raw"\not\sqsubset",  # \NotSquareSubset
    '⊐' => raw"\sqsupset",
    "⊐̸" => raw"\not\sqsupset",  # \NotSquareSuperset
    '⊑' => raw"\sqsubseteq",
    '⊒' => raw"\sqsupseteq",
    '⊓' => raw"\sqcap",
    '⊔' => raw"\sqcup",
    '⊕' => raw"\oplus",
    '⊖' => raw"\ominus",
    '⊗' => raw"\otimes",
    '⊘' => raw"\oslash",
    '⊙' => raw"\odot",
    '⊚' => raw"\circledcirc",
    '⊛' => raw"\circledast",
    '⊜' => raw"\circledequal",
    '⊝' => raw"\circleddash",
    '⊞' => raw"\boxplus",
    '⊟' => raw"\boxminus",
    '⊠' => raw"\boxtimes",
    '⊡' => raw"\boxdot",
    '⊢' => raw"\vdash",
    '⊣' => raw"\dashv",
    '⊤' => raw"\top",
    '⊥' => raw"\bot",
    '⊧' => raw"\models",
    '⊨' => raw"\vDash",
    '⊩' => raw"\Vdash",
    '⊪' => raw"\Vvdash",
    '⊫' => raw"\VDash",
    '⊬' => raw"\nvdash",
    '⊭' => raw"\nvDash",
    '⊮' => raw"\nVdash",
    '⊯' => raw"\nVDash",
    '⊰' => raw"\prurel",
    '⊱' => raw"\scurel",
    '⊲' => raw"\vartriangleleft",
    '⊳' => raw"\vartriangleright",
    '⊴' => raw"\trianglelefteq",
    '⊵' => raw"\trianglerighteq",
    '⊶' => raw"\origof",  # \original
    '⊷' => raw"\imageof",  # \image
    '⊸' => raw"\multimap",
    '⊹' => raw"\hermitmatrix",  # \hermitconjmatrix
    '⊺' => raw"\intercal",
    '⊻' => raw"\veebar",  # \xor
    '⊼' => raw"\barwedge",  # \nand
    '⊽' => raw"\barvee",
    '⊾' => raw"\measuredrightangle",  # \rightanglearc
    '⊿' => raw"\varlrtriangle",
    '⋀' => raw"\bigwedge",
    '⋁' => raw"\bigvee",
    '⋂' => raw"\bigcap",
    '⋃' => raw"\bigcup",
    '⋄' => raw"\diamond",
    '⋅' => raw"\cdot",
    '⋆' => raw"\star",
    '⋇' => raw"\divideontimes",
    '⋈' => raw"\bowtie",
    '⋉' => raw"\ltimes",
    '⋊' => raw"\rtimes",
    '⋋' => raw"\leftthreetimes",
    '⋌' => raw"\rightthreetimes",
    '⋍' => raw"\backsimeq",
    '⋎' => raw"\curlyvee",
    '⋏' => raw"\curlywedge",
    '⋐' => raw"\Subset",
    '⋑' => raw"\Supset",
    '⋒' => raw"\Cap",
    '⋓' => raw"\Cup",
    '⋔' => raw"\pitchfork",
    '⋕' => raw"\equalparallel",
    '⋖' => raw"\lessdot",
    '⋗' => raw"\gtrdot",
    '⋘' => raw"\lll",  # \verymuchless
    '⋙' => raw"\ggg",
    '⋚' => raw"\lesseqgtr",
    '⋛' => raw"\gtreqless",
    '⋜' => raw"\eqless",
    '⋝' => raw"\eqgtr",
    '⋞' => raw"\curlyeqprec",
    '⋟' => raw"\curlyeqsucc",
    '⋠' => raw"\npreccurlyeq",
    '⋡' => raw"\nsucccurlyeq",
    '⋢' => raw"\nsqsubseteq",
    '⋣' => raw"\nsqsupseteq",
    '⋤' => raw"\sqsubsetneq",
    '⋥' => raw"\sqsupsetneq",  # \sqspne
    '⋦' => raw"\lnsim",
    '⋧' => raw"\gnsim",
    '⋨' => raw"\precnsim",
    '⋩' => raw"\succnsim",
    '⋪' => raw"\ntriangleleft",
    '⋫' => raw"\ntriangleright",
    '⋬' => raw"\ntrianglelefteq",
    '⋭' => raw"\ntrianglerighteq",
    '⋮' => raw"\vdots",
    '⋯' => raw"\cdots",
    '⋰' => raw"\adots",
    '⋱' => raw"\ddots",
    '⋲' => raw"\disin",
    '⋳' => raw"\varisins",
    '⋴' => raw"\isins",
    '⋵' => raw"\isindot",
    '⋶' => raw"\varisinobar",
    '⋷' => raw"\isinobar",
    '⋸' => raw"\isinvb",
    '⋹' => raw"\isinE",
    '⋺' => raw"\nisd",
    '⋻' => raw"\varnis",
    '⋼' => raw"\nis",
    '⋽' => raw"\varniobar",
    '⋾' => raw"\niobar",
    '⋿' => raw"\bagmember",
    '⌀' => raw"\diameter",
    '⌂' => raw"\house",
    '⌅' => raw"\varbarwedge",
    '⌆' => raw"\vardoublebarwedge",
    '⌈' => raw"\lceil",
    '⌉' => raw"\rceil",
    '⌊' => raw"\lfloor",
    '⌋' => raw"\rfloor",
    '⌐' => raw"\invnot",
    '⌑' => raw"\sqlozenge",
    '⌒' => raw"\profline",
    '⌓' => raw"\profsurf",
    # '⌕' => raw"\recorder",
    '⌗' => raw"\viewdata",
    '⌙' => raw"\turnednot",
    '⌜' => raw"\ulcorner",
    '⌝' => raw"\urcorner",
    '⌞' => raw"\llcorner",
    '⌟' => raw"\lrcorner",
    '⌢' => raw"\frown",
    '⌣' => raw"\smile",
    '⌬' => raw"\varhexagonlrbonds",
    '⌲' => raw"\conictaper",
    '⌶' => raw"\topbot",
    '⌽' => raw"\obar",
    '⌿' => raw"\APLnotslash",  # \notslash
    '⍀' => raw"\APLnotbackslash",  # \notbackslash
    '⍓' => raw"\APLboxupcaret",  # \boxupcaret
    '⍰' => raw"\APLboxquestion",  # \boxquestion
    '⎔' => raw"\hexagon",
    '⎣' => raw"\lbracklend",  # \dlcorn
    '⎰' => raw"\lmoustache",
    '⎱' => raw"\rmoustache",
    '⎴' => raw"\overbracket{}",
    '⎵' => raw"\underbracket{}",
    '⎶' => raw"\bbrktbrk",
    '⎷' => raw"\sqrtbottom",
    '⎸' => raw"\lvboxline",
    '⎹' => raw"\rvboxline",
    '⏎' => raw"\varcarriagereturn",
    '⏞' => raw"\overbrace{}",
    '⏟' => raw"\underbrace{}",
    '⏢' => raw"\trapezium",
    '⏣' => raw"\benzenr",
    '⏤' => raw"\strns",
    '⏥' => raw"\fltns",
    '⏦' => raw"\accurrent",
    '⏧' => raw"\elinters",
    '␢' => raw"\blanksymbol",
    '␣' => raw"\mathvisiblespace",  # \visiblespace
    'Ⓢ' => raw"\circledS",
    '┆' => raw"\bdtriplevdash",  # \dshfnc
    # '┙' => raw"\sqfnw",
    '╱' => raw"\diagup",
    '╲' => raw"\diagdown",
    '▀' => raw"\blockuphalf",
    '▄' => raw"\blocklowhalf",
    '█' => raw"\blockfull",
    '▌' => raw"\blocklefthalf",
    '▐' => raw"\blockrighthalf",
    '░' => raw"\blockqtrshaded",
    '▒' => raw"\blockhalfshaded",
    '▓' => raw"\blockthreeqtrshaded",
    '■' => raw"\blacksquare",
    '□' => raw"\square",
    '▢' => raw"\squoval",
    '▣' => raw"\blackinwhitesquare",
    '▤' => raw"\squarehfill",
    '▥' => raw"\squarevfill",
    '▦' => raw"\squarehvfill",
    '▧' => raw"\squarenwsefill",
    '▨' => raw"\squareneswfill",
    '▩' => raw"\squarecrossfill",
    '▪' => raw"\smblksquare",
    '▫' => raw"\smwhtsquare",
    '▬' => raw"\hrectangleblack",
    '▭' => raw"\hrectangle",
    '▮' => raw"\vrectangleblack",
    '▯' => raw"\vrectangle",  # \vrecto
    '▰' => raw"\parallelogramblack",
    '▱' => raw"\parallelogram",
    '▲' => raw"\bigblacktriangleup",
    '△' => raw"\bigtriangleup",
    '▴' => raw"\blacktriangle",
    '▵' => raw"\vartriangle",
    '▶' => raw"\blacktriangleright",
    '▷' => raw"\triangleright",
    '▸' => raw"\smallblacktriangleright",
    '▹' => raw"\smalltriangleright",
    '►' => raw"\blackpointerright",
    '▻' => raw"\whitepointerright",
    '▼' => raw"\bigblacktriangledown",
    '▽' => raw"\bigtriangledown",
    '▾' => raw"\blacktriangledown",
    '▿' => raw"\triangledown",
    '◀' => raw"\blacktriangleleft",
    '◁' => raw"\triangleleft",
    '◂' => raw"\smallblacktriangleleft",
    '◃' => raw"\smalltriangleleft",
    '◄' => raw"\blackpointerleft",
    '◅' => raw"\whitepointerleft",
    '◆' => raw"\mdlgblkdiamond",
    '◇' => raw"\mdlgwhtdiamond",
    '◈' => raw"\blackinwhitediamond",
    '◉' => raw"\fisheye",
    '◊' => raw"\lozenge",
    '○' => raw"\bigcirc",
    '◌' => raw"\dottedcircle",
    '◍' => raw"\circlevertfill",
    '◎' => raw"\bullseye",
    '●' => raw"\mdlgblkcircle",
    '◐' => raw"\circlelefthalfblack",  # \cirfl
    '◑' => raw"\circlerighthalfblack",  # \cirfr
    '◒' => raw"\circlebottomhalfblack",  # \cirfb
    '◓' => raw"\circletophalfblack",
    '◔' => raw"\circleurquadblack",
    '◕' => raw"\blackcircleulquadwhite",
    '◖' => raw"\blacklefthalfcircle",
    '◗' => raw"\blackrighthalfcircle",
    '◘' => raw"\inversebullet",  # \rvbull
    '◙' => raw"\inversewhitecircle",
    '◚' => raw"\invwhiteupperhalfcircle",
    '◛' => raw"\invwhitelowerhalfcircle",
    '◜' => raw"\ularc",
    '◝' => raw"\urarc",
    '◞' => raw"\lrarc",
    '◟' => raw"\llarc",
    '◠' => raw"\topsemicircle",
    '◡' => raw"\botsemicircle",
    '◢' => raw"\lrblacktriangle",
    '◣' => raw"\llblacktriangle",
    '◤' => raw"\ulblacktriangle",
    '◥' => raw"\urblacktriangle",
    '◦' => raw"\smwhtcircle",
    '◧' => raw"\squareleftblack",  # \sqfl
    '◨' => raw"\squarerightblack",  # \sqfr
    '◩' => raw"\squareulblack",
    '◪' => raw"\squarelrblack",  # \sqfse
    '◫' => raw"\boxbar",
    '◬' => raw"\trianglecdot",
    '◭' => raw"\triangleleftblack",
    '◮' => raw"\trianglerightblack",
    '◯' => raw"\lgwhtcircle",
    '◰' => raw"\squareulquad",
    '◱' => raw"\squarellquad",
    '◲' => raw"\squarelrquad",
    '◳' => raw"\squareurquad",
    '◴' => raw"\circleulquad",
    '◵' => raw"\circlellquad",
    '◶' => raw"\circlelrquad",
    '◷' => raw"\circleurquad",
    '◸' => raw"\ultriangle",
    '◹' => raw"\urtriangle",
    '◺' => raw"\lltriangle",
    '◻' => raw"\mdwhtsquare",
    '◼' => raw"\mdblksquare",
    '◽' => raw"\mdsmwhtsquare",
    '◾' => raw"\mdsmblksquare",
    '◿' => raw"\lrtriangle",
    '★' => raw"\bigstar",
    '☆' => raw"\bigwhitestar",
    '☉' => raw"\astrosun",
    '☡' => raw"\danger",
    '☻' => raw"\blacksmiley",
    '☼' => raw"\sun",
    '☽' => raw"\rightmoon",
    '☾' => raw"\leftmoon",
    # '☿' => raw"\mercury",
    '♀' => raw"\female",  # \venus
    '♂' => raw"\male",  # \mars
    # '♃' => raw"\jupiter",  # `marvosym` or `wasysym`
    # '♄' => raw"\saturn",
    # '♅' => raw"\uranus",
    # '♆' => raw"\neptune",
    # '♇' => raw"\pluto",
    # '♈' => raw"\aries",
    # '♉' => raw"\taurus",
    # '♊' => raw"\gemini",
    # '♋' => raw"\cancer",
    # '♌' => raw"\leo",
    # '♍' => raw"\virgo",
    # '♎' => raw"\libra",
    # '♏' => raw"\scorpio",
    # '♐' => raw"\sagittarius",
    # '♑' => raw"\capricornus",
    # '♒' => raw"\aquarius",
    # '♓' => raw"\pisces",
    '♠' => raw"\spadesuit",
    '♡' => raw"\heartsuit",
    '♢' => raw"\diamondsuit",
    '♣' => raw"\clubsuit",
    '♤' => raw"\varspadesuit",
    '♥' => raw"\varheartsuit",
    '♦' => raw"\vardiamondsuit",
    '♧' => raw"\varclubsuit",
    '♩' => raw"\quarternote",
    '♪' => raw"\eighthnote",
    '♫' => raw"\twonotes",
    '♭' => raw"\flat",
    '♮' => raw"\natural",
    '♯' => raw"\sharp",
    '♾' => raw"\acidfree",
    '⚀' => raw"\dicei",
    '⚁' => raw"\diceii",
    '⚂' => raw"\diceiii",
    '⚃' => raw"\diceiv",
    '⚄' => raw"\dicev",
    '⚅' => raw"\dicevi",
    '⚆' => raw"\circledrightdot",
    '⚇' => raw"\circledtwodots",
    '⚈' => raw"\blackcircledrightdot",
    '⚉' => raw"\blackcircledtwodots",
    '⚥' => raw"\Hermaphrodite",  # \hermaphrodite
    '⚪' => raw"\mdwhtcircle",
    '⚫' => raw"\mdblkcircle",
    '⚬' => raw"\mdsmwhtcircle",
    '⚲' => raw"\neuter",
    '✓' => raw"\checkmark",
    '✠' => raw"\maltese",
    '✪' => raw"\circledstar",
    '✶' => raw"\varstar",
    '✽' => raw"\dingasterisk",
    '➛' => raw"\draftingarrow",
    '⟀' => raw"\threedangle",
    '⟁' => raw"\whiteinwhitetriangle",
    '⟂' => raw"\perp",
    '⟈' => raw"\bsolhsub",
    '⟉' => raw"\suphsol",
    '⟑' => raw"\wedgedot",
    '⟒' => raw"\upin",
    '⟕' => raw"\leftouterjoin",
    '⟖' => raw"\rightouterjoin",
    '⟗' => raw"\fullouterjoin",
    '⟘' => raw"\bigbot",
    '⟙' => raw"\bigtop",
    '⟦' => raw"\lBrack",  # \llbracket, \openbracketleft
    '⟧' => raw"\rBrack",  # \rrbracket, \openbracketright
    '⟨' => raw"\langle",
    '⟩' => raw"\rangle",
    '⟰' => raw"\UUparrow",
    '⟱' => raw"\DDownarrow",
    '⟵' => raw"\longleftarrow",
    '⟶' => raw"\longrightarrow",
    '⟷' => raw"\longleftrightarrow",
    '⟸' => raw"\Longleftarrow",  # \impliedby
    '⟹' => raw"\Longrightarrow",  # \implies
    '⟺' => raw"\Longleftrightarrow",  # \iff
    '⟻' => raw"\longmapsfrom",
    '⟼' => raw"\longmapsto",
    '⟽' => raw"\Longmapsfrom",
    '⟾' => raw"\Longmapsto",
    '⟿' => raw"\longrightsquigarrow",
    '⤀' => raw"\nvtwoheadrightarrow",
    '⤁' => raw"\nVtwoheadrightarrow",
    '⤂' => raw"\nvLeftarrow",
    '⤃' => raw"\nvRightarrow",
    '⤄' => raw"\nvLeftrightarrow",
    '⤅' => raw"\twoheadmapsto",
    '⤆' => raw"\Mapsfrom",
    '⤇' => raw"\Mapsto",
    '⤈' => raw"\downarrowbarred",
    '⤉' => raw"\uparrowbarred",
    '⤊' => raw"\Uuparrow",
    '⤋' => raw"\Ddownarrow",
    '⤌' => raw"\leftbkarrow",
    '⤍' => raw"\rightbkarrow",  # \bkarow
    '⤎' => raw"\leftdbkarrow",
    '⤏' => raw"\dbkarow",
    '⤐' => raw"\drbkarrow",
    '⤑' => raw"\rightdotarrow",
    '⤒' => raw"\baruparrow",  # \UpArrowBar
    '⤓' => raw"\downarrowbar",  # \DownArrowBar
    '⤔' => raw"\nvrightarrowtail",
    '⤕' => raw"\nVrightarrowtail",
    '⤖' => raw"\twoheadrightarrowtail",
    '⤗' => raw"\nvtwoheadrightarrowtail",
    '⤘' => raw"\nVtwoheadrightarrowtail",
    '⤝' => raw"\diamondleftarrow",
    '⤞' => raw"\rightarrowdiamond",
    '⤟' => raw"\diamondleftarrowbar",
    '⤠' => raw"\barrightarrowdiamond",
    '⤥' => raw"\hksearow",
    '⤦' => raw"\hkswarow",
    '⤧' => raw"\tona",
    '⤨' => raw"\toea",
    '⤩' => raw"\tosa",
    '⤪' => raw"\towa",
    '⤫' => raw"\rdiagovfdiag",
    '⤬' => raw"\fdiagovrdiag",
    '⤭' => raw"\seovnearrow",
    '⤮' => raw"\neovsearrow",
    '⤯' => raw"\fdiagovnearrow",
    '⤰' => raw"\rdiagovsearrow",
    '⤱' => raw"\neovnwarrow",
    '⤲' => raw"\nwovnearrow",
    '⥂' => raw"\rightarrowshortleftarrow",  # \Rlarr
    '⥄' => raw"\leftarrowshortrightarrow",  # \rLarr
    '⥅' => raw"\rightarrowplus",
    '⥆' => raw"\leftarrowplus",
    '⥇' => raw"\rightarrowx",  # \rarrx
    '⥈' => raw"\leftrightarrowcircle",
    '⥉' => raw"\twoheaduparrowcircle",
    '⥊' => raw"\leftrightharpoonupdown",
    '⥋' => raw"\leftrightharpoondownup",
    '⥌' => raw"\updownharpoonrightleft",
    '⥍' => raw"\updownharpoonleftright",
    '⥎' => raw"\leftrightharpoonupup",  # \LeftRightVector
    '⥏' => raw"\updownharpoonrightright",  # \RightUpDownVector
    '⥐' => raw"\leftrightharpoondowndown",  # \DownLeftRightVector
    '⥑' => raw"\updownharpoonleftleft",  # \LeftUpDownVector
    '⥒' => raw"\barleftharpoonup",  # \LeftVectorBar
    '⥓' => raw"\rightharpoonupbar",  # \RightVectorBar
    '⥔' => raw"\barupharpoonright",  # \RightUpVectorBar
    '⥕' => raw"\downharpoonrightbar",  # \RightDownVectorBar
    '⥖' => raw"\barleftharpoondown",  # \DownLeftVectorBar
    '⥗' => raw"\rightharpoondownbar",  # \DownRightVectorBar
    '⥘' => raw"\barupharpoonleft",  # \LeftUpVectorBar
    '⥙' => raw"\downharpoonleftbar",  # \LeftDownVectorBar
    '⥚' => raw"\leftharpoonupbar",  # \LeftTeeVector
    '⥛' => raw"\barrightharpoonup",  # \RightTeeVector
    '⥜' => raw"\upharpoonrightbar",  # \RightUpTeeVector
    '⥝' => raw"\bardownharpoonright",  # \RightDownTeeVector
    '⥞' => raw"\leftharpoondownbar",  # \DownLeftTeeVector
    '⥟' => raw"\barrightharpoondown",  # \DownRightTeeVector
    '⥠' => raw"\upharpoonleftbar",  # \LeftUpTeeVector
    '⥡' => raw"\bardownharpoonleft",  # \LeftDownTeeVector
    '⥢' => raw"\leftharpoonsupdown",
    '⥣' => raw"\upharpoonsleftright",
    '⥤' => raw"\rightharpoonsupdown",
    '⥥' => raw"\downharpoonsleftright",
    '⥦' => raw"\leftrightharpoonsup",
    '⥧' => raw"\leftrightharpoonsdown",
    '⥨' => raw"\rightleftharpoonsup",
    '⥩' => raw"\rightleftharpoonsdown",
    '⥪' => raw"\leftharpoonupdash",
    '⥫' => raw"\dashleftharpoondown",
    '⥬' => raw"\rightharpoonupdash",
    '⥭' => raw"\dashrightharpoondown",
    '⥮' => raw"\updownharpoonsleftright",  # \UpEquilibrium
    '⥯' => raw"\downupharpoonsleftright",  # \ReverseUpEquilibrium
    '⥰' => raw"\rightimply",  # \RoundImplies
    '⦀' => raw"\Vvert",
    '⦆' => raw"\rParen",  # \Elroang
    '⦙' => raw"\fourvdots",  # \ddfnc
    '⦛' => raw"\measuredangleleft",
    '⦜' => raw"\rightanglesqr",  # \Angle
    '⦝' => raw"\rightanglemdot",
    '⦞' => raw"\angles",
    '⦟' => raw"\angdnr",
    '⦠' => raw"\gtlpar",  # \lpargt
    '⦡' => raw"\sphericalangleup",
    '⦢' => raw"\turnangle",
    '⦣' => raw"\revangle",
    '⦤' => raw"\angleubar",
    '⦥' => raw"\revangleubar",
    '⦦' => raw"\wideangledown",
    '⦧' => raw"\wideangleup",
    '⦨' => raw"\measanglerutone",
    '⦩' => raw"\measanglelutonw",
    '⦪' => raw"\measanglerdtose",
    '⦫' => raw"\measangleldtosw",
    '⦬' => raw"\measangleurtone",
    '⦭' => raw"\measangleultonw",
    '⦮' => raw"\measangledrtose",
    '⦯' => raw"\measangledltosw",
    '⦰' => raw"\revemptyset",
    '⦱' => raw"\emptysetobar",
    '⦲' => raw"\emptysetocirc",
    '⦳' => raw"\emptysetoarr",
    '⦴' => raw"\emptysetoarrl",
    '⦷' => raw"\circledparallel",
    '⦸' => raw"\obslash",
    '⦼' => raw"\odotslashdot",
    '⦾' => raw"\circledwhitebullet",
    '⦿' => raw"\circledbullet",
    '⧀' => raw"\olessthan",
    '⧁' => raw"\ogreaterthan",
    '⧄' => raw"\boxdiag",
    '⧅' => raw"\boxbslash",
    '⧆' => raw"\boxast",
    '⧇' => raw"\boxcircle",
    '⧊' => raw"\triangleodot",  # \Lap
    '⧋' => raw"\triangleubar",  # \defas
    '⧏' => raw"\ltrivb",  # \LeftTriangleBar
    "⧏̸" => raw"\not\ltrivb",  # \NotLeftTriangleBar
    '⧐' => raw"\vbrtri",  # \RightTriangleBar
    "⧐̸" => raw"\not\vbrtri",  # \NotRightTriangleBar
    '⧟' => raw"\dualmap",
    '⧡' => raw"\lrtriangleeq",
    '⧢' => raw"\shuffle",
    '⧣' => raw"\eparsl",
    '⧤' => raw"\smeparsl",
    '⧥' => raw"\eqvparsl",
    '⧫' => raw"\blacklozenge",
    '⧴' => raw"\ruledelayed",  # \RuleDelayed
    '⧶' => raw"\dsol",
    '⧷' => raw"\rsolbar",
    '⧺' => raw"\doubleplus",
    '⧻' => raw"\tripleplus",
    '⨀' => raw"\bigodot",
    '⨁' => raw"\bigoplus",
    '⨂' => raw"\bigotimes",
    '⨃' => raw"\bigcupdot",
    '⨄' => raw"\biguplus",
    '⨅' => raw"\bigsqcap",
    '⨆' => raw"\bigsqcup",
    '⨇' => raw"\conjquant",
    '⨈' => raw"\disjquant",
    '⨉' => raw"\bigtimes",
    '⨊' => raw"\modtwosum",
    '⨋' => raw"\sumint",
    '⨌' => raw"\iiiint",
    '⨍' => raw"\intbar",
    '⨎' => raw"\intBar",
    '⨏' => raw"\fint",  # \clockoint
    '⨐' => raw"\cirfnint",
    '⨑' => raw"\awint",
    '⨒' => raw"\rppolint",
    '⨓' => raw"\scpolint",
    '⨔' => raw"\npolint",
    '⨕' => raw"\pointint",
    '⨖' => raw"\sqint",  # \sqrint
    '⨘' => raw"\intx",
    '⨙' => raw"\intcap",
    '⨚' => raw"\intcup",
    '⨛' => raw"\upint",
    '⨜' => raw"\lowint",
    '⨝' => raw"\Join",  # \join
    '⨟' => raw"\zcmp",  # \bbsemi
    '⨢' => raw"\ringplus",
    '⨣' => raw"\plushat",
    '⨤' => raw"\simplus",
    '⨥' => raw"\plusdot",
    '⨦' => raw"\plussim",
    '⨧' => raw"\plussubtwo",
    '⨨' => raw"\plustrif",
    '⨩' => raw"\commaminus",
    '⨪' => raw"\minusdot",
    '⨫' => raw"\minusfdots",
    '⨬' => raw"\minusrdots",
    '⨭' => raw"\opluslhrim",
    '⨮' => raw"\oplusrhrim",
    '⨯' => raw"\vectimes",  # \Times
    '⨰' => raw"\dottimes",
    '⨱' => raw"\timesbar",
    '⨲' => raw"\btimes",
    '⨳' => raw"\smashtimes",
    '⨴' => raw"\otimeslhrim",
    '⨵' => raw"\otimesrhrim",
    '⨶' => raw"\otimeshat",
    '⨷' => raw"\Otimes",
    '⨸' => raw"\odiv",
    '⨹' => raw"\triangleplus",
    '⨺' => raw"\triangleminus",
    '⨻' => raw"\triangletimes",
    '⨼' => raw"\intprod",
    '⨽' => raw"\intprodr",
    '⨿' => raw"\amalg",
    '⩀' => raw"\capdot",
    '⩁' => raw"\uminus",
    '⩂' => raw"\barcup",
    '⩃' => raw"\barcap",
    '⩄' => raw"\capwedge",
    '⩅' => raw"\cupvee",
    '⩊' => raw"\twocups",
    '⩋' => raw"\twocaps",
    '⩌' => raw"\closedvarcup",
    '⩍' => raw"\closedvarcap",
    '⩎' => raw"\Sqcap",
    '⩏' => raw"\Sqcup",
    '⩐' => raw"\closedvarcupsmashprod",
    '⩑' => raw"\wedgeodot",
    '⩒' => raw"\veeodot",
    '⩓' => raw"\Wedge",  # \And
    '⩔' => raw"\Vee",  # \Or
    '⩕' => raw"\wedgeonwedge",
    '⩖' => raw"\veeonvee",  # \ElOr
    '⩗' => raw"\bigslopedvee",
    '⩘' => raw"\bigslopedwedge",
    '⩚' => raw"\wedgemidvert",
    '⩛' => raw"\veemidvert",
    '⩜' => raw"\midbarwedge",
    '⩝' => raw"\midbarvee",
    '⩞' => raw"\doublebarwedge",  # \perspcorrespond
    '⩟' => raw"\wedgebar",  # \minhat
    '⩠' => raw"\wedgedoublebar",
    '⩡' => raw"\varveebar",
    '⩢' => raw"\doublebarvee",
    '⩣' => raw"\veedoublebar",
    '⩦' => raw"\eqdot",
    '⩧' => raw"\dotequiv",
    '⩪' => raw"\dotsim",
    '⩫' => raw"\simrdots",
    '⩬' => raw"\simminussim",
    '⩭' => raw"\congdot",
    '⩮' => raw"\asteq",
    '⩯' => raw"\hatapprox",
    '⩰' => raw"\approxeqq",
    '⩱' => raw"\eqqplus",
    '⩲' => raw"\pluseqq",
    '⩳' => raw"\eqqsim",
    '⩴' => raw"\Coloneq",
    '⩵' => raw"\eqeq",  # \Equal
    '⩶' => raw"\eqeqeq",
    '⩷' => raw"\ddotseq",
    '⩸' => raw"\equivDD",
    '⩹' => raw"\ltcir",
    '⩺' => raw"\gtcir",
    '⩻' => raw"\ltquest",
    '⩼' => raw"\gtquest",
    '⩽' => raw"\leqslant",
    "⩽̸" => raw"\not\leqslant",  # \nleqslant
    '⩾' => raw"\geqslant",
    "⩾̸" => raw"\not\geqslant",  # \ngeqslant
    '⩿' => raw"\lesdot",
    '⪀' => raw"\gesdot",
    '⪁' => raw"\lesdoto",
    '⪂' => raw"\gesdoto",
    '⪃' => raw"\lesdotor",
    '⪄' => raw"\gesdotol",
    '⪅' => raw"\lessapprox",
    '⪆' => raw"\gtrapprox",
    '⪇' => raw"\lneq",
    '⪈' => raw"\gneq",
    '⪉' => raw"\lnapprox",
    '⪊' => raw"\gnapprox",
    '⪋' => raw"\lesseqqgtr",
    '⪌' => raw"\gtreqqless",
    '⪍' => raw"\lsime",
    '⪎' => raw"\gsime",
    '⪏' => raw"\lsimg",
    '⪐' => raw"\gsiml",
    '⪑' => raw"\lgE",
    '⪒' => raw"\glE",
    '⪓' => raw"\lesges",
    '⪔' => raw"\gesles",
    '⪕' => raw"\eqslantless",
    '⪖' => raw"\eqslantgtr",
    '⪗' => raw"\elsdot",
    '⪘' => raw"\egsdot",
    '⪙' => raw"\eqqless",
    '⪚' => raw"\eqqgtr",
    '⪛' => raw"\eqqslantless",
    '⪜' => raw"\eqqslantgtr",
    '⪝' => raw"\simless",
    '⪞' => raw"\simgtr",
    '⪟' => raw"\simlE",
    '⪠' => raw"\simgE",
    '⪡' => raw"\Lt",  # \NestedLessLess
    "⪡̸" => raw"\not\Lt",
    '⪢' => raw"\Gt",  # \NestedGreaterGreater
    "⪢̸" => raw"\not\Gt",
    '⪣' => raw"\partialmeetcontraction",
    '⪤' => raw"\glj",
    '⪥' => raw"\gla",
    '⪦' => raw"\ltcc",
    '⪧' => raw"\gtcc",
    '⪨' => raw"\lescc",
    '⪩' => raw"\gescc",
    '⪪' => raw"\smt",
    '⪫' => raw"\lat",
    '⪬' => raw"\smte",
    '⪭' => raw"\late",
    '⪮' => raw"\bumpeqq",
    '⪯' => raw"\preceq",
    "⪯̸" => raw"\not\preceq",  # \npreceq
    '⪰' => raw"\succeq",
    "⪰̸" => raw"\not\nsucceq",  # \nsucceq
    '⪱' => raw"\precneq",
    '⪲' => raw"\succneq",
    '⪳' => raw"\preceqq",
    '⪴' => raw"\succeqq",
    '⪵' => raw"\precneqq",
    '⪶' => raw"\succneqq",
    '⪷' => raw"\precapprox",
    '⪸' => raw"\succapprox",
    '⪹' => raw"\precnapprox",
    '⪺' => raw"\succnapprox",
    '⪻' => raw"\Prec",
    '⪼' => raw"\Succ",
    '⪽' => raw"\subsetdot",
    '⪾' => raw"\supsetdot",
    '⪿' => raw"\subsetplus",
    '⫀' => raw"\supsetplus",
    '⫁' => raw"\submult",
    '⫂' => raw"\supmult",
    '⫃' => raw"\subedot",
    '⫄' => raw"\supedot",
    '⫅' => raw"\subseteqq",
    "⫅̸" => raw"\not\subseteqq",  # \subseteqq
    '⫆' => raw"\supseteqq",
    "⫆̸" => raw"\not\supseteqq",  # \supseteqq
    '⫇' => raw"\subsim",
    '⫈' => raw"\supsim",
    '⫉' => raw"\subsetapprox",
    '⫊' => raw"\supsetapprox",
    '⫋' => raw"\subsetneqq",
    '⫌' => raw"\supsetneqq",
    '⫍' => raw"\lsqhook",
    '⫎' => raw"\rsqhook",
    '⫏' => raw"\csub",
    '⫐' => raw"\csup",
    '⫑' => raw"\csube",
    '⫒' => raw"\csupe",
    '⫓' => raw"\subsup",
    '⫔' => raw"\supsub",
    '⫕' => raw"\subsub",
    '⫖' => raw"\supsup",
    '⫗' => raw"\suphsub",
    '⫘' => raw"\supdsub",
    '⫙' => raw"\forkv",
    '⫛' => raw"\mlcp",
    '⫝̸' => raw"\forks",
    '⫝' => raw"\forksnot",
    '⫣' => raw"\dashV",
    '⫤' => raw"\Dashv",
    '⫪' => raw"\barV",  # \downvDash
    '⫫' => raw"\Vbar",  # \upvDash, \indep
    '⫴' => raw"\interleave",
    '⫶' => raw"\threedotcolon",  # \tdcol
    '⫷' => raw"\lllnest",
    '⫸' => raw"\gggnest",
    '⫹' => raw"\leqqslant",
    '⫺' => raw"\geqqslant",
    '⬒' => raw"\squaretopblack",
    '⬓' => raw"\squarebotblack",
    '⬔' => raw"\squareurblack",
    '⬕' => raw"\squarellblack",
    '⬖' => raw"\diamondleftblack",
    '⬗' => raw"\diamondrightblack",
    '⬘' => raw"\diamondtopblack",
    '⬙' => raw"\diamondbotblack",
    '⬚' => raw"\dottedsquare",
    '⬛' => raw"\lgblksquare",
    '⬜' => raw"\lgwhtsquare",
    '⬝' => raw"\vysmblksquare",
    '⬞' => raw"\vysmwhtsquare",
    '⬟' => raw"\pentagonblack",
    '⬠' => raw"\pentagon",
    '⬡' => raw"\varhexagon",
    '⬢' => raw"\varhexagonblack",
    '⬣' => raw"\hexagonblack",
    '⬤' => raw"\lgblkcircle",
    '⬥' => raw"\mdblkdiamond",
    '⬦' => raw"\mdwhtdiamond",
    '⬧' => raw"\mdblklozenge",
    '⬨' => raw"\mdwhtlozenge",
    '⬩' => raw"\smblkdiamond",
    '⬪' => raw"\smblklozenge",
    '⬫' => raw"\smwhtlozenge",
    '⬬' => raw"\blkhorzoval",
    '⬭' => raw"\whthorzoval",
    '⬮' => raw"\blkvertoval",
    '⬯' => raw"\whtvertoval",
    '⬰' => raw"\circleonleftarrow",
    '⬱' => raw"\leftthreearrows",
    '⬲' => raw"\leftarrowonoplus",
    '⬳' => raw"\longleftsquigarrow",
    '⬴' => raw"\nvtwoheadleftarrow",
    '⬵' => raw"\nVtwoheadleftarrow",
    '⬶' => raw"\twoheadmapsfrom",
    '⬷' => raw"\twoheadleftdbkarrow",
    '⬸' => raw"\leftdotarrow",
    '⬹' => raw"\nvleftarrowtail",
    '⬺' => raw"\nVleftarrowtail",
    '⬻' => raw"\twoheadleftarrowtail",
    '⬼' => raw"\nvtwoheadleftarrowtail",
    '⬽' => raw"\nVtwoheadleftarrowtail",
    '⬾' => raw"\leftarrowx",
    '⬿' => raw"\leftcurvedarrow",
    '⭀' => raw"\equalleftarrow",
    '⭁' => raw"\bsimilarleftarrow",
    '⭂' => raw"\leftarrowbackapprox",
    '⭃' => raw"\rightarrowgtr",
    '⭄' => raw"\rightarrowsupset",
    '⭅' => raw"\LLeftarrow",
    '⭆' => raw"\RRightarrow",
    '⭇' => raw"\bsimilarrightarrow",
    '⭈' => raw"\rightarrowbackapprox",
    '⭉' => raw"\similarleftarrow",
    '⭊' => raw"\leftarrowapprox",
    '⭋' => raw"\leftarrowbsimilar",
    '⭌' => raw"\rightarrowbsimilar",
    '⭐' => raw"\medwhitestar",
    '⭑' => raw"\medblackstar",
    '⭒' => raw"\smwhitestar",
    '⭓' => raw"\rightpentagonblack",
    '⭔' => raw"\rightpentagon",
    'ⱼ' => raw"{_j}",
    'ⱽ' => raw"{^V}",
    '〒' => raw"\postalmark",
    'ꜛ' => raw"{^\uparrow}",
    'ꜜ' => raw"{^\downarrow}",
    'ꜝ' => raw"{^!}",
    '𝚤' => raw"\mathit{\imath}",
    '𝚥' => raw"\mathit{\jmath}",
    latex_emphasis(vcat('A':'Z', 'a':'z', '0':'9'))...,
    map(x -> x[2] => "\\mathbf{$(greek_seq[x[1]])}", enumerate('𝚨':'𝛡'))...,  # greek with bold emphasis (x58)
    map(x -> x[2] => "\\mathit{$(greek_seq[x[1]])}", enumerate('𝛢':'𝜛'))...,  # greek with italic emphasis
    map(x -> x[2] => "\\mathbfit{$(greek_seq[x[1]])}", enumerate('𝜜':'𝝕'))...,  # greek with bold+italic emphasis
    map(x -> x[2] => "\\mathbfsfup{$(greek_seq[x[1]])}", enumerate('𝝖':'𝞏'))...,  # greek sans-serif with bold emphasis
    map(x -> x[2] => "\\mathbfsfit{$(greek_seq[x[1]])}", enumerate('𝞐':'𝟉'))...,  # greek sans-serif with bold+italic emphasis
    '𝟊' => raw"\mbfDigamma",  # \Digamma
    '𝟋' => raw"\mbfdigamma",  # \digamm
    latex_diacritics(vcat('A':'Z', 'a':'z'))...,
)

unicode2latex(c::Char) = unicode2latex(string(c))
function unicode2latex(str::String; safescripts=false)
    isascii(str) && return str

    str = Unicode.normalize(str; decompose=true) # Get rid of pre-composed characters
    c_or_s = sizehint!(Union{Char,String}[], length(str))

    it = Iterators.Stateful(str)
    while !isempty(it)
        c = popfirst!(it)
        push!(
            c_or_s,  # see en.wikipedia.org/wiki/Combining_character
            if Unicode.category_code(something(peek(it), '0')) == Unicode.UTF8PROC_CATEGORY_MN
                c * popfirst!(it)
            else
                c
            end
        )
    end
    str_array = map(k -> get(unicodedict, k, k), c_or_s)

    it = Iterators.Stateful(str_array)
    for (n, x) ∈ enumerate(it)
        x isa String || continue
        # Deal with math mode modifiers (\hat, \tilde, \bar, \dot, ..., \ddddot)
        if endswith(x, Char(0x302))
            x = "\\hat{$(unicode2latex(x[begin:prevind(x, end)]))}"
            str_array[n] = x
        elseif endswith(x, Char(0x303))
            x = "\\tilde{$(unicode2latex(x[begin:prevind(x, end)]))}"
            str_array[n] = x
        elseif endswith(x, Char(0x304))
            x = "\\bar{$(unicode2latex(x[begin:prevind(x, end)]))}"
            str_array[n] = x
        elseif endswith(x, Char(0x307))
            x = "\\dot{$(unicode2latex(x[begin:prevind(x, end)]))}"
            str_array[n] = x
        elseif endswith(x, Char(0x308))
            x = "\\ddot{$(unicode2latex(x[begin:prevind(x, end)]))}"
            str_array[n] = x
        elseif endswith(x, Char(0x20DB))
            x = "\\dddot{$(unicode2latex(x[begin:prevind(x, end)]))}"
            str_array[n] = x
        elseif endswith(x, Char(0x20DC))
            x = "\\ddddot{$(unicode2latex(x[begin:prevind(x, end)]))}"
            str_array[n] = x
        end
        if (next = peek(it)) !== nothing && length(next) == 1
            c = next isa Char ? next : first(next)
            if isletter(c) || isdigit(c)
                str_array[n] = "{$x}"
            end
        end
    end
    str = merge_subscripts(join(str_array); safescripts=safescripts)
    return merge_superscripts(str; safescripts=safescripts)
end

"""
    merge_superscripts(str; safescripts=false)

Merge sequential superscripts to a better representation.

Returns a string where sequences like "{^1}{^3}" are replaced by "^{1 3}".

If `safescripts` is `true`, makes `{^{1 3}}`, which is less aesthetic but might succeed with
certain combinations where `false` would not.
"""
function merge_superscripts(str; safescripts=false)
    # pair {^q}{^q}{^q}{^q}{^q} --> {^{q q}}{^{q q}}{^q}
    str = replace(str, r"{\^([^{}]*)}{\^([^{}]*)}" => s"{^{\1 \2}}")
    # collect ends if needed   {^{q q}}{^{q q}}{^q} --> {^{q q}}{^{q q q}}
    str = replace(str, r"{\^{([^{}]*)}}{\^([^{}]*)}" => s"{^{\1 \2}}")
    str = replace(str, r"{\^{([^{}]*)}}{{\^([^{}]*)}}" => s"{^{\1 \2}}") # if last one was protected by extra {}

    # complete merge  {^{q q}}{^{q q q}} --> {^{q q q q q}}
    r = r"{\^{([^{}]*)}}{\^{([^{}]*)}}"
    while match(r, str) !== nothing
        str = replace(str, r => s"{^{\1 \2}}")
    end

    if ~safescripts
        # remove external braces
        str = replace(str, r"{\^{([^{}]*)}}" => s"^{\1}")

        # deal with superscripts that did not need to be merged
        str = replace(str, r"{{\^([^{}]*)}}" => s"^{\1}")
        str = replace(str, r"{\^([^{}]*)}" => s"^\1")
    end
    return str
end

"""
    merge_subscripts(str; safescripts=false)

Merge sequential subscripts to a better representation.

Returns a string where sequences like "{_1}{_3}" are replaced by "_{1 3}".

If `safescripts` is `true`, makes `{_{1 3}}`, which is less aesthetic but might succeed with
certain combinations where `false` would not.
"""
function merge_subscripts(str; safescripts=false)
    # pair
    str = replace(str, r"{_([^{}]*)}{_([^{}]*)}" => s"{_{\1 \2}}")
    # collect ends if needed
    str = replace(str, r"{_{([^{}]*)}}{_([^{}]*)}" => s"{_{\1 \2}}")
    str = replace(str, r"{_{([^{}]*)}}{{_([^{}]*)}}" => s"{_{\1 \2}}") # if last one was protected by extra {}

    # complete merge
    r = r"{_{([^{}]*)}}{_{([^{}]*)}}"
    while match(r, str) !== nothing
        str = replace(str, r => s"{_{\1 \2}}")
    end

    if ~safescripts
        # remove external braces
        str = replace(str, r"{_{([^{}]*)}}" => s"_{\1}")

        # deal with subscripts that did not need to be merged
        str = replace(str, r"{{_([^{}]*)}}" => s"_{\1}")
        str = replace(str, r"{_([^{}]*)}" => s"_\1")
    end
    return str

end
