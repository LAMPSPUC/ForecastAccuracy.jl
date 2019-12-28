using ForecastAccuracy, Test, Random

include("utils.jl")

@testset "Exact forecast" begin
    for m in ForecastAccuracy.METRICS
        test_exact_forecast(m)
    end
end