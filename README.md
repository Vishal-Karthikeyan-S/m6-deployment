
# Crop Disease Diagnosis Monorepo

This repository contains both the backend and frontend for the Crop Disease Diagnosis and Remediation System.

## Project Structure
- **/backend**: FastAPI server with ML models and PostgreSQL/Supabase integration.
- **/frontend**: Flutter web application.

## Deployment Guide

### Backend (Render)
1. Create a **Web Service** on Render.
2. Root Directory: `backend`
3. Build Command: `pip install -r requirements.txt`
4. Start Command: `gunicorn app.main:app --workers 4 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000 --timeout 120`
5. **Environment Variables**: See `backend/.env.example`

### Frontend (Vercel)
1. Create a project on Vercel.
2. Root Directory: `frontend`
3. Framework Preset: `Other`
4. Build Command: `flutter build web --release --dart-define=BACKEND_URL=https://your-backend.onrender.com`
5. Output Directory: `build/web`
