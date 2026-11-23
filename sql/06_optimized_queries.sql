-- Optimized queries for CP3 (same as baseline but will benefit from new indexes)
SET search_path TO netflix;
BEGIN;

-- @R01
SELECT DISTINCT ON (v.title_id) v.title_id, t.name, v.episode_id, v.duration_watched_sec, v.started_at
FROM viewing_activity v
JOIN titles t ON t.title_id = v.title_id
WHERE v.profile_id = 7043 AND NOT v.completed
ORDER BY v.title_id, v.started_at DESC;

-- @R02
SELECT season_no, count(*) AS episodes, min(release_date) AS released
FROM episodes
WHERE title_id = 2909
GROUP BY season_no
ORDER BY season_no;

-- @R03
SELECT t.title_id, t.name, count(DISTINCT v.profile_id) AS viewers
FROM viewing_activity v
JOIN titles t ON t.title_id = v.title_id
WHERE v.started_at >= '2026-06-30' AND v.started_at < '2026-07-01'
GROUP BY t.title_id, t.name
ORDER BY viewers DESC
LIMIT 10;

-- @R04
SELECT t.title_id, t.name, t.maturity_rating, t.added_on
FROM titles t
JOIN title_genres tg ON tg.title_id = t.title_id
JOIN genres g ON g.genre_id = tg.genre_id
WHERE g.genre_name = 'Comedy'
  AND t.maturity_rating IN ('U', 'UA7')
ORDER BY t.added_on DESC
LIMIT 40;

-- @R05
SELECT title_id, name, title_type, release_year
FROM titles
WHERE name ILIKE '%love%'
ORDER BY release_year DESC
LIMIT 30;

-- @R06
SELECT t.title_id, t.name, t.title_type, m.added_at
FROM my_list m
JOIN titles t ON t.title_id = m.title_id
WHERE m.profile_id = 7393
ORDER BY m.added_at DESC;

-- @R07
SELECT episode_id, season_no, episode_no, episode_title
FROM episodes
WHERE title_id = 2909
  AND (season_no, episode_no) > (1, 4)
ORDER BY season_no, episode_no
LIMIT 1;

-- @R08
SELECT profile_id, title_id, started_at::date AS day, count(*) AS episodes
FROM viewing_activity
WHERE episode_id IS NOT NULL
  AND started_at >= '2026-06-01'
GROUP BY profile_id, title_id, started_at::date
HAVING count(*) >= 3
ORDER BY episodes DESC, day;

-- @R09
SELECT g.genre_name, count(*) AS views,
       round(100.0 * count(*) FILTER (WHERE v.completed) / count(*), 1) AS completion_pct
FROM viewing_activity v
JOIN title_genres tg ON tg.title_id = v.title_id
JOIN genres g ON g.genre_id = tg.genre_id
WHERE EXTRACT(YEAR FROM v.started_at) = 2026
GROUP BY g.genre_name
ORDER BY completion_pct DESC;

-- @R10
SELECT account_id, plan_id, status
FROM accounts
WHERE lower(email) = 'arjun.chopra1409@yahoo.com';

-- @R11
SELECT i.invoice_id, i.account_id, i.amount_inr
FROM invoices i
JOIN accounts a ON a.account_id = i.account_id
WHERE i.status = 'FAILED'
  AND i.billing_period_start = '2026-06-01'
  AND a.status IN ('ACTIVE', 'ON_HOLD')
ORDER BY i.account_id;

-- @R12
SELECT date_trunc('month', cancelled_on) AS month, count(*) AS cancellations,
       round(avg(cancelled_on - signup_date), 0) AS avg_tenure_days
FROM accounts
WHERE status = 'CANCELLED'
  AND EXTRACT(YEAR FROM cancelled_on) = 2026
GROUP BY 1
ORDER BY 1;

-- @R13
SELECT e.episode_id, e.season_no, e.episode_no
FROM episodes e
WHERE e.title_id = 2523
  AND e.episode_id NOT IN (SELECT v.episode_id FROM viewing_activity v);

-- @R14
SELECT p.profile_id, p.maturity_limit, t.title_id, t.maturity_rating, v.started_at
FROM viewing_activity v
JOIN profiles p ON p.profile_id = v.profile_id
JOIN titles t ON t.title_id = v.title_id
WHERE p.is_kids
  AND array_position(ARRAY['U','UA7','UA13','UA16','A'], t.maturity_rating) >
      array_position(ARRAY['U','UA7','UA13','UA16','A'], p.maturity_limit)
ORDER BY v.started_at DESC;

-- @R15
SELECT p.plan_name, count(*) AS accounts, sum(p.monthly_price_inr) AS monthly_revenue_inr
FROM accounts a
JOIN plans p ON p.plan_id = a.plan_id
WHERE a.status = 'ACTIVE'
GROUP BY p.plan_name
ORDER BY monthly_revenue_inr DESC;

-- @R16
SELECT pr.account_id, date_trunc('hour', v.started_at) AS hour,
       count(DISTINCT v.profile_id) AS profiles_watching, pl.max_streams
FROM viewing_activity v
JOIN profiles pr ON pr.profile_id = v.profile_id
JOIN accounts a ON a.account_id = pr.account_id
JOIN plans pl ON pl.plan_id = a.plan_id
GROUP BY pr.account_id, date_trunc('hour', v.started_at), pl.max_streams
HAVING count(DISTINCT v.profile_id) > pl.max_streams
ORDER BY profiles_watching DESC;

-- @R17
SELECT t.is_netflix_original,
       count(*) AS ratings,
       round(100.0 * count(*) FILTER (WHERE r.rating = 'LOVE') / count(*), 1) AS love_pct
FROM ratings r
JOIN titles t ON t.title_id = r.title_id
GROUP BY t.is_netflix_original;

-- @R18
SELECT date_trunc('month', started_at) AS month, device_type,
       round(sum(duration_watched_sec) / 3600.0, 0) AS hours
FROM viewing_activity
WHERE started_at::date >= '2026-01-01'
GROUP BY 1, 2
ORDER BY 1, 2;

-- @R19
SELECT t.title_id, t.name,
       (SELECT count(*) FROM viewing_activity v WHERE v.title_id = t.title_id) AS total_views,
       (SELECT max(v.started_at) FROM viewing_activity v WHERE v.title_id = t.title_id) AS last_viewed_at
FROM titles t
WHERE t.is_netflix_original
ORDER BY total_views DESC;

-- @R20
SELECT m.title_id, t.name, count(*) AS adds
FROM my_list m
JOIN titles t ON t.title_id = m.title_id
WHERE m.added_at >= '2026-06-01' AND m.added_at < '2026-07-01'
GROUP BY m.title_id, t.name
ORDER BY adds DESC
LIMIT 10;

-- @R21
SELECT account_id, email, next_billing_date
FROM accounts
WHERE status = 'ON_HOLD'
  AND next_billing_date < '2026-07-01'
ORDER BY next_billing_date;

-- @R22
SELECT title_id, name, leaving_on
FROM titles
WHERE leaving_on BETWEEN '2026-07-01' AND '2026-07-31'
ORDER BY leaving_on;

-- @R23
SELECT view_id, profile_id, title_id, episode_id, started_at
FROM viewing_activity
ORDER BY started_at DESC
OFFSET 150000
LIMIT 25;

-- @R24
SELECT profile_id, profile_name, is_kids, maturity_limit
FROM profiles
WHERE account_id = 1409
ORDER BY created_at;

-- @R25
SELECT tg2.title_id, count(*) AS shared_genres
FROM title_genres tg1
JOIN title_genres tg2 ON tg2.genre_id = tg1.genre_id AND tg2.title_id <> tg1.title_id
WHERE tg1.title_id = 2909
GROUP BY tg2.title_id
HAVING count(*) >= 2
ORDER BY shared_genres DESC, tg2.title_id
LIMIT 20;

-- @W01
INSERT INTO viewing_activity (view_id, profile_id, title_id, episode_id, started_at, duration_watched_sec, device_type, completed)
SELECT 90000001, 7043, 2909, episode_id, '2026-07-01 21:00:00+05:30', 120, 'TV', FALSE
FROM episodes WHERE title_id = 2909 AND season_no = 1 AND episode_no = 5;

-- @W02
INSERT INTO my_list (profile_id, title_id, added_at)
VALUES (7043, 2523, '2026-07-01 21:05:00+05:30')
ON CONFLICT (profile_id, title_id) DO NOTHING;

-- @W03
UPDATE accounts
SET plan_id = (SELECT plan_id FROM plans WHERE plan_name = 'STANDARD')
WHERE account_id = 1409;

-- @W04
INSERT INTO invoices (invoice_id, account_id, billing_period_start, amount_inr, status, paid_at)
SELECT 90000000 + a.account_id, a.account_id, DATE '2026-07-01', p.monthly_price_inr, 'PAID',
       TIMESTAMPTZ '2026-07-01 06:00:00+05:30'
FROM accounts a
JOIN plans p ON p.plan_id = a.plan_id
WHERE a.status = 'ACTIVE';

-- @W05
UPDATE accounts a
SET status = 'ON_HOLD'
WHERE a.status = 'ACTIVE'
  AND EXISTS (SELECT 1 FROM invoices i
               WHERE i.account_id = a.account_id
                 AND i.billing_period_start = '2026-06-01'
                 AND i.status = 'FAILED');

ROLLBACK;
