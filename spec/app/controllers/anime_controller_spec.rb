require 'spec_helper'

describe "AnimeController" do
  describe :index do
    anime_url = 'http://myanimelist.net/anime/5114'

    it 'should hit the MyAnimeList anime url' do
      stub_request(:get, anime_url)
      allow(AnimeScraper).to receive(:scrape).and_return nil
      get '/anime/5114'
      assert_requested :get, anime_url
    end

    it 'should return a status code 404 if the anime returned is nil' do
      stub_request(:get, anime_url)
      allow(AnimeScraper).to receive(:scrape).and_return nil
      get '/anime/5114'
      last_response.should be_not_found
    end

    it 'should return a status code 200 if the anime returned is not nil' do
      stub_request(:get, anime_url)
      allow(AnimeScraper).to receive(:scrape).and_return({})
      get '/anime/5114'
      last_response.should be_ok
    end

    it 'should return an anime as json' do
      anime = Anime.new
      stub_request(:get, anime_url)
      allow(AnimeScraper).to receive(:scrape).and_return anime
      get '/anime/5114'
      last_response.body.should eq anime.to_json
    end
  end

  describe :search do
    search_url = 'http://myanimelist.net/anime.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=steins'

    it 'should hit the MyAnimeList anime search url' do
      stub_request(:get, search_url)
      allow(AnimeSearchScraper).to receive(:scrape).and_return nil
      get '/anime/search/steins'
      assert_requested :get, search_url
    end

    it 'should hit the MyAnimeList anime search url with pagination' do
      paging_url = search_url + '&show=40'
      stub_request(:get, paging_url)
      allow(AnimeSearchScraper).to receive(:scrape).and_return nil
      get 'anime/search/steins?page=3'
      assert_requested :get, paging_url
    end

    it 'should return a status code 200' do
      stub_request(:get, search_url)
      allow(AnimeSearchScraper).to receive(:scrape).and_return({})
      get '/anime/search/steins'
      last_response.should be_ok
    end

    it 'should return search results as json' do
      search_results = [Anime.new, Anime.new]
      stub_request(:get, search_url)
      allow(AnimeSearchScraper).to receive(:scrape).and_return search_results
      get '/anime/search/steins'
      last_response.body.should eq search_results.to_json
    end

    it 'should scrape a single anime as json if search page causes a redirect' do
      search_results = Anime.new
      redirect_url = 'http://myanimelist.net/anime/6978'
      stub_request(:get, search_url)
        .to_return(status: 302, body: '', headers: { 'Location' => redirect_url })
      stub_request(:get, redirect_url)

      allow(AnimeScraper).to receive(:scrape).and_return search_results
      get '/anime/search/steins'
      last_response.body.should eq [search_results].to_json
    end
  end

  describe :upcoming do
    search_url = 'http://myanimelist.net/anime.php?o=2&w=&c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&cv=1&em=0&ed=0&ey=0&sm=7&sd=10&sy=2013'

    it 'should hit the MyAnimeList upcoming url with todays date if no date is provided' do
      stub_request(:get, search_url)
      allow(Chronic).to receive(:parse).and_return Chronic.parse('2013-07-10')
      allow(AnimeSearchScraper).to receive(:scrape).and_return nil
      get '/anime/upcoming'
      assert_requested :get, search_url
    end

    it 'should hit the MyAnimeList upcoming url when passed a date' do
      date_url = 'http://myanimelist.net/anime.php?o=2&w=&c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&cv=1&em=0&ed=0&ey=0&sm=7&sd=15&sy=2013'
      stub_request(:get, date_url)
      allow(AnimeSearchScraper).to receive(:scrape).and_return nil
      get '/anime/upcoming?start_date=2013-07-15'
      assert_requested :get, date_url
    end
  end
end
