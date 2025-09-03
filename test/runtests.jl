#!/usr/bin/env julia

#Start Test Script
using Latexify
using LaTeXStrings
using Test

# Run tests

@testset "macro test" begin include("macros.jl") end
@testset "recipe test" begin include("recipe_test.jl") end
@testset "latexify tests" begin include("latexify_test.jl") end
@testset "latexraw tests" begin include("latexraw_test.jl") end
@testset "latexalign tests" begin include("latexalign_test.jl") end
@testset "latexarray tests" begin include("latexarray_test.jl") end
@testset "latexequation tests" begin include("latexequation_test.jl") end
@testset "latexbracket tests" begin include("latexbracket_test.jl") end
@testset "latexinline tests" begin include("latexinline_test.jl") end
@testset "latextabular tests" begin include("latextabular_test.jl") end
@testset "mdtable tests" begin include("mdtable_test.jl") end
@testset "DataFrames Plugin" begin include("plugins/DataFrames_test.jl") end
@testset "SymEngine Plugin" begin include("plugins/SymEngine_test.jl") end
@testset "SparseArrays Plugin" begin include("plugins/SparseArrays_test.jl") end
@testset "unicode2latex" begin include("unicode2latex.jl") end
@testset "cdot test" begin include("cdot_test.jl") end
@testset "numberformatters" begin include("numberformatters_test.jl") end
@testset "utils test" begin include("utils_test.jl") end
@testset "render test" begin include("render_test.jl") end
