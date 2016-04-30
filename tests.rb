require_relative("./search.rb")

module GeniusSearchTests
  include GeniusSearch

  def test_finding_lana_del_rey_by_name
    assert_equals(["Lana Del Rey"], search("Lana Del Rey"), test_name="Lana Del Rey search")
  end

  def test_finding_all_artists_by_name
    YAML.load(File.read "./artists.yml").each do |artist|
      assert_equals([artist], search(artist), test_name="#{artist} name search")
    end
  end

  # Uses the fuzzy_search method in search.rb
  # which uses the fuzzy_match gem.
  def test_finding_all_artists_by_name_with_fuzzy_search
    YAML.load(File.read "./artists.yml").each do |artist|
      assert_equals(artist, fuzzy_search(artist).first, test_name="#{artist} name fuzzy search")
    end
  end

  def test_searching_for_all_artists_with_regex
    YAML.load(File.read "./artists.yml").each do |artist|
      assert_equals([artist], regex_search(artist), test_name="#{artist} name regex search")
    end
  end

  def test_searching_for_single_letter
    assert_equals(
      ["Rihanna", "Drake", "The Game", "Lana Del Rey", "Kanye West", "Fetty Wap", "Kendrick Lamar", "Panic! At The Disco", "Cam'ron", "Tyler, The Creator"],
      search('a'),
     "Searching for letter A"
    )
  end

  def test_searching_for_single_letter_with_fuzzy_search
    assert_equals(
      ["AAA", "Adele", "Drake", "Cam'ron", "Rihanna", "The Game", "Fetty Wap", "Kanye West", "Lana Del Rey", "Kendrick Lamar", "Tyler, The Creator", "Panic! At The Disco"],
      fuzzy_search('a'),
      "Seachin for letter A with fuzzy search"
    )
  end

  def test_searching_for_single_letter_with_regex
    assert_equals(
      ["Rihanna", "Drake", "The Game", "Lana Del Rey", "Kanye West", "Fetty Wap", "Kendrick Lamar", "Panic! At The Disco", "Cam'ron", "Tyler, The Creator"],
      regex_search("a"),
      "Searching for letter A with regex"
    )
  end

  def test_using_regex_to_search_for_apostrophe_character
    assert_equals(["Cam'ron"], regex_search("'"), "Apostrophe regex search")
  end

  def test_using_regex_to_search_for_exclamation_point_character
    assert_equals(["Panic! At The Disco"], regex_search("!"), "Exclamation point regex search")
  end

  def test_using_regexes_to_search_for_e_with_diacritic
    assert_equals(["Beyoncé"], regex_search("é"), "Diacritic regex search")
  end

  def test_using_regex_to_search_for_comma
    assert_equals(["Tyler, The Creator"], regex_search(","), "Comma regex search")
  end

  def test_using_regex_to_search_for_period
    assert_equals(["The Notorious B.I.G."], regex_search("."), "Period regex search")
  end

  def test_searching_for_single_letter_with_large_list
    set_option(:large_companies_list, true)
    set_option(:large)
  end

  def test_searching_for_single_letter_with_large_list_using_fuzzy_search
    puts "unimplemented".yellow
  end

  def test_searching_for_single_letter_with_large_list_using_regex
    puts "unimplemented".yellow
  end

  def benchmark_performance_of_searching_for_single_letter
    benchmark(
      :test_searching_for_single_letter, 500
    )
    benchmark(
      :test_searching_for_single_letter_with_fuzzy_search, 500
    )
  end

  def benchmark_searching_for_single_letter_with_large_list
    puts "unimplemented".yellow
  end

end