# Benchmark Results - 0.2.0

## Environment

* **Ruby Version:** 3.1.6
* **Ruby Platform:** arm64-darwin24
* **Ruby Engine:** ruby
* **CPU:** Apple M2 Max
* **OS:** macOS 15.2
* **Time:** 2025-01-23T21:15:41Z

## Results

| Test Case | Ips | Stddev | Stddev_percentage | Microseconds_per_op | Iterations | Samples |
|----------|----------|----------|----------|----------|----------|----------|
| Raw ANSI | 11304049.18 | 207131 | 1.83 | 0.09 | 56895488 | 52 |
| named color | 314425.47 | 3700 | 1.18 | 3.18 | 1590159 | 53 |
| named background color | 299387.57 | 10070 | 3.36 | 3.34 | 1519188 | 51 |
| rbg color | 313062.09 | 9689 | 3.09 | 3.19 | 1592892 | 49 |
| hex color | 290250.46 | 7705 | 2.65 | 3.45 | 1462320 | 48 |
| multiple styles | 225116.85 | 6697 | 2.97 | 4.44 | 1136127 | 51 |
| long string | 262190.81 | 13769 | 5.25 | 3.81 | 1321203 | 57 |