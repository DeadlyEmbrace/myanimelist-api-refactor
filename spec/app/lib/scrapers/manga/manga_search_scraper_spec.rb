describe MangaSearchScraper do
  describe 'no results' do
    it 'should return an empty array' do
      VCR.use_cassette('manga_search/no_results') do
        response = HTTParty.get('http://myanimelist.net/manga.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=no_results')
        manga_search = MangaSearchScraper.scrape(response.body)
        manga_search.should be_empty
      end
    end
  end

  describe 'results' do
    it 'should create a manga entry per result' do
      VCR.use_cassette('manga_search/valid_results') do
        response = HTTParty.get('http://myanimelist.net/manga.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=steins')
        anime_search = MangaSearchScraper.scrape(response.body)
        anime_search.size.should be 9
      end
    end

    it 'should parse a complete result' do
      VCR.use_cassette('manga_search/valid_results') do
        response = HTTParty.get('http://myanimelist.net/manga.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=steins')
        manga_search = MangaSearchScraper.scrape(response.body)

        manga = manga_search[3]
        manga.id.should be 28899
        manga.title.should eq 'Steins;Gate Onshuu no Brownian Motion'
        manga.image_url.should eq 'http://cdn.myanimelist.net/images/manga/2/46371t.jpg'
        manga.synopsis.should eq 'Tells the story of how Tennouji Yuugo met Suzu Hashida.'
        manga.type.should be :Manga
        manga.volumes.should be 2
        manga.chapters.should be 11
        manga.members_score.should be 7.77
      end
    end

    it 'should parse no image url' do
      VCR.use_cassette('manga_search/valid_results') do
        response = HTTParty.get('http://myanimelist.net/manga.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=steins')
        modified_response = Nokogiri::HTML(response)
        modified_response.search('img').remove
        manga_search = MangaSearchScraper.scrape(modified_response.to_s)
        manga = manga_search[0]
        manga.image_url.should be_nil
      end
    end

    it 'should parse no synopsis' do
      VCR.use_cassette('manga_search/valid_results') do
        response = HTTParty.get('http://myanimelist.net/manga.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=steins')
        modified_response = Nokogiri::HTML(response)
        modified_response.search('.spaceit_pad').remove
        manga_search = MangaSearchScraper.scrape(modified_response.to_s)
        manga = manga_search[0]
        manga.synopsis.should be_nil
      end
    end
  end
end