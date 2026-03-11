# Developer & Deployment Documentation

This document outlines the architecture, setup instructions, and deployment pipelines for the AI-Enabled Crop Disease Diagnosis Support System.

## 🏗 System Architecture

The project is structured as a decoupled monorepo containing three main components:

1. **Frontend (Flutter)**: A cross-platform mobile and web application.
2. **Backend (FastAPI)**: A Python-based RESTful API serving the Machine Learning model.
3. **Database & Storage (Supabase)**: A PostgreSQL database for storing diagnosis history and an S3-compatible storage bucket for preserving uploaded crop images.

---

## 🛠 Local Development Setup

### Prerequisites
- Flutter SDK (stable)
- Python 3.11+
- Git

### 1. Backend Setup (Local)
```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r app/requirements.txt
```

**Environment Variables (.env)**
Create a `.env` file in the `backend/` directory:
```env
# Supabase Configuration
DATABASE_URL=postgresql://postgres.[project-id]:[password]@aws-0-[region].pooler.supabase.com:6543/postgres
SUPABASE_URL=https://[project-id].supabase.co
SUPABASE_KEY=your-anon-public-key
SUPABASE_BUCKET=crop-images
```

**Run the Backend Server**
```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```
The API will be available at `http://localhost:8000`.

### 2. Frontend Setup (Local)
```bash
cd frontend
flutter clean
flutter pub get
```

**Run the Frontend App**
```bash
# Target Chrome (Web) or an active Emulator/Device
flutter run -d chrome
```
*Note: The frontend automatically connects to `http://localhost:8000` when running locally.*

---

## 🚀 Production Deployment Guide

### 1. Database & Storage (Supabase)
1. Create a project on [Supabase.com](https://supabase.com).
2. Run the `new_backend/backend/supabase_schema.sql` script in the Supabase SQL Editor to initialize the tables.
3. (Optional) Run `new_backend/backend/seed_data.sql` to populate remediation logic.
4. Go to **Storage**, create a **Public** bucket named `crop-images`.
5. Retrieve your `DATABASE_URL`, `SUPABASE_URL`, and `SUPABASE_KEY` from the project settings.

### 2. Backend Hosting (Render)
1. Create a **Web Service** on [Render.com](https://render.com).
2. Connect this GitHub repository.
3. **Build Command**: Render automatically uses the included `Dockerfile`.
4. **Environment Variables**: Add all the variables listed in the Local Setup section above, plus:
   - `PYTHON_VERSION`: `3.11`
5. Deploy the service. (e.g., `https://m6-deployment.onrender.com`)

### 3. Frontend Web Hosting (Vercel)
The Vercel deployment is entirely automated by GitHub Actions.
1. Go to **Settings > Secrets and variables > Actions** in GitHub.
2. Add a Repository Secret: `BACKEND_URL` = `https://your-backend-url.onrender.com` (NO trailing slash).
3. Connect your repository to [Vercel](https://vercel.com).
4. **CRITICAL VERCEL SETTING**: 
   - Go to Vercel Project Settings > General.
   - Set **Root Directory** to `web-release`.
   - Set **Framework Preset** to `Other`.

---

## 🛸 CI/CD Pipeline (GitHub Actions)

The repository uses a single unified workflow (`.github/workflows/ci-cd.yml`) to ensure code quality and automate deployments.

**Workflow Triggers:**
- Pushes to the `main` branch.
- Pull Requests to the `main` branch.

**Pipeline Stages:**
1. **Backend Tests (`pytest`)**: Uses an in-memory SQLite database (`StaticPool`) to securely test API endpoints, upload logic, and database state without affecting production.
2. **Frontend Tests (`flutter test`)**: Runs unit and widget tests to ensure UI reliability.
3. **Web Deployment (`deploy-web`)**:
   - **Quality Gate**: Only runs if *both* Backend and Frontend tests pass.
   - Compiles the Flutter Web App, injecting the `BACKEND_URL` secret.
   - Pushes the compiled static files (with `vercel.json` for SPA routing) directly to the `web-release` directory on the `main` branch.
   - Vercel automatically detects the update in `web-release` and goes live.

---

## 🧠 Machine Learning Model

The disease classification model utilizes a **Fast Fine-Tuning** approach.
- **Architecture**: Transfer learning with a frozen backbone.
- **Calibration**: The classification head is re-trained strictly on the 14 localized crop diseases (+1 Healthy class) found in the user's dataset.
- **Label Mapping**: Internal indices are explicitly mapped to the backend logic, guaranteeing that predictions like "Tomato Spider Mites" correspond exactly to the database remediation schema.
