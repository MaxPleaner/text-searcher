module GeniusSearchTests

  module BenchmarkCache
    @@cache = {}
    def self.add(method_name, benchmark_result)
      @@cache[method_name] = benchmark_result
    end
    def self.cache
      @@cache
    end
  end

  # Define a custom error class which can be raised anywhere in the code
  class AssertionNotMetError < StandardError
  end

  def benchmark(test_case_name, num_repetitions)
    silence_output
    cached_result = BenchmarkCache.cache[test_case_name]
    if cached_result
      result = [cached_result[0] * num_repetitions]
    else
      result = Benchmark.bm do |x|
        x.report do 
          send(test_case_name)
        end
      end
      BenchmarkCache.add(test_case_name, result)
      result = [result[0] * num_repetitions]
    end
    enable_output
    print "#{test_case_name} benchmark results".white_on_black
    print "#{" (cached)" if cached_result}\n".white_on_black
    puts "  #{num_repetitions} repetitions".white_on_black
    puts result[0].to_s.white_on_black
  end

  # The base assertion method ("does x equal y?") used in tests
  def assert_equals(expected, actual, test_name="")
    if expected.eql?(actual)
        puts "    " + "#{test_name} passed".green_on_black
    else
      if options[:raise_error_on_failed_test]
        raise(AssertionNotMetError, "Expected #{expected} but was #{actual}")
      else
        puts "#{test_name} failed: ".black_on_white
        print "Expected #{expected} but was #{actual}".red_on_white
        puts "\n"
      end
    end
  end

  # ---- Note
  # The following methods were copied from http://stackoverflow.com/questions/15430551/suppress-console-output-during-rspec-tests
  # ---------

  # Redirects stderr and stout to /dev/null.txt
  def silence_output
    # Store the original stderr and stdout in order to restore them later
    @@original_stderr = $stderr
    @@original_stdout = $stdout

    # Redirect stderr and stdout
    `touch null.txt`
    $stderr = File.new(File.join(File.dirname(__FILE__), 'null.txt'), 'w')
    $stdout = File.new(File.join(File.dirname(__FILE__), 'null.txt'), 'w')
  end

  # Replace stderr and stdout so anything else is output correctly
  def enable_output
    $stderr = @@original_stderr
    $stdout = @@original_stdout
    @@original_stderr = nil
    @@original_stdout = nil
    `rm null.txt`
  end

end
