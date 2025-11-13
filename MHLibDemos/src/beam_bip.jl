module BeamBIP

using Random 
using ..BIP
export beam_search_bip

function beam_search_bip(inst::BIP.BIPInstance; B::Int=16, sort_desc::Bool=true, seed::Integer=1)
    B <= 0 && error("Beam width B must be ≥ 1")
    Random.seed!(seed)

    n = length(inst.a)
    idx = collect(1:n)
    if sort_desc
        sort!(idx; by = i -> inst.a[i], rev = true)
    end
    vals = inst.a[idx]

    pref_rem = reverse!(cumsum(reverse(vals)))  # size n
    beam = [(0, 0, falses(n), 0)]
    best_obj = typemax(Int)
    best_e   = falses(n)

    for i in 1:n
        v   = vals[i]
        rem = (i < n) ? pref_rem[i+1] : 0
        nextbeam = Vector{Tuple{Int,Int,BitVector,Int}}()
        sizehint!(nextbeam, 2*length(beam))

        for (_i, Δ, ebits, _lb) in beam
            e1 = copy(ebits); e1[idx[i]] = true
            Δ1  = Δ + v
            lb1 = max(0, abs(Δ1) - rem)
            push!(nextbeam, (i, Δ1, e1, lb1))

            Δ2  = Δ - v
            lb2 = max(0, abs(Δ2) - rem)
            push!(nextbeam, (i, Δ2, ebits, lb2))
        end

        keep = min(B, length(nextbeam))
        partialsort!(nextbeam, 1:keep; by = t -> (t[4], abs(t[2])))
        beam = nextbeam[1:keep]
    end

    for (_i, Δ, ebits, _lb) in beam
        obj = abs(Δ)
        if obj < best_obj
            best_obj = obj
            best_e = ebits
        end
    end

    return BIP.BIPSolution(inst, best_e, best_obj)
end

function beam_search_bip(A::AbstractVector{<:Integer};
                         w::Int=16, seed::Integer=1, order::Symbol=:desc)
    inst = BIP.BIPInstance(collect(A))
    sort_desc = (order == :desc)
    return beam_search_bip(inst; B = w, sort_desc, seed)
end

end 
