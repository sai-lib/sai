# Benchmark Results - 0.4.0

## Environment

* **Ruby Version:** 3.1.6
* **Ruby Platform:** arm64-darwin24
* **Ruby Engine:** ruby
* **CPU:** Apple M2 Max
* **OS:** macOS 15.2
* **Time:** 2025-01-23T21:30:19Z

## Results

| Test Case | Ips | Stddev | Stddev_percentage | Microseconds_per_op | Iterations | Samples |
|----------|----------|----------|----------|----------|----------|----------|
| Raw ANSI | 11341634.11 | 99200 | 0.87 | 0.09 | 57657132 | 52 |
| named color | 101716.19 | 2701 | 2.66 | 9.83 | 509050 | 50 |
| named background color | 101969.01 | 1999 | 1.96 | 9.81 | 512700 | 50 |
| rbg color | 101482.22 | 2037 | 2.01 | 9.85 | 507297 | 49 |
| hex color | 97212.98 | 2531 | 2.60 | 10.29 | 488852 | 52 |
| multiple styles | 75571.14 | 660 | 0.87 | 13.23 | 385203 | 51 |
| long string | 404.84 | 7 | 1.73 | 2470.10 | 2028 | 52 |
| darken_text | 159980.45 | 1357 | 0.85 | 6.25 | 801788 | 52 |
| lighten_text | 160122.24 | 1136 | 0.71 | 6.25 | 812940 | 51 |
| gradient | 11386.00 | 85 | 0.75 | 87.83 | 56950 | 50 |
| rainbow | 12316.34 | 326 | 2.65 | 81.19 | 62300 | 50 |
| color stripping | 95556.54 | 2401 | 2.51 | 10.47 | 481776 | 48 |
| color sequence parsing | 161167.82 | 3671 | 2.28 | 6.20 | 815550 | 50 |
| color registration | 308066.84 | 14293 | 4.64 | 3.25 | 1548672 | 48 |