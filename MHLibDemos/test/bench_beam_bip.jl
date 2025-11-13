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

open(outfile, "w") do io
    println(io, "timestamp,n,width,seed,obj,time_ms")
    for s in seeds
        A = rand(MersenneTwister(s), 1:10_000, n)
        for w in widths
            sol = nothing
            t = @elapsed begin
                sol = beam_search_bip(A; w=w, seed=s, order=order)
            end
            println(io, "$(Dates.format(now(), dateformat"yyyy-mm-ddTHH:MM:SS")),$n,$w,$s,$(sol.obj),$(round(Int, t*1000))")
        end
    end
end

println("Wrote -> $outfile")
