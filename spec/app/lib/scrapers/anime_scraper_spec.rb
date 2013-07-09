describe AnimeScraper do
  before :each do
    @anime_scraper = AnimeScraper.new
  end

  describe 'invalid anime' do
    it 'should return nil' do
      VCR.use_cassette('anime/invalid_anime') do
        response = HTTParty.get('http://myanimelist.net/anime/1231313213131231')
        anime = @anime_scraper.scrape(response.body)
        anime.should be_nil
      end
    end
  end

  describe 'valid anime' do
    it 'should not be nil' do
      # TODO - Determine how to test equality

      VCR.use_cassette('anime/valid_anime') do
        response = HTTParty.get('http://myanimelist.net/anime/1887')
        anime = @anime_scraper.scrape(response.body)
        anime.should eq expected
      end
    end
  end
end