function test_exact_forecast(metric; n = 1000, seed::Int = 1)
    Random.seed!(seed)
    a = rand(n)
    @test metric(a, a) == 0
    return
end