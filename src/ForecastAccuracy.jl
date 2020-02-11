module ForecastAccuracy

using Statistics

# Exports are in the end of the file

err(real::Vector{T}, forecast::Vector{T}) where T = real .- forecast
abs_err(real::Vector{T}, forecast::Vector{T}) where T = abs.(err(real, forecast))
sq_err(real::Vector{T}, forecast::Vector{T}) where T = err(real, forecast) .^ 2
percent_err(real::Vector{T}, forecast::Vector{T}) where T = err(real, forecast) ./ real
abs_percent_err(real::Vector{T}, forecast::Vector{T}) where T = abs.(percent_err(real, forecast))

function scaled_err(real::Vector{T}, forecast::Vector{T}, steps_ahead::Int) where T 
    denom = zero(T)
    n = length(real)
    for i in 1 + steps_ahead : n
        @inbounds denom += abs(real[i] - real[i - 1])
    end
    denom = denom/(n - steps_ahead)
    return err(real, forecast)/denom
end

function scaled_sq_err(real::Vector{T}, forecast::Vector{T}, steps_ahead::Int) where T 
    denom = zero(T)
    n = length(real)
    for i in 1 + steps_ahead : n
        @inbounds denom += (real[i] - real[i - 1])^2
    end
    denom = denom/(n - steps_ahead)
    return mean(sq_err(real, forecast))/denom
end


function geomean(v::Vector{T}) where T
    s = zero(T)
    n = length(v)
    for i in 1 : n
        @inbounds s += log(v[i])
    end
    return exp(s / n)
end

"""
    me(real::Vector{T}, forecast::Vector{T}) where T 

Mean Error. 
"""
function me(real::Vector{T}, forecast::Vector{T}) where T 
    return mean(err(real, forecast))
end

"""
    mde(real::Vector{T}, forecast::Vector{T}) where T

Median Error.
"""
function mde(real::Vector{T}, forecast::Vector{T}) where T 
    return median(err(real, forecast))
end

"""
    mae(real::Vector{T}, forecast::Vector{T}) where T

Mean Absolute Error.
"""
function mae(real::Vector{T}, forecast::Vector{T}) where T 
    return mean(abs_err(real, forecast))
end

"""
    gmae(real::Vector{T}, forecast::Vector{T}) where T

Geometric Mean Absolute Error.
"""
function gmae(real::Vector{T}, forecast::Vector{T}) where T 
    return geomean(abs_err(real, forecast))
end

"""
    mdae(real::Vector{T}, forecast::Vector{T}) where T

Median Absolute Error.
"""
function mdae(real::Vector{T}, forecast::Vector{T}) where T 
    return median(abs_err(real, forecast))
end

"""
    mse(real::Vector{T}, forecast::Vector{T}) where T

Mean Square Error.
"""
function mse(real::Vector{T}, forecast::Vector{T}) where T 
    return mean(sq_err(real, forecast))
end

"""
    mdse(real::Vector{T}, forecast::Vector{T}) where T

Median Square Error.
"""
function mdse(real::Vector{T}, forecast::Vector{T}) where T
    return median(sq_err(real, forecast))
end

"""
    rmse(real::Vector{T}, forecast::Vector{T}) where T

Root Mean Squared Error.
"""
function rmse(real::Vector{T}, forecast::Vector{T}) where T
    return mean(sqrt.(sq_err(real, forecast)))
end

"""
    mpe(real::Vector{T}, forecast::Vector{T}) where T

Mean Percentual Error.
"""
function mpe(real::Vector{T}, forecast::Vector{T}) where T
    return mean(percent_err(real, forecast))
end

"""
    mdpe(real::Vector{T}, forecast::Vector{T}) where T

Median Percentual Error.
"""
function mdpe(real::Vector{T}, forecast::Vector{T}) where T
    return median(percent_err(real, forecast))
end

"""
    mape(real::Vector{T}, forecast::Vector{T}) where T

Mean Absolute Percentual Error.
"""
function mape(real::Vector{T}, forecast::Vector{T}) where T
    return mean(abs_percent_err(real, forecast))
end

"""
    mdape(real::Vector{T}, forecast::Vector{T}) where T

Median Absolute Percentual Error.
"""
function mdape(real::Vector{T}, forecast::Vector{T}) where T
    return median(abs_percent_err(real, forecast))
end

"""
    smape(real::Vector{T}, forecast::Vector{T}) where T

Symmetric Mean Absolute Percentual Error.
"""
function smape(real::Vector{T}, forecast::Vector{T}) where T
    return mean((2 .* abs_err(real, forecast) ./ (real .+ forecast)))
end

"""
    smdape(real::Vector{T}, forecast::Vector{T}) where T

Symmetric Median Absolute Percentual Error.
"""
function smdape(real::Vector{T}, forecast::Vector{T}) where T
    return median((2 .* abs_err(real, forecast) ./ (real .+ forecast)))
end

"""
    maape(real::Vector{T}, forecast::Vector{T}) where T

Mean Arctangent Absolute Percentage Error. As developed in https://www.sciencedirect.com/science/article/pii/S0169207016000121
"""
function maape(real::Vector{T}, forecast::Vector{T}) where T
    return mean(atan.(abs_percent_err(real, forecast)))
end

"""
    mase(real::Vector{T}, forecast::Vector{T}; steps_ahead::Int = 1) where T

Mean Absolute Scaled Error. As developed in https://robjhyndman.com/papers/mase.pdf
"""
function mase(real::Vector{T}, forecast::Vector{T}; steps_ahead::Int = 1) where T
    return mean(abs.(scaled_err(real, forecast, steps_ahead)))
end

"""
    mdase(real::Vector{T}, forecast::Vector{T}; steps_ahead::Int = 1) where T

Median Absolute Scaled Error. As developed in https://robjhyndman.com/papers/mase.pdf
"""
function mdase(real::Vector{T}, forecast::Vector{T}; steps_ahead::Int = 1) where T 
    return median(abs.(scaled_err(real, forecast, steps_ahead)))
end

"""
    rmsse(real::Vector{T}, forecast::Vector{T}; steps_ahead::Int = 1) where T

Root Mean Squared Scaled Error. 
"""
function rmsse(real::Vector{T}, forecast::Vector{T}; steps_ahead::Int = 1) where T
    return sqrt(scaled_sq_err(real, forecast, steps_ahead))
end

const METRICS = [
    me,
    mde,
    mae, 
    gmae,
    mdae,
    mse, 
    mdse,
    rmse, 
    mpe,
    mdpe,
    mape, 
    mdape,
    smape,
    smdape,
    maape,
    mase,
    mdase,
    rmsse
]

# ForecastAccuracy exports all of the metrics in METRICS. 
for metric in METRICS
    @eval export metric
end

end # module
