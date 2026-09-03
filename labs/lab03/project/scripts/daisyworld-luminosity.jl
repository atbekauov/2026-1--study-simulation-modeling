# # Комплексная динамика модели Daisyworld
# 
# Скрипт строит три графика: численность маргариток, среднюю температуру
# планеты и солнечную светимость. Позволяет наблюдать, как маргаритки
# регулируют температуру при изменении солнечной активности.
# 
# ## Подготовка окружения

using DrWatson
@quickactivate "project"
using Agents
using DataFrames
using CairoMakie
using StatsBase

include(srcdir("daisyworld.jl"))

# ## Определение собираемых данных

black(a) = a.breed == :black
white(a) = a.breed == :white
adata = [(black, count), (white, count)]

# ## Запуск симуляции с изменяющейся светимостью

model = daisyworld(solar_luminosity = 1.0, scenario = :ramp)

temperature(model) = StatsBase.mean(model.temperature)

mdata = [temperature, :solar_luminosity]

agent_df, model_df = run!(model, 1000; adata = adata, mdata = mdata)

# ## Построение комплексного графика

figure = CairoMakie.Figure(size = (600, 600))

ax1 = figure[1, 1] = Axis(figure, ylabel = "daisy count")

black1 = lines!(ax1, agent_df[!, :time], agent_df[!, :count_black], color = :red)
white1 = lines!(ax1, agent_df[!, :time], agent_df[!, :count_white], color = :blue)

figure[1, 2] = Legend(figure, [black1, white1], ["black", "white"])

ax2 = figure[2, 1] = Axis(figure, ylabel = "temperature")

ax3 = figure[3, 1] = Axis(figure, xlabel = "tick", ylabel = "luminosity")

lines!(ax2, model_df[!, :time], model_df[!, :temperature], color = :red)
lines!(ax3, model_df[!, :time], model_df[!, :solar_luminosity], color = :red)

for ax in (ax1, ax2)
    ax.xticklabelsvisible = false
end

save(plotsdir("daisy_luminosity.png"), figure)
