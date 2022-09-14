# Functions for measuring the signal and noise of typical
# CMOS and CCD data
using BiweightStats

"""
"""
function process_frames(frames::Vararg{<:AbstractMatric}; kwargs...)
    map(f -> process_single_frame(f; kwargs...), frames)
end
function process_frames(cube::AbstractArray{T,3}; dims=3, kwargs...) where T
    map(f -> process_single_frame(f; kwargs...), eachslice(cube; dims=dims))
end

function process_single_frame(frame::AbstractMatrix; window_size=30, kwargs...)
    window_size = _normalize_window_size(window_size)
end

_normalize_window_size(n::NTuple{2, <:Integer}) = n
_normalize_window_size(n::Integer) = (n, n)

"""
    signal_and_noise(data; kwargs...)

Measure the signal and variance of `data` using [`BiweightStats.location`](@ref) and [`BiweightStats.midvar`](@ref). These statistics are robust to outliers, and their level of filtering can be set with keyword arguments, see the function reference for more information.

# See also
[`BiweightStats.location`](@ref), [`BiweightStats.midvar`](@ref)
"""
function signal_and_noise(data; kwargs...)
    signal = location(data; kwargs...)
    var = midvar(data; M=signal, kwargs...)
    return signal, var
end
