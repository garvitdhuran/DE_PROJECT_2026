# 1. Problem Understanding

## 1.1 Project Overview

The objective of this project is to design and implement a relational database for a Netflix-like movie and series streaming platform using PostgreSQL.

The database manages subscription accounts, user profiles, streaming content, genres, episodes, viewing activity, ratings, saved titles and billing records.

The focus is on database design, query execution, performance optimization and scalability rather than developing a frontend application.

## 1.2 Project Objectives

The main objectives are:

- Design a structured relational database for streaming platform operations.
- Maintain account and subscription information.
- Support multiple profiles under a single account.
- Store and organize movies, series, episodes and genres.
- Track viewing activity and user interactions.
- Maintain ratings, saved titles and billing records.
- Execute representative SQL queries for common business operations.
- Analyze and optimize query performance using indexes and query improvements.
- Evaluate database performance with larger datasets.

## 1.3 Core Database Entities

The project dataset contains 11 CSV files corresponding to the following entities:

| Entity | Description |
|---|---|
| plans | Subscription plan details, pricing and features |
| accounts | Account information and subscription status |
| profiles | User profiles belonging to accounts |
| genres | Available content genres |
| titles | Movies and television series |
| title_genres | Mapping between titles and genres |
| episodes | Episodes belonging to television series |
| viewing_activity | Viewing history and watch progress |
| ratings | Ratings submitted by profiles |
| my_list | Titles saved by profiles |
| invoices | Account billing and payment records |

## 1.4 Business Problems and Use Cases

The database should support the following eight business problems:

### P1. Home Screen Content Retrieval
Retrieve personalized content rows such as Continue Watching and Top 10 efficiently. Viewing history and title information must be accessible through appropriate queries.

### P2. Content Details and Discovery
Retrieve movie and series details, episode information, genres and other content metadata to support title pages, episode playback and content discovery.

### P3. Account Login and Profile Switching
Retrieve account and profile information efficiently, including profile-specific settings and subscription details.

### P4. Unwatched Episode Discovery
Identify episodes that a profile has not watched, using episode information and viewing activity.

### P5. Billing and Subscription Management
Retrieve invoices, payment statuses, billing periods and subscription information to support billing operations, payment retries and account status management.

### P6. Parental Controls and Account Sharing
Use profile settings such as kids status and maturity limits to support content restrictions and account-level profile management.

### P7. Viewing and Engagement Analytics
Analyze viewing duration, completed content, ratings and viewing patterns to understand user engagement.

### P8. Revenue and Subscription Analytics
Generate reports involving subscription plans, invoice amounts, cancellations and account status to understand revenue and subscription trends.

## 1.5 Project Scope

The project covers:

- Understanding the provided dataset and business requirements.
- Designing the relational schema and identifying primary and foreign keys.
- Normalizing the database structure.
- Loading the provided CSV data into PostgreSQL.
- Creating and executing a representative SQL workload.
- Measuring query execution time using EXPLAIN ANALYZE and BUFFERS.
- Improving query performance through indexing and query optimization.
- Evaluating scalability using larger datasets.

The implementation focuses on the database layer. Frontend development, video hosting and actual video streaming infrastructure are outside the scope of this project.

## 1.6 Expected Outcome

The expected outcome is a properly structured PostgreSQL database capable of supporting the identified streaming platform operations. The project will demonstrate relational database design, data integrity, SQL querying, performance benchmarking, optimization and scalability analysis.
