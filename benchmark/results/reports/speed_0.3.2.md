# Benchmark Results - 0.3.2

## Environment

* **Ruby Version:** 3.1.6
* **Ruby Platform:** arm64-darwin24
* **Ruby Engine:** ruby
* **CPU:** Apple M2 Max
* **OS:** macOS 15.2
* **Time:** 2025-01-23T21:28:17Z

## Results

| Test Case | Ips | Stddev | Stddev_percentage | Microseconds_per_op | Iterations | Samples |
|----------|----------|----------|----------|----------|----------|----------|
| Raw ANSI | 11405361.44 | 78167 | 0.69 | 0.09 | 57308108 | 52 |
| named color | 96537.61 | 2858 | 2.96 | 10.36 | 487795 | 49 |
| named background color | 97759.11 | 1246 | 1.27 | 10.23 | 490147 | 49 |
| rbg color | 99596.28 | 1714 | 1.72 | 10.04 | 507550 | 50 |
| hex color | 97076.22 | 1340 | 1.38 | 10.30 | 485737 | 49 |
| multiple styles | 71885.23 | 1403 | 1.95 | 13.91 | 364700 | 50 |
| long string | 406.57 | 5 | 1.23 | 2459.57 | 2050 | 50 |
| darken_text | 155684.05 | 2478 | 1.59 | 6.42 | 783853 | 49 |
| lighten_text | 154496.93 | 7484 | 4.84 | 6.47 | 781354 | 49 |
| gradient | 10992.67 | 222 | 2.02 | 90.97 | 55370 | 49 |
| rainbow | 12574.09 | 99 | 0.79 | 79.53 | 63600 | 50 |
| color stripping | 95422.97 | 883 | 0.93 | 10.48 | 483950 | 50 |
| color sequence parsing | 162734.70 | 4952 | 3.04 | 6.14 | 827169 | 49 |
| color registration | 1679.93 | 72 | 4.29 | 595.26 | 8507 | 47 |