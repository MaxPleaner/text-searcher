require 'fuzzy_match' # https://github.com/seamusabshere/fuzzy_match
require 'yaml'

module GeniusSearch
  def self.included(module_which_includes)
    @@cached_artists = YAML.load(
      File.read("./artists.yml")
    )
    @@cached_fuzzy_matcher = FuzzyMatch.new(
      @@cached_artists
    )
  end

  def use_large_artists_list
    @@cached_artists = YAML.load(
      File.read("./large_artists_list.yml")
    )
    @@cached_fuzzy_matcher = FuzzyMatch.new(
      @@cached_artists
    )
  end

  def cached_artists
    @@cached_artists
  end

  def cached_fuzzy_matcher
    @@cached_fuzzy_matcher
  end

  def search(query)
    cached_artists.select do |artist|
      includes_match?(artist, query)
    end
  end

  def regex_search(query)
    regex = query.gsub(" ", '\s')
                 .gsub(".", '\.')
                 .gsub(",", '\,')
    cached_artists.select do |company|
      company =~ /#{regex}/
    end
  end

  def fuzzy_search(query)
    cached_fuzzy_matcher.find_all_with_score(
      query
    ).map(&:first)
  end

  private
    def regex_match?(a,b)
      a =~ b
    end
    def includes_match?(a,b)
      a.include?(b)
    end
end