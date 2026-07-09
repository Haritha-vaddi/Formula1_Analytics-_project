import os
from pathlib import Path

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

print("====================================")
print("Formula 1 Python Analysis Started")
print("All libraries imported successfully!")
print("====================================")

project_root = Path(__file__).resolve().parent.parent
candidate_paths = (
    Path(r"C:\Users\vaddi\Desktop\F1data"),
    project_root / "Dataset",
    project_root / "Python" / "Dataset",
    Path("Dataset"),
)

data_dir = None
for candidate in candidate_paths:
    if candidate.exists():
        data_dir = candidate.resolve()
        break

if data_dir is None:
    raise FileNotFoundError(
        f"Could not find the dataset directory. Checked: {', '.join(str(path) for path in candidate_paths)}"
    )

os.chdir(project_root)
charts_dir = project_root / "Charts"
charts_dir.mkdir(parents=True, exist_ok=True)

drivers = pd.read_csv(data_dir / "drivers.csv")

print("\nDrivers Dataset Loaded Successfully!")
print(drivers.head())


# Exploratory Data Analysis (EDA)   

print("\n==============================")
print("Dataset Shape")
print("==============================")
print(drivers.shape)

print("\n==============================")
print("Dataset Information")
print("==============================")
drivers.info()

print("\n==============================")
print("Missing Values")
print("==============================")
print(drivers.isnull().sum())

print("\n==============================")
print("Duplicate Records")
print("==============================")
print(drivers.duplicated().sum())

print("\n==============================")
print("Statistical Summary")
print("==============================")
print(drivers.describe())

#Load all required datasets

# Load all required datasets

results = pd.read_csv(data_dir / "results.csv")
races = pd.read_csv(data_dir / "races.csv")
constructors = pd.read_csv(data_dir / "constructors.csv")
circuits = pd.read_csv(data_dir / "circuits.csv")
pit_stops = pd.read_csv(data_dir / "pit_stops.csv")
lap_times = pd.read_csv(data_dir / "lap_times.csv")
qualifying = pd.read_csv(data_dir / "qualifying.csv")
driver_standings = pd.read_csv(data_dir / "driver_standings.csv")
constructor_standings = pd.read_csv(data_dir / "constructor_standings.csv")
constructor_results = pd.read_csv(data_dir / "constructor_results.csv")
sprint_results = pd.read_csv(data_dir / "sprint_results.csv")
status = pd.read_csv(data_dir / "status.csv")
seasons = pd.read_csv(data_dir / "seasons.csv")

print("All datasets loaded successfully!")


# Verify the dataset 

print("\n========== Dataset Shapes ==========")

print("Drivers               :", drivers.shape)
print("Results               :", results.shape)
print("Races                 :", races.shape)
print("Constructors          :", constructors.shape)
print("Circuits              :", circuits.shape)
print("Pit Stops             :", pit_stops.shape)
print("Lap Times             :", lap_times.shape)
print("Qualifying            :", qualifying.shape)
print("Driver Standings      :", driver_standings.shape)
print("Constructor Standings :", constructor_standings.shape)
print("Constructor Results   :", constructor_results.shape)
print("Sprint Results        :", sprint_results.shape)
print("Status                :", status.shape)
print("Seasons               :", seasons.shape)


# Create  a dataset summary

dataset_summary = pd.DataFrame({
    "Dataset": [
        "Drivers",
        "Results",
        "Races",
        "Constructors",
        "Circuits",
        "Pit Stops",
        "Lap Times",
        "Qualifying",
        "Driver Standings",
        "Constructor Standings",
        "Constructor Results",
        "Sprint Results",
        "Status",
        "Seasons"
    ],
    "Rows": [
        drivers.shape[0],
        results.shape[0],
        races.shape[0],
        constructors.shape[0],
        circuits.shape[0],
        pit_stops.shape[0],
        lap_times.shape[0],
        qualifying.shape[0],
        driver_standings.shape[0],
        constructor_standings.shape[0],
        constructor_results.shape[0],
        sprint_results.shape[0],
        status.shape[0],
        seasons.shape[0]
    ],
    "Columns": [
        drivers.shape[1],
        results.shape[1],
        races.shape[1],
        constructors.shape[1],
        circuits.shape[1],
        pit_stops.shape[1],
        lap_times.shape[1],
        qualifying.shape[1],
        driver_standings.shape[1],
        constructor_standings.shape[1],
        constructor_results.shape[1],
        sprint_results.shape[1],
        status.shape[1],
        seasons.shape[1]
    ]
})

print(dataset_summary)


# Merge & check

# Step 1
drivers["Driver Name"] = drivers["forename"] + " " + drivers["surname"]

# Step 2
driver_results = pd.merge(
    drivers,
    results,
    on="driverId",
    how="inner"
)


print(drivers[["driverId", "Driver Name"]].head())

print("\n========== Merged Dataset ==========")
print(driver_results.head())


# Merge with races table

driver_results = pd.merge(
    driver_results,
    races,
    on="raceId",
    how="inner"
)

print("\n========== After Merging Races ==========")
print(driver_results.head())

print("\nShape After Merging Races")
print(driver_results.shape)


# Merge with constructors table

driver_results = pd.merge(
    driver_results,
    constructors,
    on="constructorId",
    how="inner"
)

print("\n========== Final Dataset ==========")
print(driver_results.head())

print("\nFinal Shape")
print(driver_results.shape)

print("\nColumns")
print(driver_results.columns)


# business questions
#1.Which drivers have the highest average points per race?
#code
top_avg_points = (
    driver_results
    .groupby("Driver Name")["points"]
    .mean()
    .sort_values(ascending=False)
    .head(10)
)

print(top_avg_points)
#chart
plt.figure(figsize=(10,6))

top_avg_points.plot(kind="bar")

plt.title("Top 10 Drivers by Average Points")
plt.xlabel("Driver Name")
plt.ylabel("Average Points")

plt.xticks(rotation=45)

plt.tight_layout()

plt.savefig("charts/Q1_Top_Drivers_Average_Points.png",
            dpi=300,
            bbox_inches="tight")

plt.show()

## Insights
#Max Verstappen and Lewis Hamilton have the highest average points.
#These drivers consistently score well throughout the season.
#They maintain strong race performance over time.

#2.Top 10 Constructors by Average Points
#code
top_constructors = (
    driver_results
    .groupby("name_y")["points"]
    .mean()
    .sort_values(ascending=False)
    .head(10)
)

print(top_constructors)

#chart
plt.figure(figsize=(10,6))

top_constructors.plot(kind="bar")

plt.title("Top Constructors by Average Points")
plt.xlabel("Constructor Name")
plt.tight_layout()

plt.savefig("charts/Q2_Top_Constructors_Average_Points.png",
            dpi=300,
            bbox_inches="tight")

plt.show()

#3.Driver Nationality Distribution
#code
driver_results["nationality_x"].value_counts().head(10)

#chart
driver_results["nationality_x"].value_counts().head(10).plot(kind="bar")

plt.title("Top Driver Nationalities")
plt.xlabel("Nationality")
plt.ylabel("Count")

plt.tight_layout()

plt.savefig("charts/Q3_Driver_Nationality_Distribution.png",
            dpi=300,
            bbox_inches="tight")

plt.show()

#4.Points Distribution
plt.figure(figsize=(8,5))

plt.hist(driver_results["points"], bins=20)

plt.title("Distribution of Driver Points")

plt.tight_layout()

plt.savefig("charts/Q4_Driver_Points_Distribution.png",
            dpi=300,
            bbox_inches="tight")

plt.show()

#5.Grid Position vs Finish Position
plt.figure(figsize=(8,6))

plt.scatter(
    driver_results["grid"],
    driver_results["positionOrder"]
)

plt.xlabel("Starting Grid")

plt.ylabel("Finish Position")

plt.title("Grid Position vs Finish Position")

plt.tight_layout()

plt.savefig("charts/Q5_Grid_vs_Finish_Position.png",
            dpi=300,
            bbox_inches="tight")

plt.show()

#6.Which drivers have participated in the highest number of Formula 1 races?-Top 10 Drivers by Total Race Starts
#code
top_race_starts = (
    driver_results
    .groupby("Driver Name")["raceId"]
    .count()
    .sort_values(ascending=False)
    .head(10)
)

print(top_race_starts)

#chart
plt.figure(figsize=(10,6))
top_race_starts.plot(kind="bar", color="steelblue")
plt.title("Top 10 Drivers by Race Starts")
plt.xlabel("Driver")
plt.ylabel("Race Starts")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("charts/Q6_Top_Drivers_Race_Starts.png",
            dpi=300,
            bbox_inches="tight")
plt.show()

#7.Top 10 Constructors by Race Starts
#code
top_constructor_races = (
    driver_results
    .groupby("name_y")["raceId"]
    .count()
    .sort_values(ascending=False)
    .head(10)
)

print(top_constructor_races)

#chart
plt.figure(figsize=(10,6))
top_constructor_races.plot(kind="bar")
plt.title("Top Constructors by Race Starts")
plt.xlabel("Constructor")
plt.ylabel("Race Starts")
plt.xticks(rotation=45)
plt.tight_layout()


plt.savefig("charts/Q7_Top_Constructors_Race_Starts.png",
            dpi=300,
            bbox_inches="tight")

plt.show()

#8.Top 10 Drivers by Total Laps Completed
#code
top_laps = (
    driver_results
    .groupby("Driver Name")["laps"]
    .sum()
    .sort_values(ascending=False)
    .head(10)
)

print(top_laps)

#chart
plt.figure(figsize=(10,6))

top_laps.plot(kind="bar")

plt.title("Top 10 Drivers by Total Laps Completed")
plt.xlabel("Driver Name")
plt.ylabel("Total Laps")

plt.xticks(rotation=45)

plt.tight_layout()

plt.savefig("charts/Q8_Top_Drivers_Total_Laps.png",
            dpi=300,
            bbox_inches="tight")

plt.show()

#9.Top 10 Drivers by Total Podium Finishes
#Which drivers have achieved the highest number of podium finishes (positions 1, 2, or 3)?
#code
podiums = (
    driver_results[driver_results["positionOrder"] <= 3]
    .groupby("Driver Name")["positionOrder"]
    .count()
    .sort_values(ascending=False)
    .head(10)
)

print(podiums)

#chart
plt.figure(figsize=(10,6))

podiums.plot(kind="bar", color="gold")

plt.title("Top 10 Drivers by Podium Finishes")
plt.xlabel("Driver Name")
plt.ylabel("Number of Podiums")

plt.xticks(rotation=45)

plt.tight_layout()

plt.savefig("charts/Q9_Top_Drivers_Podium_Finishes.png",
            dpi=300,
            bbox_inches="tight")

plt.show()

#10.Top 10 Constructors by Total Race Wins
#Which constructors have won the most Formula 1 races?
#code
constructor_wins = (
    driver_results[driver_results["positionOrder"] == 1]
    .groupby("name_y")["positionOrder"]
    .count()
    .sort_values(ascending=False)
    .head(10)
)

print(constructor_wins)

#chart
plt.figure(figsize=(10,6))

constructor_wins.plot(kind="barh", color="red")

plt.title("Top Constructors by Race Wins")
plt.xlabel("Number of Wins")

plt.tight_layout()

plt.savefig("charts/Q10_Top_Constructors_Race_Wins.png",
            dpi=300,
            bbox_inches="tight")

plt.show()

#11.Average Points Scored Per Season
#How has the average number of points scored per race changed over the years?
#code
avg_points_year = (
    driver_results
    .groupby("year")["points"]
    .mean()
)

print(avg_points_year)

#chart
plt.figure(figsize=(12,6))

avg_points_year.plot(kind="line", marker="o")

plt.title("Average Driver Points Per Season")
plt.xlabel("Season")
plt.ylabel("Average Points")

plt.grid(True)

plt.tight_layout()

plt.savefig("charts/Q11_Average_Driver_Points_Per_Season.png",
            dpi=300,
            bbox_inches="tight")

plt.show()

# 12.Top 10 Constructors by Total Points
#code
constructor_points = (
    driver_results
    .groupby("name_y")["points"]
    .sum()
    .sort_values(ascending=False)
    .head(10)
)

print(constructor_points)

#chart
plt.figure(figsize=(10,6))

constructor_points.plot(kind="barh", color="green")

plt.title("Top 10 Constructors by Total Points")
plt.xlabel("Total Points")
plt.ylabel("Constructor")

plt.tight_layout()

plt.savefig("charts/Q12_Top_Constructors_Total_Points.png", dpi=300, bbox_inches="tight")
plt.show()