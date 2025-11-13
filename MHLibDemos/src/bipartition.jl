module BIP

export BIPInstance, BIPSolution, imbalance, random_instance

struct BIPInstance
    a::Vector{Int}
    total::Int
end
BIPInstance(a::Vector{Int}) = BIPInstance(a, sum(a))

random_instance(n::Int; maxv::Int=10_000, seed::Union{Nothing,Int}=nothing) = begin
    if seed !== nothing
        Random.seed!(seed)
    end
    a = rand(1:maxv, n)
    BIPInstance(a)
end

struct BIPSolution
    inst::BIPInstance
    e::BitVector
    obj::Int  # |sum(E) - sum(F)|
end

function imbalance(inst::BIPInstance, e::AbstractVector{Bool})
    sE = sum(inst.a[i] for i in eachindex(inst.a) if e[i])
    abs(2*sE - inst.total)
end

end # module
