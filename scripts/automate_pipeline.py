import pandas as pd
import os
from pathlib import Path

# Find the project folder automatically
BASE_DIR = Path(__file__).resolve().parent.parent

# File paths
input_file = BASE_DIR / "data" / "SampleSuperstore.csv"
output_file = BASE_DIR / "data" / "processed" / "cleaned_superstore.csv"
excel_file = BASE_DIR / "outputs" / "KPI_Report.xlsx"

# Create output folders
(BASE_DIR / "data" / "processed").mkdir(parents=True, exist_ok=True)
(BASE_DIR / "outputs").mkdir(parents=True, exist_ok=True)
# --------------------------------
# 1. Load raw data
# --------------------------------

print("Loading raw data...")

df = pd.read_csv(input_file)

print("Data loaded successfully!")
print("Rows:", len(df))
print("Columns:", len(df))

# --------------------------------
# 2. Clean data
# --------------------------------

print("Cleaning data...")

# Remove duplicate rows
df = df.drop_duplicates()

# Remove completely empty rows
df = df.dropna(how="all")

print("Data cleaning completed!")

# --------------------------------
# 3. Save processed data
# --------------------------------

df.to_csv(output_file, index=False)

print("Cleaned data saved to:")
print(output_file)

# --------------------------------
# 4. Calculate KPIs
# --------------------------------

print("Calculating KPIs...")

total_sales = df["Sales"].sum()
total_profit = df["Profit"].sum()
total_quantity = df["Quantity"].sum()

total_orders = df["Order ID"].nunique()

average_order_value = total_sales / total_orders

profit_margin = (total_profit / total_sales) * 100

# --------------------------------
# 5. Create KPI table
# --------------------------------

kpi = pd.DataFrame({
    "KPI": [
        "Total Sales",
        "Total Profit",
        "Total Quantity",
        "Total Orders",
        "Average Order Value",
        "Profit Margin (%)"
    ],
    "Value": [
        total_sales,
        total_profit,
        total_quantity,
        total_orders,
        average_order_value,
        profit_margin
    ]
})

# --------------------------------
# 6. Category Analysis
# --------------------------------

category_analysis = (
    df.groupby("Category")
    .agg(
        Sales=("Sales", "sum"),
        Profit=("Profit", "sum"),
        Quantity=("Quantity", "sum")
    )
    .reset_index()
)

# --------------------------------
# 7. Region Analysis
# --------------------------------

region_analysis = (
    df.groupby("Region")
    .agg(
        Sales=("Sales", "sum"),
        Profit=("Profit", "sum"),
        Quantity=("Quantity", "sum")
    )
    .reset_index()
)

# --------------------------------
# 8. Top Customers
# --------------------------------

top_customers = (
    df.groupby("Customer Name")
    .agg(
        Sales=("Sales", "sum"),
        Profit=("Profit", "sum")
    )
    .sort_values("Sales", ascending=False)
    .head(10)
    .reset_index()
)

# --------------------------------
# 9. Export to Excel
# --------------------------------

print("Creating Excel report...")

with pd.ExcelWriter(excel_file, engine="openpyxl") as writer:

    kpi.to_excel(
        writer,
        sheet_name="KPI Summary",
        index=False
    )

    category_analysis.to_excel(
        writer,
        sheet_name="Category Analysis",
        index=False
    )

    region_analysis.to_excel(
        writer,
        sheet_name="Region Analysis",
        index=False
    )

    top_customers.to_excel(
        writer,
        sheet_name="Top Customers",
        index=False
    )

print("Excel report created:")
print(excel_file)

# --------------------------------
# Finished
# --------------------------------

print()
print("================================")
print("PIPELINE COMPLETED SUCCESSFULLY")
print("================================")
print("Total Sales:", total_sales)
print("Total Profit:", total_profit)
print("Total Quantity:", total_quantity)
print("Total Orders:", total_orders)
print("Average Order Value:", round(average_order_value, 2))
print("Profit Margin:", round(profit_margin, 2), "%")