# Benchmark Results - 0.1.0

## Environment

* **Ruby Version:** 3.1.6
* **Ruby Platform:** arm64-darwin24
* **Ruby Engine:** ruby
* **CPU:** Apple M2 Max
* **OS:** macOS 15.2
* **Time:** 2025-01-23T21:10:57Z

## Results

| Test Case | Ips | Stddev | Stddev_percentage | Microseconds_per_op | Iterations | Samples |
|----------|----------|----------|----------|----------|----------|----------|
| Raw ANSI | 11552908.92 | 74881 | 0.65 | 0.09 | 58198089 | 51 |
| named color | 477604.91 | 18833 | 3.94 | 2.09 | 2406950 | 50 |
| named background color | 467029.58 | 14741 | 3.16 | 2.14 | 2335392 | 48 |
| rbg color | 481026.07 | 15798 | 3.28 | 2.08 | 2426454 | 46 |
| hex color | 452124.61 | 10349 | 2.29 | 2.21 | 2268384 | 48 |
| multiple styles | 317448.46 | 8132 | 2.56 | 3.15 | 1601369 | 49 |
| long string | 415597.98 | 4021 | 0.97 | 2.41 | 2085450 | 50 |