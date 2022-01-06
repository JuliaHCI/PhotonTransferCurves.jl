
using Random: GLOBAL_RNG

"""
    AbstractNoiseSource

# Interface

To define your own source, simply provide the function for how signal is manipulated given an `AbstractRNG`

* `(::MySource)(rng, input)`
* `noise(::MySource, input)`
* `limits(::MySource)` (optional)

See [`ShotNoise`](@ref) for an example of an implementation of the interface
"""
abstract type AbstractNoiseSource <: Function end

"""
    (::AbstractNoiseSource)([rng], input)

Process a signal following the transfer function defined by the noise source. A random number generator can be passed if the process is stochastic.
"""
(source::AbstractNoiseSource)(input) = source(GLOBAL_RNG, input)

"""
    noise(::AbstractNoiseSource, input)

Return the RMS noise given the input signal
"""
noise(source::AbstractNoiseSource, input)

"""
    limimts(::AbstractNoiseSource)

Returns the limits for signal input. By Default, is `(0, Inf)`
"""
limits(::AbstractNoiseSource) = 0, Inf

"""
    ShotNoise()

A simple Poisson process for modifying incoming signal according to counting statistics.

# Examples

Simulate a Poisson process with average value of 1 three times.
```julia
julia> proc = ShotNoise()

julia> [proc(1) for _ in 1:3]
3-element Vector{Int64}:
 0
 3
 2

julia> noise(proc, 100)
10.0
```
"""
Base.@kwdef struct ShotNoise <: AbstractNoiseSource end

(::ShotNoise)(rng, input) = rand(rng, Poisson(input))

noise(::ShotNoise, input) = sqrt(input)

"""
    ReadNoise(;noise)

Gaussian read noise, with the given RMS noise.
"""
Base.@kwdef struct ReadNoise{T} <: AbstractNoiseSource
    noise::T
end

(tf::ReadNoise)(rng, input)= tf.noise * randn(rng) + input

noise(tf::ReadNoise, input) = tf.noise