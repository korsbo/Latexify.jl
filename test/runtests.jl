#!/usr/bin/env julia

#Start Test Script
using Latexify, LaTeXStrings
using Base.Test

# Run tests

tic()
println("Test latexraw function")
@time @test include("latexraw_test.jl")
println("Test latexify function")
@time @test include("latexify_test.jl")
println("Test latexalign function")
@time @test include("latexalign_test.jl")
println("Test latexarray function")
@time @test include("latexarray_test.jl")
toc()
