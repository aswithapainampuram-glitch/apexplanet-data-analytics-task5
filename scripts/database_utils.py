import pandas as pd
from sqlalchemy import create_engine


def create_database(csv_path, database_path):
    """
    Load CSV data and create a SQLite database.
    """

    df = pd.read_csv(csv_path)

    engine = create_engine(
        f"sqlite:///{database_path}"
    )

    df.to_sql(
        "superstore",
        engine,
        if_exists="replace",
        index=False
    )

    print("Database created successfully.")

    return engine


def run_query(engine, query):
    """
    Execute a SQL query and return the result as a DataFrame.
    """

    result = pd.read_sql(query, engine)

    return result