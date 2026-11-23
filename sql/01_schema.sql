-- Netflix Streaming Database
-- PostgreSQL schema
-- Team T0027
CREATE SCHEMA IF NOT EXISTS netflix;
SET search_path TO netflix;
-- PostgreSQL schema
-- Team T0027

CREATE TABLE IF NOT EXISTS plans (
    plan_id INTEGER PRIMARY KEY,
    plan_name VARCHAR(30) NOT NULL,
    monthly_price_inr NUMERIC(10,2) NOT NULL CHECK (monthly_price_inr >= 0),
    max_streams SMALLINT NOT NULL CHECK (max_streams > 0),
    max_resolution VARCHAR(10) NOT NULL,
    has_ads BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS accounts (
    account_id INTEGER PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    country_code VARCHAR(5) NOT NULL,
    plan_id INTEGER NOT NULL REFERENCES plans(plan_id),
    signup_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    cancelled_on DATE,
    next_billing_date DATE
);

CREATE TABLE IF NOT EXISTS profiles (
    profile_id INTEGER PRIMARY KEY,
    account_id INTEGER NOT NULL REFERENCES accounts(account_id),
    profile_name VARCHAR(100) NOT NULL,
    is_kids BOOLEAN NOT NULL,
    maturity_limit VARCHAR(20) NOT NULL,
    language VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE IF NOT EXISTS genres (
    genre_id INTEGER PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS titles (
    title_id INTEGER PRIMARY KEY,
    title_type VARCHAR(20) NOT NULL,
    name VARCHAR(255) NOT NULL,
    release_year SMALLINT NOT NULL,
    maturity_rating VARCHAR(20) NOT NULL,
    original_language VARCHAR(50) NOT NULL,
    runtime_min INTEGER CHECK (runtime_min > 0),
    is_netflix_original BOOLEAN NOT NULL,
    added_on DATE NOT NULL,
    leaving_on DATE
);

CREATE TABLE IF NOT EXISTS title_genres (
    title_id INTEGER NOT NULL REFERENCES titles(title_id),
    genre_id INTEGER NOT NULL REFERENCES genres(genre_id),
    PRIMARY KEY (title_id, genre_id)
);

CREATE TABLE IF NOT EXISTS episodes (
    episode_id INTEGER PRIMARY KEY,
    title_id INTEGER NOT NULL REFERENCES titles(title_id),
    season_no SMALLINT NOT NULL CHECK (season_no > 0),
    episode_no SMALLINT NOT NULL CHECK (episode_no > 0),
    episode_title VARCHAR(255) NOT NULL,
    runtime_min INTEGER NOT NULL CHECK (runtime_min > 0),
    release_date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS viewing_activity (
    view_id INTEGER PRIMARY KEY,
    profile_id INTEGER NOT NULL REFERENCES profiles(profile_id),
    title_id INTEGER NOT NULL REFERENCES titles(title_id),
    episode_id INTEGER REFERENCES episodes(episode_id),
    started_at TIMESTAMPTZ NOT NULL,
    duration_watched_sec INTEGER NOT NULL CHECK (duration_watched_sec >= 0),
    device_type VARCHAR(30) NOT NULL,
    completed BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS ratings (
    profile_id INTEGER NOT NULL REFERENCES profiles(profile_id),
    title_id INTEGER NOT NULL REFERENCES titles(title_id),
    rating VARCHAR(30) NOT NULL,
    rated_at TIMESTAMPTZ NOT NULL,
    PRIMARY KEY (profile_id, title_id)
);

CREATE TABLE IF NOT EXISTS my_list (
    profile_id INTEGER NOT NULL REFERENCES profiles(profile_id),
    title_id INTEGER NOT NULL REFERENCES titles(title_id),
    added_at TIMESTAMPTZ NOT NULL,
    PRIMARY KEY (profile_id, title_id)
);

CREATE TABLE IF NOT EXISTS invoices (
    invoice_id INTEGER PRIMARY KEY,
    account_id INTEGER NOT NULL REFERENCES accounts(account_id),
    billing_period_start DATE NOT NULL,
    amount_inr NUMERIC(10,2) NOT NULL CHECK (amount_inr >= 0),
    status VARCHAR(20) NOT NULL,
    paid_at TIMESTAMPTZ
);
