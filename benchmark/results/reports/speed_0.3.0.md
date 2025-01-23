# Benchmark Results - 0.3.0

## Environment

* **Ruby Version:** 3.1.6
* **Ruby Platform:** arm64-darwin24
* **Ruby Engine:** ruby
* **CPU:** Apple M2 Max
* **OS:** macOS 15.2
* **Time:** 2025-01-23T21:19:00Z

## Results

| Test Case | Ips | Stddev | Stddev_percentage | Microseconds_per_op | Iterations | Samples |
|----------|----------|----------|----------|----------|----------|----------|
| Raw ANSI | 11369186.60 | 210972 | 1.86 | 0.09 | 57408711 | 51 |
| named color | 103095.71 | 2327 | 2.26 | 9.70 | 523224 | 52 |
| named background color | 96129.20 | 7015 | 7.30 | 10.40 | 487550 | 49 |
| rbg color | 98412.23 | 3931 | 3.99 | 10.16 | 492900 | 50 |
| hex color | 94634.59 | 4915 | 5.19 | 10.57 | 479073 | 49 |
| multiple styles | 73070.79 | 3669 | 5.02 | 13.69 | 365952 | 48 |
| long string | 383.39 | 8 | 2.09 | 2608.32 | 1920 | 48 |
| color stripping | 96426.18 | 2247 | 2.33 | 10.37 | 482832 | 48 |
| color sequence parsing | 167040.36 | 3225 | 1.93 | 5.99 | 839958 | 49 |