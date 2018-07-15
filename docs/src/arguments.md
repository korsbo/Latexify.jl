# List of possible arguments

## Align
```@eval
include("src/table_generator.jl")
args = [arg for arg in keyword_arguments if :align in arg.env]
latexify(args, env=:mdtable)
```


## Array
```@eval
include("src/table_generator.jl")
args = [arg for arg in keyword_arguments if :array in arg.env]
latexify(args, env=:mdtable)
```

## Tabular
```@eval
include("src/table_generator.jl")
args = [arg for arg in keyword_arguments if :tabular in arg.env]
latexify(args, env=:mdtable)
```

## Markdown Table
```@eval
include("src/table_generator.jl")
args = [arg for arg in keyword_arguments if :mdtable in arg.env]
latexify(args, env=:mdtable)
```

## Chemical arrow notation
Available with `ReactionNetwork`s from `DiffEqBiological`.
```@eval
include("src/table_generator.jl")
args = [arg for arg in keyword_arguments if :arrow in arg.env]
latexify(args, env=:mdtable, types=false)
```
