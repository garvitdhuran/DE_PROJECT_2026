# Baseline Benchmark Timings (CP2)

## 1. Overview

This report documents baseline performance for the Netflix Streaming Database.
The benchmark covers 30 workload queries: 25 reads (R01–R25) and 5 writes (W01–W05).

## 2. Benchmark environment

The following environment details were recorded in the original benchmark report.
They are reported by the benchmark operator and have not been independently verified:

- Operating system: macOS 27.2.0 (Darwin Kernel 27.2.0)
- CPU: Apple M4 (ARM64)
- PostgreSQL: 17.11 (Homebrew), compiled with clang 21.0.0
- Database: `netflix_cp2`
- Port: 5433
- Schema: `netflix`

Confirm these details against the actual machine used for the benchmark before final submission.

## 3. Benchmark methodology

- Script: `benchmarks/run_benchmark.sh`
- Workload: `queries/workload_30.sql`
- Runs per query: 3
- Analysis: `EXPLAIN (ANALYZE, BUFFERS)`
- Metrics: average, median, minimum and maximum execution time, in milliseconds
- Scan nodes: extracted from the final execution plan for each query
- Raw plans: `benchmarks/results/baseline/<ID>.txt`
- Summary: `benchmarks/results/baseline/summary.csv`
- Write queries are executed inside transactions and rolled back to avoid retaining benchmark changes.

## 4. Complete baseline results

| Query | Type | Average (ms) | Median (ms) | Min (ms) | Max (ms) | Scan nodes |
|---|---|---:|---:|---:|---:|---|
| R01 | READ | 10.705 | 9.964 | 9.894 | 12.257 | Seq Scan on viewing_activity<br>Seq Scan on titles |
| R02 | READ | 0.726 | 0.602 | 0.594 | 0.983 | Seq Scan on episodes |
| R03 | READ | 7.099 | 7.070 | 7.021 | 7.205 | Seq Scan on viewing_activity<br>Seq Scan on titles |
| R04 | READ | 0.583 | 0.555 | 0.552 | 0.642 | Seq Scan on title_genres<br>Seq Scan on genres<br>Index Scan using titles_pkey on titles |
| R05 | READ | 0.706 | 0.701 | 0.684 | 0.733 | Seq Scan on titles |
| R06 | READ | 0.367 | 0.355 | 0.354 | 0.393 | Bitmap Heap Scan on my_list<br>Bitmap Index Scan on my_list_pkey<br>Seq Scan on titles |
| R07 | READ | 0.590 | 0.590 | 0.581 | 0.600 | Seq Scan on episodes |
| R08 | READ | 7.916 | 7.918 | 7.781 | 8.049 | Seq Scan on viewing_activity |
| R09 | READ | 44.740 | 44.784 | 44.341 | 45.095 | Index Only Scan using title_genres_pkey on title_genres<br>Seq Scan on viewing_activity<br>Seq Scan on genres |
| R10 | READ | 3.561 | 3.590 | 3.494 | 3.599 | Seq Scan on accounts |
| R11 | READ | 7.691 | 6.625 | 5.787 | 10.661 | Seq Scan on invoices<br>Index Scan using accounts_pkey on accounts |
| R12 | READ | 1.495 | 1.490 | 1.483 | 1.511 | Seq Scan on accounts |
| R13 | READ | 18.839 | 18.855 | 18.801 | 18.862 | Seq Scan on episodes<br>Seq Scan on viewing_activity |
| R14 | READ | 21.228 | 21.284 | 21.017 | 21.383 | Seq Scan on viewing_activity<br>Seq Scan on profiles<br>Seq Scan on titles |
| R15 | READ | 5.129 | 5.163 | 5.003 | 5.222 | Seq Scan on accounts<br>Seq Scan on plans |
| R16 | READ | 122.359 | 120.335 | 119.568 | 127.173 | Seq Scan on viewing_activity<br>Seq Scan on profiles<br>Seq Scan on accounts<br>Seq Scan on plans |
| R17 | READ | 5.304 | 5.315 | 5.236 | 5.362 | Seq Scan on ratings<br>Seq Scan on titles |
| R18 | READ | 20.081 | 20.056 | 20.047 | 20.140 | Seq Scan on viewing_activity |
| R19 | READ | 6570.103 | 6583.595 | 6452.250 | 6674.463 | Seq Scan on titles<br>Seq Scan on viewing_activity |
| R20 | READ | 2.979 | 2.982 | 2.816 | 3.140 | Seq Scan on my_list<br>Seq Scan on titles |
| R21 | READ | 1.282 | 1.285 | 1.275 | 1.285 | Seq Scan on accounts |
| R22 | READ | 0.180 | 0.177 | 0.177 | 0.187 | Seq Scan on titles |
| R23 | READ | 37.464 | 37.505 | 37.230 | 37.658 | Seq Scan on viewing_activity |
| R24 | READ | 1.927 | 1.935 | 1.891 | 1.954 | Seq Scan on profiles |
| R25 | READ | 0.626 | 0.614 | 0.605 | 0.658 | Seq Scan on title_genres<br>Bitmap Heap Scan on title_genres<br>Bitmap Index Scan on title_genres_pkey |
| W01 | WRITE | 0.862 | 0.861 | 0.855 | 0.870 | Seq Scan on episodes |
| W02 | WRITE | 0.353 | 0.356 | 0.343 | 0.359 | (no scan) |
| W03 | WRITE | 0.170 | 0.172 | 0.162 | 0.176 | Seq Scan on plans<br>Index Scan using accounts_pkey on accounts |
| W04 | WRITE | 57.708 | 55.475 | 54.142 | 63.507 | Seq Scan on accounts<br>Seq Scan on plans |
| W05 | WRITE | 6.968 | 6.896 | 6.886 | 7.123 | Seq Scan on invoices<br>Index Scan using accounts_pkey on accounts |

## 5. Observations

- Slowest read: **R19**, averaging **6570.103 ms**.
- Fastest read: **R22**, averaging **0.180 ms**.
- Slowest write: **W04**, averaging **57.708 ms**.
- R19 is notably expensive because its correlated subqueries repeatedly scan `viewing_activity` for each Netflix Original title.
- Sequential scans appear frequently in the baseline plans. These plans provide evidence for investigating indexing and query rewrites in the optimization phase.

## 6. Conclusion

The baseline results provide a reference point for evaluating Phase 3 optimizations.
Performance improvements should be assessed against these timings using the same workload and comparable execution conditions.

*Report generated from `summary.csv` on 2026-11-23 21:16:41.*
