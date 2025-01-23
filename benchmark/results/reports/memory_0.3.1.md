# Benchmark Results - 0.3.1

## Environment

* **Ruby Version:** 3.1.6
* **Ruby Platform:** arm64-darwin24
* **Ruby Engine:** ruby
* **CPU:** Apple M2 Max
* **OS:** macOS 15.2
* **Time:** 2025-01-23T21:22:02Z

## Results

| Test Case | Memory_allocated_bytes | Memory_retained_bytes | Objects_allocated | Objects_retained | Strings_allocated | Strings_retained |
|----------|----------|----------|----------|----------|----------|----------|
| Raw ANSI | 232 | 0 | 2 | 0 | 1 | 0 |
| named color | 5592 | 0 | 82 | 0 | 22 | 0 |
| named background color | 4616 | 128 | 77 | 2 | 22 | 1 |
| rbg color | 4736 | 128 | 76 | 2 | 20 | 1 |
| hex color | 4904 | 128 | 81 | 2 | 23 | 1 |
| multiple styles | 6440 | 128 | 110 | 2 | 30 | 1 |
| long string | 561641 | 13097 | 13064 | 2 | 22 | 1 |
| darken_text | 3320 | 0 | 49 | 0 | 14 | 0 |
| lighten_text | 3320 | 0 | 49 | 0 | 14 | 0 |
| gradient | 44612 | 0 | 721 | 0 | 50 | 0 |
| rainbow | 41974 | 1616 | 659 | 28 | 50 | 0 |
| color stripping | 4816 | 408 | 81 | 8 | 22 | 2 |
| color sequence parsing | 3144 | 0 | 47 | 0 | 16 | 0 |