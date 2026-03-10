from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.media import Media

router = APIRouter(prefix="/api")


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.get("/prediction/{media_id}")
def get_prediction(media_id: str, db: Session = Depends(get_db)):

    media = db.query(Media).filter(Media.media_id == media_id).first()

    print(f"FETCHING PREDICTION FOR: {media_id} | FOUND: {bool(media)}")

    if not media:
        return {"error": "Media not found", "media_id": media_id, "status": "FAILED"}

    # Final result mapping
    return {
        "media_id": media.media_id,
        "status": media.status,
        "result": media.result,
        "confidence": (media.confidence / 100.0) if (media.confidence and media.confidence > 1.0) else (media.confidence or 0.0),
        "severity": media.severity
    }
