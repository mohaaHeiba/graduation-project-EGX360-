from supabase import create_client

# --- Supabase Config ---
SUPABASE_URL = "https://uxxhvhleyniwjobghoad.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV4eGh2aGxleW5pd2pvYmdob2FkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk1NjIyMDQsImV4cCI6MjA3NTEzODIwNH0.EIfX5om-YPcQ6_3CAD1gtQ-Vq1UOdTyi9kgn5oiXxdo"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)  

# --- TradingView Login ---
TV_USERNAME =None #"mohameHeiba"
TV_PASSWORD =None #"Karm88998899"

# --- Common Settings ---
UPDATE_INTERVAL = 15  # seconds
MARKET_OPEN_HOUR = 10
MARKET_CLOSE_HOUR = 14
MARKET_CLOSE_MIN = 30
