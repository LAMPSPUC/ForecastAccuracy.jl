using Documenter, ForecastAccuracy

makedocs(
    modules = [ForecastAccuracy],
    doctest  = false,
    clean    = true,
    format   = Documenter.HTML(mathengine = Documenter.MathJax()),
    sitename = "ForecastAccuracy.jl",
    authors  = "Guilherme Bodin",
    pages   = [
        "Home" => "index.md"
    ]
)

deploydocs(
    repo = "github.com/LAMPSPUC/ForecastAccuracy.jl.git",
)