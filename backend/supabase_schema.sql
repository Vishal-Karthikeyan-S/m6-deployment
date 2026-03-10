
-- Supabase Schema for Crop Disease Diagnosis App

-- 1. Create Media table
CREATE TABLE IF NOT EXISTS public.media (
    media_id TEXT PRIMARY KEY,
    media_type TEXT,
    status TEXT DEFAULT 'UPLOADED',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    result TEXT,
    confidence FLOAT,
    severity TEXT
);

-- 2. Create Remediation table
CREATE TABLE IF NOT EXISTS public.remediation (
    disease_id TEXT PRIMARY KEY,
    disease_name TEXT NOT NULL,
    general_advice TEXT
);

-- 3. Create Treatment Steps table
CREATE TABLE IF NOT EXISTS public.treatment_steps (
    id SERIAL PRIMARY KEY,
    disease_id TEXT REFERENCES public.remediation(disease_id),
    step_number INTEGER,
    title TEXT,
    description TEXT,
    type TEXT, -- 'organic', 'chemical', 'cultural'
    safety_level TEXT,
    dosage TEXT,
    timing TEXT,
    safety_warnings JSONB DEFAULT '[]'::jsonb,
    ppe_required JSONB DEFAULT '[]'::jsonb,
    weather_dependent BOOLEAN DEFAULT false
);

-- Enable Row Level Security (RLS) - Optional but good practice
-- ALTER TABLE public.media ENABLE ROW LEVEL SECURITY;
-- Create policies as needed...
