require 'yaml'
require 'byebug'
require 'colored'
require 'benchmark'

require_relative("./test_helpers.rb")
require_relative("./tests.rb")

# Allow the module to have options set
module GeniusSearchTests
  @@options = {}
  def options
    @@options
  end
  def set_option(key, val)
    @@options[key] = val
  end
end

module TestRunner
  # GeniusSearchTests is defined thoughout the codebase
  extend GeniusSearchTests

  def self.set_options(command_line_args)
    set_option(
      :raise_error_on_failed_test, true
    ) if command_line_args.include?("--raise-error-on-failure")
    set_option(
      :shuffle_tests, true
    ) if command_line_args.include?("--shuffle-tests")
  end

  def self.run_tests
    puts "* * Genius Search Tests * *".white_on_black
    puts "\n"
    tests_list = [
      :test_finding_lana_del_rey_by_name,
      :test_finding_all_artists_by_name,
      :test_finding_all_artists_by_name_with_fuzzy_search,
      :test_searching_for_all_artists_with_regex,
      :test_searching_for_single_letter,
      :test_searching_for_single_letter_with_fuzzy_search,
      :test_searching_for_single_letter_with_regex,
      :test_using_regex_to_search_for_apostrophe_character,
      :test_using_regex_to_search_for_exclamation_point_character,
      :test_using_regexes_to_search_for_e_with_diacritic,
      :test_using_regex_to_search_for_comma,
      :test_using_regex_to_search_for_period,
      :test_searching_for_single_letter_with_large_list,
      :test_searching_for_single_letter_with_large_list_using_fuzzy_search,
      :test_searching_for_single_letter_with_large_list_using_regex,
      :benchmark_performance_of_searching_for_single_letter,
      :benchmark_searching_for_single_letter_with_large_list
    ]
    if options[:shuffle_tests]
      tests_list = tests_list.shuffle
    end
    tests_list.each { |test_name| run_test(test_name) }
  end

  def self.run_test(test_name)
    puts test_name.to_s.blue_on_black
    silence_output
    benchmark_result = Benchmark.bm do |x|
      x.report { enable_output; send(test_name); silence_output; }
    end
    enable_output
    GeniusSearchTests::BenchmarkCache.add(test_name, benchmark_result)
  end

end

# Execute this block if this file is run directly. 
# I.e. ruby <this_file.rb>
# This block will not run if this file is required
# or loaded. 
if __FILE__ == $0
  TestRunner.set_options(ARGV)
  TestRunner.run_tests
end
