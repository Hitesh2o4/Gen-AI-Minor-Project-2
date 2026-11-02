-- Optional: run in Supabase SQL editor. The backend also creates this table automatically.
CREATE TABLE IF NOT EXISTS tickets (
  id SERIAL PRIMARY KEY,
  category VARCHAR(30) NOT NULL,
  urgency VARCHAR(10) NOT NULL,
  location VARCHAR(200),
  description TEXT,
  reporter_name VARCHAR(100),
  department VARCHAR(50) NOT NULL,
  missing_fields VARCHAR(100) DEFAULT '',
  status VARCHAR(20) NOT NULL DEFAULT 'open',
  source_file VARCHAR(200),
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);
