# UrbanPulse – Smart City Service Intelligence
Automation: citizen complaint document -> AI extraction -> validated ticket -> database.

**Flow:** upload (.txt/.pdf/.docx) -> text extraction -> Claude with JSON-schema prompt -> Pydantic validation -> `tickets` row (CREATE) -> frontend confirmation -> status change (UPDATE).

## Run locally
```
cd backend
pip install -r requirements.txt
export ANTHROPIC_API_KEY=your-key        # Windows: set ANTHROPIC_API_KEY=your-key
uvicorn main:app --reload                # http://localhost:8000
```
Open `frontend/index.html` in a browser (or `python -m http.server 5500` inside `frontend/`).

## Deploy (required)
1. **Database:** create a free Supabase project; copy the Postgres connection string (Settings > Database). Tables are created automatically (`schema.sql` is for reference).
2. **Backend (Render):** new Web Service from your GitHub repo, root `backend`, build `pip install -r requirements.txt`, start `uvicorn main:app --host 0.0.0.0 --port $PORT`. Env vars: `ANTHROPIC_API_KEY`, `DATABASE_URL`, `ALLOWED_ORIGINS` (your frontend URL).
3. **Frontend (Vercel/Netlify):** in `frontend/index.html` replace `"http://localhost:8000"` with your Render URL, then deploy the `frontend` folder. **Submit this URL.**

## Test cases (for the report)
| # | File | Expected |
|---|------|----------|
| 1 | `samples/1_pothole_complete.txt` | Ticket saved, roads / high, validation passed |
| 2 | `samples/2_vague_missing_fields.txt` | Saved, location and reporter flagged "Not found", needs review |
| 3 | `samples/3_not_a_complaint.txt` | Saved as category "other", description missing, needs review |
| 4 | empty file | Error: "The file is empty." |
| 5 | `.png` file | Error: unsupported file type |
| 6 | backend stopped | Error: "Cannot reach the server" |

## Viva cheat-sheet
- **Schema:** category, urgency (enums), location, description, reporter_name (nullable). Enforced by Pydantic, so invalid enums are rejected (HTTP 502).
- **No invention:** prompt says use null for unknown values; backend records them in `missing_fields` and the UI shows "Not found in document".
- **Routing:** category maps to a department (`DEPARTMENTS` in `main.py`).
- **Create/Update:** `POST /api/tickets/upload` inserts a ticket; `PATCH /api/tickets/{id}` updates status.
- **Safety:** document text is wrapped in `<document>` tags and treated as data (prompt-injection guard); 5 MB limit; only 3 file types.
- **Limitations:** no scanned-PDF OCR, no login, no photo/audio input, English complaints only.
