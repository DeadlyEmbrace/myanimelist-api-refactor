describe TopAnimeScraper do
  describe 'no results' do
    it 'should return an empty array' do
      VCR.use_cassette('top_anime/no_results') do
        response = HTTParty.get('http://myanimelist.net/topanime.php?limit=10000000')
        top_anime = TopAnimeScraper.scrape(response.body)
        top_anime.should be_empty
      end
    end
  end

  describe 'results' do
    it 'should create an entry per result' do
      VCR.use_cassette('top_anime/results') do
        response = HTTParty.get('http://myanimelist.net/topanime.php')
        top_anime = TopAnimeScraper.scrape(response.body)
        top_anime.size.should be 30
      end
    end

    it 'should parse a complete result' do
      VCR.use_cassette('top_anime/results') do
        response = HTTParty.get('http://myanimelist.net/topanime.php')
        top_anime = TopAnimeScraper.scrape(response.body)
        anime = top_anime[0]
        anime.id.should be 5114
        anime.title.should eq 'Fullmetal Alchemist: Brotherhood'
        anime.type.should be :TV
        anime.episodes.should be 64
        anime.members_count.should be 224763
        anime.members_score.should eq 9.22
        anime.image_url.should eq 'http://cdn.myanimelist.net/images/anime/5/47421t.jpg'
      end
    end

    it 'should be able to parse no image url' do
      VCR.use_cassette('top_anime/results') do
        response = HTTParty.get('http://myanimelist.net/topanime.php')
        modified_response = Nokogiri::HTML(response)
        modified_response.search('img').remove
        top_anime = TopAnimeScraper.scrape(modified_response.to_s)
        top_anime[0].image_url.should be_nil
      end
    end
  end
end