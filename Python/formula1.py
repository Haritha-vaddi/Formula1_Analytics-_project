import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

connection_url = URL.create(
    "mysql+pymysql",
    username="root",
    password="Hariv@2002",
    host="127.0.0.1",
    port=3306,
    database="formula1_analytics"
)

engine = create_engine(connection_url)

print("✅ Connected Successfully!")

lap_times = pd.read_csv("../Dataset/lap_times.csv")

print("Rows in CSV:", len(lap_times))

lap_times.to_sql(
    "lap_times",
    con=engine,
    if_exists="replace",
    index=False
)


print("✅ Lap Times imported successfully!")





