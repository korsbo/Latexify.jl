#!/usr/bin/env julia

#Start Test Script
using Latexify
using LaTeXStrings
using ParameterizedFunctions
using Missings
using Base.Test

# Run tests

@testset "latexify tests" begin include("latexify_test.jl") end
@testset "latexraw tests" begin include("latexraw_test.jl") end
@testset "latexalign tests" begin include("latexalign_test.jl") end
@testset "latexarray tests" begin include("latexarray_test.jl") end
@testset "latexinline tests" begin include("latexinline_test.jl") end
@testset "mdtable tests" begin include("mdtable_test.jl") end
