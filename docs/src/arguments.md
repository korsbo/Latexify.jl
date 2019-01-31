# List of possible arguments

## Align
```@eval
Base.include(@__MODULE__, "src/table_generator.jl")
args = [arg for arg in keyword_arguments if :align in arg.env]
latexify(args, env=:mdtable)
```


## Array
```@eval
Base.include(@__MODULE__, "src/table_generator.jl")
args = [arg for arg in keyword_arguments if :array in arg.env]
latexify(args, env=:mdtable)
```

## Tabular
```@eval
Base.include(@__MODULE__, "src/table_generator.jl")
args = [arg for arg in keyword_arguments if :tabular in arg.env]
latexify(args, env=:mdtable)
```

## Markdown Table
```@eval
Base.include(@__MODULE__, "src/table_generator.jl")
args = [arg for arg in keyword_arguments if :mdtable in arg.env]
latexify(args, env=:mdtable)
```

## Inline and raw
```@eval
Base.include(@__MODULE__, "src/table_generator.jl")
args = [arg for arg in keyword_arguments if :raw in arg.env || :inline in arg.env]
latexify(args, env=:mdtable)
```

## Chemical arrow notation
Available with `ReactionNetwork`s from `DiffEqBiological`.
```@eval
Base.include(@__MODULE__, "src/table_generator.jl")
args = [arg for arg in keyword_arguments if :arrow in arg.env]
latexify(args, env=:mdtable, types=false)
```
