require 'yaml'
require 'byebug'
require 'colored'
require 'benchmark'

require_relative("./test_helpers.rb")
require_relative("./tests.rb")

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
  extend GeniusSearchTests
  def self.run_tests
    puts "* * Genius Search Tests * *".white_on_black
    puts "\n"
    set_option(
      :raise_error_on_failed_test, true
    ) if ARGV.include?("--raise-error-on-failure")
    [
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
    ].each { |test_name| pretty_test_run(test_name) }
  end
  def self.pretty_test_run(test_name)
    puts test_name.to_s.blue
    send(test_name)
  end
end

if __FILE__ == $0
  TestRunner.run_tests
end
