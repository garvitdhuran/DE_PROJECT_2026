# 2. Database Schema Design

## 2.1 Overview

The database uses a relational model implemented in PostgreSQL. It consists of 11 tables representing subscription management, user profiles, streaming content, viewing activity and billing.

Primary keys uniquely identify records, while foreign keys maintain relationships and referential integrity between tables.

## 2.2 Table Definitions

### 1. plans
Stores subscription plan information.

| Column | Description |
|---|---|
| plan_id | Primary key |
| plan_name | Name of the subscription plan |
| monthly_price_inr | Monthly subscription price |
| max_streams | Maximum simultaneous streams |
| max_resolution | Maximum supported resolution |
| has_ads | Whether advertisements are included |

### 2. accounts
Stores subscriber account information.

| Column | Description |
|---|---|
| account_id | Primary key |
| email | Account email |
| phone | Contact phone number |
| country_code | Phone country code |
| plan_id | Foreign key referencing plans |
| signup_date | Account registration date |
| status | Account status |
| cancelled_on | Cancellation date |
| next_billing_date | Next billing date |

### 3. profiles
Stores individual profiles belonging to an account.

| Column | Description |
|---|---|
| profile_id | Primary key |
| account_id | Foreign key referencing accounts |
| profile_name | Profile display name |
| is_kids | Whether the profile is a kids profile |
| maturity_limit | Maximum permitted maturity rating |
| language | Preferred language |
| created_at | Profile creation timestamp |

### 4. genres
Stores available content genres.

| Column | Description |
|---|---|
| genre_id | Primary key |
| genre_name | Genre name |

### 5. titles
Stores movie and television series metadata.

| Column | Description |
|---|---|
| title_id | Primary key |
| title_type | Movie or series |
| name | Title name |
| release_year | Original release year |
| maturity_rating | Content maturity rating |
| original_language | Original language |
| runtime_min | Runtime in minutes |
| is_netflix_original | Whether it is a Netflix original |
| added_on | Date added to the platform |
| leaving_on | Date leaving the platform, if applicable |

### 6. title_genres
Connects titles with genres through a many-to-many relationship.

| Column | Description |
|---|---|
| title_id | Foreign key referencing titles |
| genre_id | Foreign key referencing genres |

Composite primary key: (title_id, genre_id).

### 7. episodes
Stores episodes belonging to television series.

| Column | Description |
|---|---|
| episode_id | Primary key |
| title_id | Foreign key referencing titles |
| season_no | Season number |
| episode_no | Episode number |
| episode_title | Episode name |
| runtime_min | Episode runtime |
| release_date | Episode release date |

### 8. viewing_activity
Stores profile viewing history and progress.

| Column | Description |
|---|---|
| view_id | Primary key |
| profile_id | Foreign key referencing profiles |
| title_id | Foreign key referencing titles |
| episode_id | Foreign key referencing episodes, where applicable |
| started_at | Viewing start timestamp |
| duration_watched_sec | Duration watched in seconds |
| device_type | Device used for viewing |
| completed | Whether viewing was completed |

### 9. ratings
Stores ratings submitted by profiles.

| Column | Description |
|---|---|
| profile_id | Foreign key referencing profiles |
| title_id | Foreign key referencing titles |
| rating | Rating value |
| rated_at | Rating timestamp |

Proposed composite primary key: (profile_id, title_id).

### 10. my_list
Stores titles saved by profiles.

| Column | Description |
|---|---|
| profile_id | Foreign key referencing profiles |
| title_id | Foreign key referencing titles |
| added_at | Timestamp when title was saved |

Proposed composite primary key: (profile_id, title_id).

### 11. invoices
Stores subscription billing records.

| Column | Description |
|---|---|
| invoice_id | Primary key |
| account_id | Foreign key referencing accounts |
| billing_period_start | Start of billing period |
| amount_inr | Invoice amount in INR |
| status | Invoice payment status |
| paid_at | Payment timestamp |

## 2.3 Relationships

| Parent Table | Child Table | Relationship |
|---|---|---|
| plans | accounts | One-to-many |
| accounts | profiles | One-to-many |
| accounts | invoices | One-to-many |
| titles | episodes | One-to-many |
| titles | title_genres | One-to-many |
| genres | title_genres | One-to-many |
| profiles | viewing_activity | One-to-many |
| titles | viewing_activity | One-to-many |
| episodes | viewing_activity | One-to-many, optional |
| profiles | ratings | One-to-many |
| titles | ratings | One-to-many |
| profiles | my_list | One-to-many |
| titles | my_list | One-to-many |

The title_genres table resolves the many-to-many relationship between titles and genres.

## 2.4 Key Design Decisions

1. Every main entity uses a primary key to uniquely identify its records.
2. Foreign keys enforce relationships between accounts, plans, profiles, titles and activity records.
3. The title_genres table handles the many-to-many relationship between titles and genres.
4. The ratings and my_list tables use composite primary keys to prevent duplicate profile-title combinations.
5. The episode_id in viewing_activity is optional because movie viewing records do not require an episode reference.
6. Database constraints will be finalized in the SQL schema after validating the source data.

## 2.5 Data Integrity

The implementation will use appropriate PostgreSQL data types, primary keys, foreign keys, NOT NULL constraints, UNIQUE constraints and CHECK constraints wherever supported by the data and business requirements.

The schema will be validated against the provided CSV files before data loading.
