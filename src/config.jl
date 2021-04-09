const DEFAULT_CONFIG = Dict{Symbol, Any}(
  :mulsym => " \\cdot ",
  :convert_unicode => true,
  :strip_broadcast => true,
  :fmt => identity,
  :index => :bracket,
  :ifstr => "\\text{if }",
  :elseifstr => "\\text{elseif }",
  :elsestr => "\\text{otherwise}",
  :adjustment => "c",
  :transpose => false,
  :double_linebreak => false,
  :starred => false,
)

## MODULE_CONFIG can store defaults specified in other modules. E.g. from recipes.
const MODULE_CONFIG = Dict{Symbol, Any}()

## USE_CONFIG can store user-specified defaults
const USER_CONFIG = Dict{Symbol, Any}()

## CONFIG is reset every latexify call. 
const CONFIG = Dict{Symbol, Any}() 
getconfig(key::Symbol) = CONFIG[key]


const comparison_operators = Dict(
        :< => "<",
        :.< => "<",
        :> => ">",
        :.> => ">",
        Symbol("==") => "=",
        Symbol(".==") => "=",
        :<= => "\\leq",
        :.<= => "\\leq",
        :>= => "\\geq",
        :.>= => "\\geq",
        :!= => "\\neq",
        :.!= => "\\neq",
        )