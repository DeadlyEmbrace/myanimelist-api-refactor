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
    it 'should create an anime entry per result' do
      VCR.use_cassette('anime_search/valid_results') do
        response = HTTParty.get('http://myanimelist.net/anime.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=steins')
        anime_search = AnimeSearchScraper.scrape(response.body)
        anime_search.size.should be 4
      end
    end

    it 'should parse a complete result' do
      VCR.use_cassette('anime_search/valid_results') do
        response = HTTParty.get('http://myanimelist.net/anime.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=steins')
        anime_search = AnimeSearchScraper.scrape(response.body)

        anime = anime_search[1]
        anime.id.should be 9253
        anime.title.should eq 'Steins;Gate'
        anime.image_url.should eq 'http://cdn.myanimelist.net/images/anime/11/41011t.jpg'
        anime.synopsis.should eq 'Steins;Gate is set in the summer of 2010, approximately one year after the events that took place in Chaos;Head, in Akihabara.

Steins;Gate is about a group of friends who have customized their microw...'
        anime.type.should be :TV
        anime.episodes.should be 24
        anime.members_score.should be 9.17

        expected_start_date = Chronic.parse('04-06-11').to_date
        anime.start_date.should eq expected_start_date
        expected_end_date = Chronic.parse('09-14-11').to_date
        anime.end_date.should eq expected_end_date
        anime.classification.should eq 'R'
      end
    end

    it 'should parse no image url' do
      VCR.use_cassette('anime_search/valid_results') do
        response = HTTParty.get('http://myanimelist.net/anime.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=steins')
        modified_response = Nokogiri::HTML(response)
        modified_response.search('img').remove
        anime_search = AnimeSearchScraper.scrape(modified_response.to_s)
        anime = anime_search[0]
        anime.image_url.should be_nil
      end
    end

    it 'should parse no synopsis' do
      VCR.use_cassette('anime_search/valid_results') do
        response = HTTParty.get('http://myanimelist.net/anime.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=steins')
        modified_response = Nokogiri::HTML(response)
        modified_response.search('.spaceit').remove
        anime_search = AnimeSearchScraper.scrape(modified_response.to_s)
        anime = anime_search[0]
        anime.synopsis.should be_nil
      end
    end

    it 'should parse no classification' do
      VCR.use_cassette('anime_search/valid_results') do
        response = HTTParty.get('http://myanimelist.net/anime.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=steins')
        anime_search = AnimeSearchScraper.scrape(response.body)

        anime = anime_search[0]
        anime.classification.should be_nil
      end
    end
  end
end