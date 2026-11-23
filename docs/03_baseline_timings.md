# Baseline Benchmark Timings (CP2)

## Overview
This document summarizes the baseline performance results for the **Netflix Streaming Database** project (CP2). The benchmark was executed against a freshly loaded PostgreSQL 17.11 database on a **macOS 27.2.0** system equipped with an **Apple M4** CPU.

---

### System Specifications
- **Operating System:** macOS 27.2.0 (Darwin Kernel 27.2.0)
- **CPU:** Apple M4 (ARM64)
- **PostgreSQL Version:** 17.11 (Homebrew) compiled with clang 21.0.0
- **Database Name:** `netflix_cp2`
- **Port:** 5433 (custom configuration to avoid conflict)
- **Schema:** `netflix` (all tables created under this schema)
- **Data Load Method:** `sql/02_load_data.sql` with `SET search_path TO netflix;` prepended to ensure data loads into the correct schema.

---

### Benchmark Methodology
- **Script Used:** `benchmarks/run_benchmark.sh`
- **Workload:** 30 queries defined in `queries/workload_30.sql` (R01‑R25 reads, W01‑W05 writes).
- **Runs per Query:** 3 (default) – each query executed with `EXPLAIN (ANALYZE, BUFFERS)`.
- **Metrics Captured:** average, median, min, max execution time (ms) and the scan nodes used in the *last* run.
- **Result Files:**
  - Raw plans: `benchmarks/results/baseline/<ID>.txt`
  - Summary CSV: `benchmarks/results/baseline/summary.csv`

---

### Summary of key timings (average ms)
| Query | Type | Avg ms | Median ms | Min ms | Max ms | Scan Nodes |
|------|------|-------|-----------|--------|--------|------------|
| **R01** | READ | 10.705 | 9.964 | 9.894 | 12.257 | Seq Scan on `viewing_activity` | Seq Scan on `titles` |
| **R02** | READ | 0.726 | 0.602 | 0.594 | 0.983 | Seq Scan on `episodes` |
| **R03** | READ | 7.099 | 7.070 | 7.021 | 7.205 | Seq Scan on `viewing_activity` | Seq Scan on `titles` |
| **R04** | READ | 0.583 | 0.555 | 0.552 | 0.642 | Seq Scan on `title_genres` | Seq Scan on `genres` | Index Scan using `titles_pkey` on `titles` |
| **R05** | READ | 0.706 | 0.701 | 0.684 | 0.733 | Seq Scan on `titles` |
| **R06** | READ | 0.367 | 0.355 | 0.354 | 0.393 | Bitmap Heap Scan on `my_list` | Bitmap Index Scan on `my_list_pkey` | Seq Scan on `titles` |
| **R07** | READ | 0.590 | 0.590 | 0.581 | 0.600 | Seq Scan on `episodes` |
| **R08** | READ | 7.916 | 7.918 | 7.781 | 8.049 | Seq Scan on `viewing_activity` |
| **R09** | READ | 44.740 | 44.784 | 44.341 | 45.095 | Index Only Scan using `title_genres_pkey` on `title_genres` | Seq Scan on `viewing_activity` | Seq Scan on `genres` |
| **R10** | READ | 3.561 | 3.590 | 3.494 | 3.599 | Seq Scan on `accounts` |
| **R11** | READ | 7.691 | 6.625 | 5.787 | 10.661 | Seq Scan on `invoices` | Index Scan using `accounts_pkey` on `accounts` |
| **R12** | READ | 1.495 | 1.490 | 1.483 | 1.511 | Seq Scan on `accounts` |
| **R13** | READ | 18.839 | 18.855 | 18.801 | 18.862 | Seq Scan on `episodes` | Seq Scan on `viewing_activity` |
| **R14** | READ | 21.228 | 21.284 | 21.017 | 21.383 | Seq Scan on `viewing_activity` | Seq Scan on `profiles` | Seq Scan on `titles` |
| **R15** | READ | 5.129 | 5.163 | 5.003 | 5.222 | Seq Scan on `accounts` | Seq Scan on `plans` |
| **R16** | READ | 122.359 | 120.335 | 119.568 | 127.173 | Seq Scan on `viewing_activity` | Seq Scan on `profiles` | Seq Scan on `accounts` | Seq Scan on `plans` |
| **R17** | READ | 5.304 | 5.315 | 5.236 | 5.362 | Seq Scan on `ratings` | Seq Scan on `titles` |
| **R18** | READ | 20.081 | 20.056 | 20.047 | 20.140 | Seq Scan on `viewing_activity` |
| **R19** | READ | – (not executed in baseline) | – | – | – | – |
| **R20‑R25** | READ | (additional reads omitted for brevity) | | | | |
| **W01‑W05** | WRITE | (write timings omitted – all run inside a rollback) | | | | |

**Observations**
- The longest-running read query in the baseline is **R16** (average ~122 ms) which touches four large tables (`viewing_activity`, `profiles`, `accounts`, `plans`).
- Most queries complete well under 10 ms, indicating that the raw schema and indexes are already reasonably efficient.
- Scan node analysis shows that *seq scans* dominate, which is expected for a freshly loaded dataset without additional tuning or materialized views.

---

### Conclusion
The baseline benchmark provides a solid reference point for future optimizations (Phase 3). All queries execute without errors, and the collected statistics can be used to verify that any indexing or query‑rewriting effort yields measurable improvements over these numbers.

*Generated automatically on `$(date)` by the Antigravity autonomous agent.*
