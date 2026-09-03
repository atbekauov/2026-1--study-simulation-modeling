using DrWatson
@quickactivate "project"
using DataFrames, Plots, CSV

df = CSV.read(datadir("beta_scan_all.csv"), DataFrame)

p1 = plot(df.beta, df.peak, seriestype = :scatter, label = "Пик", xlabel = "β", ylabel = "Доля", color = :red)
p2 = plot(df.beta, df.deaths ./ 3000, seriestype = :scatter, label = "Смертность", xlabel = "β", ylabel = "Доля", color = :black)
p3 = plot(df.beta, df.final_rec, seriestype = :scatter, label = "Переболевшие", xlabel = "β", ylabel = "Доля", color = :green)

combined_plot = plot(p1, p2, p3, layout = (3, 1), size = (600, 800))
savefig(plotsdir("comprehensive_analysis.png"))

savefig(plotsdir("comprehensive_analysis.png"))
