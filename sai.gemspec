# frozen_string_literal: true

SAI_GEM_VERSION = '0.3.0'
SAI_SEMVER = '0.3.0'
SAI_REPO_URL = 'https://github.com/aaronmallen/sai'
SAI_HOME_URL = SAI_REPO_URL

Gem::Specification.new do |spec|
  spec.name        = 'sai'
  spec.version     = SAI_GEM_VERSION
  spec.homepage    = SAI_HOME_URL
  spec.authors     = ['Aaron Allen']
  spec.email       = ['hello@aaronmallen.me']
  spec.summary     = 'An elegant color management system for crafting sophisticated CLI applications'
  spec.description = "Sai (彩) - meaning 'coloring' or 'paint' in Japanese - is a powerful and intuitive system " \
                     'for managing color output in command-line applications. Drawing inspiration from ' \
                     'traditional Japanese artistic techniques, Sai brings vibrancy and harmony to terminal ' \
                     "interfaces through its sophisticated color management.\n" \
                     'Sai empowers developers to create beautiful, colorful CLI applications that maintain visual ' \
                     'consistency across different terminal capabilities. Like its artistic namesake, it ' \
                     'combines simplicity and sophistication to bring rich, adaptive color to your terminal interfaces.'

  spec.license     = 'MIT'

  spec.required_ruby_version = '>= 3.1'

  spec.files = Dir.chdir(__dir__) do
    Dir['{lib,sig}/**/*', 'docs/USAGE.md', '.yardopts', 'CHANGELOG.md', 'LICENSE', 'README.md']
      .reject { |f| File.directory?(f) }
  end

  spec.require_paths = ['lib']

  spec.metadata = {
    'bug_tracker_uri' => "#{SAI_REPO_URL}/issues",
    'changelog_uri' => "#{SAI_REPO_URL}/releases/tag/#{SAI_SEMVER}",
    'homepage_uri' => spec.homepage,
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => "#{SAI_REPO_URL}/tree/#{SAI_SEMVER}"
  }
end
