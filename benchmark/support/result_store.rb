# frozen_string_literal: true

require 'fileutils'
require 'rbconfig'
require 'time'
require 'yaml'

module ResultStore
  class << self
    def store(benchmark_name, results)
      gem_version = Gem.loaded_specs['sai'].version.to_s
      results_dir = File.expand_path('../results', __dir__)
      FileUtils.mkdir_p(File.join(results_dir, 'reports'))
      FileUtils.mkdir_p(File.join(results_dir, 'data'))

      data = {
        'metadata' => {
          'timestamp' => Time.now.utc.iso8601,
          'gem_version' => gem_version,
          'ruby_version' => RUBY_VERSION,
          'ruby_platform' => RUBY_PLATFORM,
          'ruby_engine' => RUBY_ENGINE,
          'cpu_info' => cpu_info,
          'os_info' => os_info
        },
        'results' => results
      }

      # Store as YAML
      yaml_path = File.join(results_dir, 'data', "#{benchmark_name}_#{gem_version}.yml")
      File.write(yaml_path, YAML.dump(data))

      # Store as Markdown
      markdown_path = File.join(results_dir, 'reports', "#{benchmark_name}_#{gem_version}.md")
      File.write(markdown_path, generate_markdown(data))

      [yaml_path, markdown_path]
    end

    private

    def cpu_info
      case RbConfig::CONFIG['host_os']
      when /darwin/
        `sysctl -n machdep.cpu.brand_string`.strip
      when /linux/
        File.read('/proc/cpuinfo')
            .lines
            .grep(/^model name/)
            .first
          &.split(':')
          &.last
          &.strip
      else
        'Unknown CPU'
      end
    end

    def generate_markdown(data)
      meta = data['metadata']
      results = data['results']

      # Build the markdown content
      lines = []

      # Add metadata section
      lines << "# Benchmark Results - #{meta['gem_version']}"
      lines << ""
      lines << "## Environment"
      lines << ""
      lines << "* **Ruby Version:** #{meta['ruby_version']}"
      lines << "* **Ruby Platform:** #{meta['ruby_platform']}"
      lines << "* **Ruby Engine:** #{meta['ruby_engine']}"
      lines << "* **CPU:** #{meta['cpu_info']}"
      lines << "* **OS:** #{meta['os_info']}"
      lines << "* **Time:** #{meta['timestamp']}"
      lines << ""

      # Add results table
      lines << "## Results"
      lines << ""

      # Get all possible metrics from the first result
      metrics = results.values.first.keys

      # Create table header
      lines << "| Test Case | #{metrics.map(&:capitalize).join(' | ')} |"
      lines << "|#{'-' * 10}|#{metrics.map { |_| '-' * 10 }.join('|')}|"

      # Add result rows
      results.each do |test_case, measurements|
        values = metrics.map do |metric|
          value = measurements[metric]
          case value
          when Float
            format('%.2f', value)
          else
            value.to_s
          end
        end
        lines << "| #{test_case} | #{values.join(' | ')} |"
      end

      lines.join("\n")
    end

    def os_info
      case RbConfig::CONFIG['host_os']
      when /darwin/
        "macOS #{`sw_vers -productVersion`.strip}"
      when /linux/
        `lsb_release -d`.strip.split(':').last&.strip || 'Linux'
      else
        RbConfig::CONFIG['host_os']
      end
    end
  end
end
