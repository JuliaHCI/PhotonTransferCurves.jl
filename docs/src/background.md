# Background

Photon transfer is the framework for studying how light interacts with our semiconductor-based detectors. Many of the processes in photon transfer are stochastic, which creates noise as electrons are generated and read out of a detector. Characterizing this noise is imperative for assessing detector performance and is a key part of astronomical instrumentation development.

## Typical noise sources

For optical and near-infrared applications, the primary noise sources associated with photon transfer are *read noise*, *shot noise*, and *fixed pattern noise* (FPN).

### Read noise

Read noise is the noise regime which is constant with proportion to the input signal.

```math
\sigma_\mathrm{read} \propto \mathrm{const.}
```

Common sources include analog to digital converter (ADC) readout noise and thermal dark current. Dark current is an example of read noise which is not proportional to signal, but which is not static (both temporally and spatially).

### Shot noise

The photoelectric effect is a Poisson process and therefore the noise increases proportionally to the square root of the signal

```math
\sigma_\mathrm{shot} \propto S^{1/2}
```

where ``S`` is the mean signal.

### Fixed-pattern noise (FPN)

Variations in the semiconductors and traces across the detector array will cause a pixel-dependent noise which scales linearly with the input signal.

```math
\sigma_\mathrm{FPN} \propto S
```

Other sources of pixel-dependent noise are interference fringes and optical defects like dust. FPN is problematic because it scales linearly with signal; this means the signal-to-noise ratio is constant. Fortunately, FPN is temporally static, and it can be entirely removed by either difference-imaging or flat-fielding.

## Photon transfer curve

The classic photon transfer curve is a plot of the standard deviation (noise) versus the mean signal.

The mean signal is calculated from the raw signal ``\mathrm{DN}_i`` and the bias offset ``\mathrm{off}_i`` where ``i`` is the pixel index in the image.

```math
S_i = \mathrm{DN}_i - \mathrm{off}_i
```

```math
\bar{S} = \frac{1}{N} \sum_i{S_i}
```

The noise is then calculated using the standard deviation

```math
\sigma = \sqrt{\mathrm{Var}(S)} = \left[\frac{1}{N} \sum_i{\left( S_i - \bar{S}\right)^2} \right]^{1/2}
```

When plotted with logarithmic axes it clearly shows the three noise regimes: read noise (constant), shot noise (square-root), and fixed-pattern noise (linear).

```@example ptc
using LaTeXStrings
using LinearAlgebra
using Plots

N = 100

fullwell = 10^5 # DN
signal = fullwell .^ range(0, 1, length=N)

readnoise = 5 # DN
fpn_factor = 0.02

readvar = fill(readnoise^2, N)
shotvar = signal
fpnvar = @. (fpn_factor * signal)^2
totalvar = @. readvar + shotvar + fpnvar
shotreadvar = totalvar - fpnvar

noise = sqrt.([totalvar shotreadvar readvar shotvar fpnvar])
labels = hcat(
    L"\sigma_\mathrm{total}", L"\sigma_\mathrm{shot+read}",
    L"\sigma_\mathrm{read}", L"\sigma_\mathrm{shot}",
    L"\sigma_\mathrm{FPN}"
)
plot(
    signal, noise; 
    label=labels, scale=:log10, leg=:topleft,
    xlabel=L"$S$ [DN]", ylabel=L"$\sigma$ [DN]",
    c=[1 2 :black :black :black],
    ls=[:solid :solid :dot :dash :dashdotdot]
)
```

### Signal-to-noise ratio

Another way of viewing the effects of the noise as a function of signal is the signal-to-noise ratio, which is an import metric for the statistical significance of detections.

```@example ptc
snr = @. signal / noise

plot(
    signal, snr; 
    label=labels, xscale=:log10, leg=:topleft,
    xlabel=L"$S$ [DN]", ylabel=L"S/N",
    c=[1 2 :black :black :black], ylims=(0, 70),
    ls=[:solid :solid :dot :dash :dashdotdot]
)
```
