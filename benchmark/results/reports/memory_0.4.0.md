# Benchmark Results - 0.4.0

## Environment

* **Ruby Version:** 3.1.6
* **Ruby Platform:** arm64-darwin24
* **Ruby Engine:** ruby
* **CPU:** Apple M2 Max
* **OS:** macOS 15.2
* **Time:** 2025-01-23T21:28:41Z

## Results

| Test Case | Memory_allocated_bytes | Memory_retained_bytes | Objects_allocated | Objects_retained | Strings_allocated | Strings_retained |
|----------|----------|----------|----------|----------|----------|----------|
| Raw ANSI | 232 | 0 | 2 | 0 | 1 | 0 |
| named color | 4568 | 0 | 71 | 0 | 22 | 0 |
| named background color | 4168 | 128 | 69 | 2 | 22 | 1 |
| rbg color | 4568 | 128 | 75 | 2 | 20 | 1 |
| hex color | 4736 | 128 | 80 | 2 | 23 | 1 |
| multiple styles | 5992 | 128 | 102 | 2 | 30 | 1 |
| long string | 561193 | 13097 | 13056 | 2 | 22 | 1 |
| darken_text | 3152 | 0 | 48 | 0 | 14 | 0 |
| lighten_text | 3152 | 0 | 48 | 0 | 14 | 0 |
| gradient | 44444 | 0 | 720 | 0 | 50 | 0 |
| rainbow | 41806 | 1616 | 658 | 28 | 50 | 0 |
| color stripping | 4368 | 408 | 73 | 8 | 22 | 2 |
| color sequence parsing | 3144 | 0 | 47 | 0 | 16 | 0 |
| color registration | 1048 | 400 | 15 | 6 | 2 | 1 |