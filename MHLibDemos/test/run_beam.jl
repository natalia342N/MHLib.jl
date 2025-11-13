#!/usr/bin/env julia
using TestItemRunner

TestItemRunner.run_tests(@__DIR__;
    filter  = ti -> occursin("Beam-BIP", ti.name),
    verbose = true)
