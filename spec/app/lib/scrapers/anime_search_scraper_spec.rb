describe AnimeSearchScraper do
  describe 'no results' do
    it 'should return an empty array' do
      VCR.use_cassette('anime_search/no_results') do
        response = HTTParty.get('http://myanimelist.net/anime.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=no_results')
        anime_search = AnimeSearchScraper.scrape(response.body)
        anime_search.should be_empty
      end
    end
  end

  describe 'results' do
    it 'should parse optional classification' do
      VCR.use_cassette('anime_search/valid_results') do
        response = HTTParty.get('http://myanimelist.net/anime.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=steins')
        anime_search = AnimeSearchScraper.scrape(response.body)

        anime = anime_search[0]
        anime.classification.should be_nil
      end
    end
  end
end