using DrWatson
@quickactivate "project"
include(srcdir("SIRPetri.jl"))
using .SIRPetri
using DataFrames, CSV, Plots

β_start = 0.1
β_end = 0.8
β_step = 0.05
γ_fixed = 0.1
tmax = 100.0

β_range = β_start:β_step:β_end

results = []
for β in β_range
    net, u0, _ = SIRPetri.build_sir_network(β, γ_fixed)
    df = SIRPetri.simulate_deterministic(net, u0, (0.0, tmax), saveat = 0.5, rates = [β, γ_fixed])
    peak_I = maximum(df.I)
    final_R = df.R[end]
    push!(results, (β = β, peak_I = peak_I, final_R = final_R))
end

df_scan = DataFrame(results)
CSV.write(datadir("sir_scan.csv"), df_scan)

p = plot(
    df_scan.β,
    [df_scan.peak_I df_scan.final_R],
    label = ["Peak I" "Final R"],
    marker = :circle,
    xlabel = "β (infection rate)",
    ylabel = "Population",
)
savefig(plotsdir("sir_scan.png"))
println("Сканирование β завершено. Результат в data/sir_scan.csv")
