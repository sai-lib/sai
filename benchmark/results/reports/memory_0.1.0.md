# Benchmark Results - 0.1.0

## Environment

* **Ruby Version:** 3.1.6
* **Ruby Platform:** arm64-darwin24
* **Ruby Engine:** ruby
* **CPU:** Apple M2 Max
* **OS:** macOS 15.2
* **Time:** 2025-01-23T21:10:08Z

## Results

| Test Case | Memory_allocated_bytes | Memory_retained_bytes | Objects_allocated | Objects_retained | Strings_allocated | Strings_retained |
|----------|----------|----------|----------|----------|----------|----------|
| Raw ANSI | 232 | 0 | 2 | 0 | 1 | 0 |
| named color | 1784 | 88 | 31 | 1 | 8 | 1 |
| named background color | 1120 | 128 | 26 | 2 | 7 | 1 |
| rbg color | 1160 | 128 | 23 | 2 | 5 | 1 |
| hex color | 1328 | 128 | 28 | 2 | 8 | 1 |
| multiple styles | 1600 | 128 | 38 | 2 | 12 | 1 |
| long string | 14089 | 13097 | 26 | 2 | 7 | 1 |