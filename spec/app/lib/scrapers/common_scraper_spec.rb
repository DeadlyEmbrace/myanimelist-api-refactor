describe CommonScraper do
  describe 'anime id' do
    it 'should be able to scrape id out of mid textbox' do
      html = Nokogiri::HTML('<input name="aid" value="1234" />')
      anime_id = CommonScraper.scrape_id_input html, 'aid', %r{http://myanimelist.net/anime/(\d+)/.*?}
      anime_id.should be 1234
    end

    it 'should be able to scrape id out of details link' do
      html = Nokogiri::HTML '<a href="http://myanimelist.net/anime/1234/Bleach/">Details</a>'
      anime_id = CommonScraper.scrape_id_input html, 'mid', %r{http://myanimelist.net/anime/(\d+)/.*?}
      anime_id.should be 1234
    end
  end

  describe 'manga id' do
    it 'should be able to scrape id out of mid textbox' do
      html = Nokogiri::HTML('<input name="mid" value="1234" />')
      manga_id = CommonScraper.scrape_id_input html, 'mid', %r{http://myanimelist.net/manga/(\d+)/.*?}
      manga_id.should be 1234
    end

    it 'should be able to scrape id out of details link' do
      html = Nokogiri::HTML '<a href="http://myanimelist.net/manga/1234/Bleach/">Details</a>'
      manga_id = CommonScraper.scrape_id_input html, 'mid', %r{http://myanimelist.net/manga/(\d+)/.*?}
      manga_id.should be 1234
    end
  end

  describe 'genres' do
    it 'should be able to scrape genres' do
      html = Nokogiri::HTML '<div><span>Genres:</span><a>comedy</a><a>horror</a></div>'
      genres = CommonScraper.scrape_genres html
      genres.should eq %w(comedy horror)
    end
  end

  describe 'synopsis' do
    it 'should scrape single line synopsis' do
      html = Nokogiri::HTML '<h2>Synopsis</h2>This is my synopsis'
      synopsis = CommonScraper.scrape_details_synopsis html
      synopsis.should eq 'This is my synopsis'
    end
  end
end