# Benchmark Results - 0.3.1

## Environment

* **Ruby Version:** 3.1.6
* **Ruby Platform:** arm64-darwin24
* **Ruby Engine:** ruby
* **CPU:** Apple M2 Max
* **OS:** macOS 15.2
* **Time:** 2025-01-23T21:23:34Z

## Results

| Test Case | Ips | Stddev | Stddev_percentage | Microseconds_per_op | Iterations | Samples |
|----------|----------|----------|----------|----------|----------|----------|
| Raw ANSI | 11008377.90 | 193709 | 1.76 | 0.09 | 55703000 | 50 |
| named color | 98904.63 | 1814 | 1.83 | 10.11 | 500688 | 54 |
| named background color | 99435.56 | 739 | 0.74 | 10.06 | 503288 | 53 |
| rbg color | 100326.96 | 2413 | 2.41 | 9.97 | 507756 | 51 |
| hex color | 93457.98 | 2096 | 2.24 | 10.70 | 468200 | 50 |
| multiple styles | 73558.45 | 806 | 1.10 | 13.59 | 368883 | 51 |
| long string | 395.41 | 16 | 4.05 | 2529.01 | 2000 | 50 |
| darken_text | 151528.04 | 20084 | 13.25 | 6.60 | 725788 | 46 |
| lighten_text | 152710.19 | 3217 | 2.11 | 6.55 | 765900 | 50 |
| gradient | 10873.86 | 342 | 3.15 | 91.96 | 54900 | 50 |
| rainbow | 12334.12 | 338 | 2.74 | 81.08 | 62400 | 50 |
| color stripping | 95743.32 | 877 | 0.92 | 10.44 | 484844 | 53 |
| color sequence parsing | 167498.97 | 984 | 0.59 | 5.97 | 840944 | 52 |