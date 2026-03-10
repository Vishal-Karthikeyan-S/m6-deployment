from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

import os

# Read from environment variables for public deployment, fallback to SQLite for local
DATABASE_URL = os.getenv("DATABASE_URL")

if DATABASE_URL:
    # Handle Render/Supabase connection strings that might use postgres:// instead of postgresql://
    if DATABASE_URL.startswith("postgres://"):
        DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql://", 1)
    
    print("USING POSTGRES DATABASE")
    engine = create_engine(DATABASE_URL)
else:
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    DATABASE_PATH = os.path.join(BASE_DIR, "crop_diagnosis.db")
    DATABASE_URL = f"sqlite:///{DATABASE_PATH}"
    print(f"USING LOCAL SQLITE AT: {DATABASE_PATH}")
    engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)
