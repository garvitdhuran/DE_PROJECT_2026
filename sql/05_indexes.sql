SET search_path TO netflix;

-- 1. Viewing activity: frequent filters on profile_id, completed flag, title_id and started_at
CREATE INDEX IF NOT EXISTS idx_viewing_profile_completed_title_started ON viewing_activity (profile_id, completed, title_id, started_at DESC);

-- 2. Episodes: lookup by title_id (R02, R07, R13)
CREATE INDEX IF NOT EXISTS idx_episodes_title_id ON episodes (title_id);

-- 3. Episodes composite for season/episode ordering (R07)
CREATE INDEX IF NOT EXISTS idx_episodes_title_season_episode ON episodes (title_id, season_no, episode_no);

-- 4. Viewing activity started_at range queries (R03, R08, R18, R23)
CREATE INDEX IF NOT EXISTS idx_viewing_started_at ON viewing_activity (started_at);

-- 5. Titles: search by name (ILIKE) – expression index for case‑insensitive search (R05)
CREATE INDEX IF NOT EXISTS idx_titles_lower_name ON titles (lower(name));

-- 6. My list: filter by profile_id and ordering by added_at (R06, R20)
CREATE INDEX IF NOT EXISTS idx_mylist_profile_added ON my_list (profile_id, added_at DESC);

-- 7. Title genres: join on genre_id and title_id (R04, R09, R25)
CREATE INDEX IF NOT EXISTS idx_title_genres_title_id ON title_genres (title_id);
CREATE INDEX IF NOT EXISTS idx_title_genres_genre_id ON title_genres (genre_id);

-- 8. Genres: filter by genre_name (R04)
CREATE INDEX IF NOT EXISTS idx_genres_name ON genres (genre_name);

-- 9. Accounts: lookup by email (case‑insensitive) (R10)
CREATE INDEX IF NOT EXISTS idx_accounts_lower_email ON accounts (lower(email));

-- 10. Invoices: status + billing period (R11, W04)
CREATE INDEX IF NOT EXISTS idx_invoices_status_period ON invoices (status, billing_period_start);

-- 11. Accounts: status + cancelled_on for churn analysis (R12)
CREATE INDEX IF NOT EXISTS idx_accounts_status_cancelled ON accounts (status, cancelled_on);

-- 12. Ratings: join on title_id (R17)
CREATE INDEX IF NOT EXISTS idx_ratings_title_id ON ratings (title_id);

-- 13. Titles: filter by maturity_rating (R14)
CREATE INDEX IF NOT EXISTS idx_titles_maturity ON titles (maturity_rating);

-- 14. Profiles: filter by is_kids flag (R14)
CREATE INDEX IF NOT EXISTS idx_profiles_is_kids ON profiles (is_kids);

-- 15. Viewing activity: device_type + started_at month aggregation (R18)
CREATE INDEX IF NOT EXISTS idx_viewing_device_started ON viewing_activity (device_type, started_at);

-- 16. Accounts: status + next_billing_date (R21)
CREATE INDEX IF NOT EXISTS idx_accounts_status_billing ON accounts (status, next_billing_date);

-- 17. Titles: leaving_on for compliance (R22)
CREATE INDEX IF NOT EXISTS idx_titles_leaving_on ON titles (leaving_on);

-- 18. Viewing activity: ordering by started_at for support console pagination (R23)
CREATE INDEX IF NOT EXISTS idx_viewing_started_at_desc ON viewing_activity (started_at DESC);

-- 19. Profiles: account_id + created_at ordering (R24)
CREATE INDEX IF NOT EXISTS idx_profiles_account_created ON profiles (account_id, created_at);

-- 20. Title genres: composite for genre‑sharing query (R25)
CREATE INDEX IF NOT EXISTS idx_title_genres_title_genre ON title_genres (title_id, genre_id);

-- 21. Accounts: plan_id for revenue aggregation (R15)
CREATE INDEX IF NOT EXISTS idx_accounts_plan_id ON accounts (plan_id);

-- 22. Plans: plan_name (used in write query W03)
CREATE INDEX IF NOT EXISTS idx_plans_name ON plans (plan_name);

-- 23. Invoices: invoice_id primary key already exists; no extra index needed.

-- 24. My List: unique constraint already enforces (profile_id, title_id).

-- 25. Viewing activity: episode_id for episode‑specific queries (R08, R13)
CREATE INDEX IF NOT EXISTS idx_viewing_episode_id ON viewing_activity (episode_id);

-- End of indexes for CP3 optimization
