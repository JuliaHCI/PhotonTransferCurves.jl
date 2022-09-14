using BiweightStats
using PhotonTransferCurves
using Documenter

setup = quote
    using BiweightStats
    using PhotonTransferCurves
end
DocMeta.setdocmeta!(PhotonTransferCurves, :DocTestSetup, setup; recursive=true)

makedocs(;
    modules=[PhotonTransferCurves],
    authors="Miles Lucas <mdlucas@hawaii.edu> and contributors",
    repo="https://github.com/JuliaHCI/PhotonTransferCurves.jl/blob/{commit}{path}#{line}",
    sitename="PhotonTransferCurves.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaHCI.github.io/PhotonTransferCurves.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Background" => "background.md",
        "Usage" => "usage.md",
        "API/Reference" => "api.md"
    ],
)

deploydocs(;
    repo="github.com/JuliaHCI/PhotonTransferCurves.jl",
    devbranch="main",
)
