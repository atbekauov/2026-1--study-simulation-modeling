# Базовая визуализация модели Daisyworld.jl
#
# Данный скрипт создает три изображения модели Daisyworld на разных шагах
# симуляции: начальное состояние (шаг 0), после 5 шагов и после 40 шагов.
# Визуализация показывется тепловую карту температуры и расположения
# черных и белых маргариток 
#

# ## Подготовка окпужения 
# Активируем модель DrWatson и подклюаем необходимые пакеты

using DrWatson
@quickactivate "project"
using Agents
using DataFrames
using Plots

include(srcdir("daisyworld.jl"))

using CairoMakie

# ## Создание модели
# Инициализируем мир Daisyworld c параметрами по умолчанию

model = daisyworld()

daisycolor(a::Daisy) = a.breed

# Параметры отображения : цвет агента, размер, символ, отображения темепературы

plotkwargs = (
    agent_color=daisycolor,
    agent_size = 20,
    agent_marker = '✩',
    heatarray = :temperature,
    heatkwargs = (colorrange = (-20, 60),)
)

# ## Создание изображений

## Сохраняем состояние модели  на разных временных шагах
plt1, _ = abmplot(model; plotkwargs...)

step!(model, 5)
plt2, _ = abmplot(model; heatarray = model.temperature, plotkwargs...)

step!(model, 40)
plt3, _ = abmplot(model; heatarray = model.temperature, plotkwargs...)

# Сохраняем изображения в каталоге plots

save(plotsdir("daisy_step001.png"), plt1)
save(plotsdir("daisy_step005.png"), plt2)
save(plotsdir("daisy_step040.png"), plt3)
