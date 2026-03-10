from fastapi import FastAPI
from app.routes import prediction
from app.routes import upload, process, status, remediation
from app.models.base import Base
from app.models import media
from app.database import engine

from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Farmer Crop Diagnosis Backend")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

Base.metadata.create_all(bind=engine)
app.include_router(upload.router)
app.include_router(process.router)
app.include_router(status.router)
app.include_router(prediction.router)
app.include_router(remediation.router)

@app.get("/health")
def health():
    return {"status": "Backend running"}


@app.get("/")
def root():
    return {"message": "API is running"}
