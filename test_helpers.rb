
module GeniusSearchTests
  # Define a custom error class which can be raised anywhere in the code
  class AssertionNotMetError < StandardError
  end

  def benchmark(test_case_name, num_repetitions)
    silence_output
    result = Benchmark.bm do |x|
      x.report do 
        num_repetitions.times.each { send(test_case_name) }
      end
    end
    enable_output
    puts "#{test_case_name} benchmark results: ".white_on_black
    puts result
  end

  # The base assertion method ("does x equal y?") used in tests
  def assert_equals(expected, actual, test_name="")
    if expected.eql?(actual)
        puts "#{test_name} passed".green
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
