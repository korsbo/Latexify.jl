#!/usr/bin/env julia

#Start Test Script
using Latexify
using LaTeXStrings
using Missings
using Test

# Run tests

@testset "macro test" begin include("macros.jl") end
@testset "recipe test" begin include("recipe_test.jl") end
@testset "latexify tests" begin include("latexify_test.jl") end
@testset "latexraw tests" begin include("latexraw_test.jl") end
@testset "latexalign tests" begin include("latexalign_test.jl") end
@testset "latexarray tests" begin include("latexarray_test.jl") end
@testset "latexequation tests" begin include("latexequation_test.jl") end
@testset "latexinline tests" begin include("latexinline_test.jl") end
@testset "latextabular tests" begin include("latextabular_test.jl") end
@testset "mdtable tests" begin include("mdtable_test.jl") end
@testset "DataFrame Plugin" begin include("plugins/DataFrames.jl") end
@testset "unocode2latex" begin include("unicode2latex.jl") end
@testset "cdot test" begin include("cdot_test.jl") end
@testset "numberformatters" begin include("numberformatters_test.jl") end
@testset "Unitful Plugin" begin include("plugins/Unitful.jl") end
