# Benchmark Results - 0.2.0

## Environment

* **Ruby Version:** 3.1.6
* **Ruby Platform:** arm64-darwin24
* **Ruby Engine:** ruby
* **CPU:** Apple M2 Max
* **OS:** macOS 15.2
* **Time:** 2025-01-23T21:14:51Z

## Results

| Test Case | Memory_allocated_bytes | Memory_retained_bytes | Objects_allocated | Objects_retained | Strings_allocated | Strings_retained |
|----------|----------|----------|----------|----------|----------|----------|
| Raw ANSI | 232 | 0 | 2 | 0 | 1 | 0 |
| named color | 2024 | 88 | 33 | 1 | 8 | 1 |
| named background color | 1440 | 128 | 30 | 2 | 8 | 1 |
| rbg color | 1480 | 128 | 27 | 2 | 6 | 1 |
| hex color | 1648 | 128 | 32 | 2 | 9 | 1 |
| multiple styles | 2064 | 128 | 44 | 2 | 13 | 1 |
| long string | 14409 | 13097 | 30 | 2 | 8 | 1 |