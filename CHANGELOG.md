# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog], and this project adheres to [Break Versioning].

## [Unreleased]

### Added

* [#15](https://github.com/aaronmallen/sai/pull/15) - Add support for registering custom named colors by
  [@aaronmallen](https://github.com/aaronmallen)

## [0.3.1] - 2025-01-22

### Added 

* [#8](https://github.com/aaronmallen/sai/pull/8) - Add color manipulation methods for darkening and lightening colors 
  by [@aaronmallen](https://github.com/aaronmallen)
* [#9](https://github.com/aaronmallen/sai/pull/9) - Add gradient and rainbow color effects for text and backgrounds by
  [@aaronmallen](https://github.com/aaronmallen)
* [#13](https://github.com/aaronmallen/sai/pull/13) - Add support for over 360 named colors expanding the color palette
  by [@aaronmallen](https://github.com/aaronmallen)

### Changed

* [#10](https://github.com/aaronmallen/sai/pull/10) - Refactor `Sai::Decorator` into component modules by
  [@aaronmallen](https://github.com/aaronmallen)
* [#11](https://github.com/aaronmallen/sai/pull/11) - Refactor `Sai::Conversion::RGB` into component modules by
  [@aaronmallen](https://github.com/aaronmallen)
* [#12](https://github.com/aaronmallen/sai/pull/12) - Refactor ANSI sequence processing into specialized parser classes
  by [@aaronmallen](https://github.com/aaronmallen)

## [0.3.0] - 2025-01-20

### Added

* [#6](https://github.com/aaronmallen/sai/pull/6) - Add `Sai::ANSI::SequencedString` for ANSI string manipulation by
  [@aaronmallen](https://github.com/aaronmallen)

### Changed

* [#5](https://github.com/aaronmallen/sai/pull/5) - Remove unnecessary error handling in `Sai::Decorator` by
  [@aaronmallen](https://github.com/aaronmallen)

* [#6](https://github.com/aaronmallen/sai/pull/6) - Changed `Sai::Decorator#decorate` now returns a
  `Sai::ANSI::SequencedString` by [@aaronmallen](https://github.com/aaronmallen)

## [0.2.0] - 2025-01-20

### Added

* [#3](https://github.com/aaronmallen/sai/pull/3) - mode selection via `Sai::ModeSelector`by
  [@aaronmallen](https://github.com/aaronmallen)

### Changed

* [#2](https://github.com/aaronmallen/sai/pull/2) - Immutable method chaining for `Sai::Decorator` by
  [@aaronmallen](https://github.com/aaronmallen)
* [#3](https://github.com/aaronmallen/sai/pull/3) - `Sia::Support` from class to module for improved API design by
  [@aaronmallen](https://github.com/aaronmallen)

## 0.1.0 - 2025-01-19

* Initial release

[Keep a Changelog]: https://keepachangelog.com/en/1.0.0/
[Break Versioning]: https://www.taoensso.com/break-versioning

<!-- versions -->

[Unreleased]: https://github.com/aaronmallen/sai/compare/0.3.1..HEAD
[0.3.1]: https://github.com/aaronmallen/sai/compare/0.3.0..0.3.1
[0.3.0]: https://github.com/aaronmallen/sai/compare/0.2.0..0.3.0
[0.2.0]: https://github.com/aaronmallen/sai/compare/0.1.0..0.2.0
