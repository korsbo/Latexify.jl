#!/usr/bin/env julia

#Start Test Script
using Latexify
using Base.Test

# Run tests

tic()
println("Test 1")
@time @test include("latexify_test.jl")
toc()
