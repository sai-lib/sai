# Benchmark Results - 0.3.0

## Environment

* **Ruby Version:** 3.1.6
* **Ruby Platform:** arm64-darwin24
* **Ruby Engine:** ruby
* **CPU:** Apple M2 Max
* **OS:** macOS 15.2
* **Time:** 2025-01-23T21:17:56Z

## Results

| Test Case | Memory_allocated_bytes | Memory_retained_bytes | Objects_allocated | Objects_retained | Strings_allocated | Strings_retained |
|----------|----------|----------|----------|----------|----------|----------|
| Raw ANSI | 232 | 0 | 2 | 0 | 1 | 0 |
| named color | 5080 | 0 | 78 | 0 | 22 | 0 |
| named background color | 4488 | 128 | 75 | 2 | 22 | 1 |
| rbg color | 4608 | 128 | 74 | 2 | 20 | 1 |
| hex color | 4776 | 128 | 79 | 2 | 23 | 1 |
| multiple styles | 6280 | 128 | 108 | 2 | 30 | 1 |
| long string | 561513 | 13097 | 13062 | 2 | 22 | 1 |
| color stripping | 4688 | 408 | 79 | 8 | 22 | 2 |
| color sequence parsing | 3048 | 0 | 45 | 0 | 16 | 0 |