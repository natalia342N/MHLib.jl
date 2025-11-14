#!/usr/bin/env julia
# test/bench_beam_bip.jl

using Random, Dates
using MHLibDemos
using MHLibDemos.BeamBIP

n       = parse(Int, get(ENV, "N", "200"))
widths  = parse.(Int, split(get(ENV, "WIDTHS", "1,3,5,10,20"), ","))
seeds   = 1:10
order   = :desc  

outdir  = joinpath(@__DIR__, "data")
mkpath(outdir)
outfile = joinpath(outdir, "beam_bip_results.csv")

begin
    A_warm = rand(MersenneTwister(0), 1:10_000, n)
    beam_search_bip(A_warm; w = 3, seed = 0, order = order)
end


open(outfile, "w") do io
    println(io, "timestamp,n,width,seed,obj,time_ms")
    for s in seeds
        A = rand(MersenneTwister(s), 1:10_000, n)
        for w in widths

            t0 = time_ns()
            sol = beam_search_bip(A; w = w, seed = s, order = order)
            t_ms = (time_ns() - t0) / 1e6  

            timestamp = Dates.format(now(), dateformat"yyyy-mm-ddTHH:MM:SS")

            println(io,
                "$timestamp,$n,$w,$s,$(sol.obj),$(round(t_ms; digits=3))")
        end
    end
end

println("Wrote -> $outfile")
