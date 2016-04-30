require 'fuzzy_match' # https://github.com/seamusabshere/fuzzy_match
require 'yaml'

module GeniusSearch

  def self.use_artists_list(file)
    @@cached_artists = YAML.load(
      File.read(file)
    )
    @@cached_fuzzy_matcher = FuzzyMatch.new(
      @@cached_artists, { must_match_groupings: true }
    )
    nil # don't show output!
  end

  # this method is automatically called 
  # when this module is included
  def self.included(module_which_includes)
    use_artists_list("./artists.yml")
  end

  def use_large_artists_list
    GeniusSearch.use_artists_list("./large_artists_list.yml")
  end

  def use_small_artists_list
    GeniusSearch.use_artists_list("./artists.yml")
  end

  def cached_artists
    @@cached_artists
  end

  # dont reinitialize this, it takes time
  def cached_fuzzy_matcher
    @@cached_fuzzy_matcher
  end

  def search(query)
    cached_artists.select do |artist|
      artist.downcase.include?(query.downcase)
    end
  end

  def regex_search(query)
    # One way to write a regex:
      # regex_str = query.gsub(" ", '\s')
      #                  .gsub(".", '\.')
      #                  .gsub(",", '\,')
      #                  .gsub("!", '/!')
      # regex = /#{regex_str}/i
    # A nicer way:
    regex = Regexp.new(
      Regexp.escape(query), Regexp::IGNORECASE
    )
    cached_artists.select do |company|
      company =~ regex
    end
  end

  def fuzzy_search(query)
    cached_fuzzy_matcher.find_all_with_score(
      query
    ).map(&:first)
  end

end