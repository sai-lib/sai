# Contributing to Sai

First off, thank you for considering contributing to Sai! It's people like you who make Sai such a great tool.

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

When filing a bug report, please include:

1. **Ruby Version**: The version of Ruby you're using
2. **Sai Version**: The version of Sai where you encountered the issue
3. **Terminal Environment**: Your terminal emulator and operating system
4. **Description**: A clear description of what happened versus what you expected
5. **Reproduction Steps**: Detailed steps to reproduce the issue
6. **Code Sample**: A minimal code example that demonstrates the issue
7. **Terminal Output**: Any relevant error messages or unexpected output
8. **Screenshots**: If applicable, screenshots showing the issue (especially for color-related bugs)

### Suggesting Enhancements

Enhancement suggestions are welcome! When suggesting an enhancement, please:

* **Check Existing Issues**: Make sure a similar suggestion hasn't already been made
* **Provide Context**: Explain why this enhancement would be useful
* **Consider Scope**: Describe if this is a general enhancement or specific to certain use cases
* **Include Examples**: If possible, provide example code or mockups

### Pull Requests

#### Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/sai.git`
3. Create a branch: `git checkout -b my-feature-branch`

#### Development Process

1. Run `bin/setup` to install dependencies
2. Make your changes
3. Add tests for your changes
4. Run the CI checks locally:
   ```bash
   bin/ci
   ```

#### Code Style

We follow a specific code style as defined in our RuboCop configuration:

* Methods should be organized by class/instance and visibility
* Documentation should follow YARD format with required tags
* Tests should follow our RSpec guidelines (see Testing section)

#### Testing Requirements

Please make sure your changes include appropriate tests:

* New features should include unit tests
* Bug fixes should include regression tests
* Tests should be clear and maintainable

#### Documentation

Documentation is crucial! Please:

* Add YARD documentation for new methods/classes
* Update the README.md if necessary
* Add examples showing how to use new features
* Update the USAGE.md guide for significant changes

#### Pull Request Process

1. Ensure all CI checks pass
2. Get review from maintainers
3. Respond to feedback and make requested changes
4. Once approved, maintainers will merge your PR

## Development Environment

### Setting Up

1. Install Ruby (see .ruby-version for current version)
2. Clone the repository
3. Run `bin/setup`
4. Run the CI script to verify setup

### Running Tests

* Full CI check: Use the CI script above
* Just RSpec: `bundle exec rspec`
* Specific tests: `bundle exec rspec spec/path/to/file_spec.rb`
* RuboCop: `bundle exec rubocop` or `bundle exec rubocop -A` for auto-correct
* Type checking: `bundle exec steep check`

## Getting Help

If you need help, you can:

* Open a [GitHub Discussion](https://github.com/aaronmallen/sai/discussions) for general questions
* Check the [documentation](https://rubydoc.info/gems/sai) for guides and API reference
* Join our community (link to be added)

Thank you again for contributing to Sai!
