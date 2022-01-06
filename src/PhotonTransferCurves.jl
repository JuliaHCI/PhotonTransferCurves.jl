module PhotonTransferCurves

using Distributions
using Random
using Statistics
using StatsBase

export testdata, ShotNoise, ReadNoise, noise

img_to_curve(cube::AbstractArray; dims) = map(img_to_curve, eachslice(cube; dims))
img_to_curve(img::AbstractMatrix) = mean_and_std(img)
img_to_curve(pair::Tuple) = pair

function signal_and_noise(cube::AbstractArray; dims)
    data = img_to_curve(cube; dims)
    S = map(first, data)
    σ = map(last, data)
    return S, σ
end

function signal_and_noise(images::Vararg{<:AbstractMatrix})
    data = map(img_to_curve, images)
    S = map(first, data)
    σ = map(last, data)
    return S, σ
end

include("data.jl")
include("sources.jl")

end
