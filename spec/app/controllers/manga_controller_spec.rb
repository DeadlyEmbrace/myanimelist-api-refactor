require 'spec_helper'

describe 'MangaController' do
  describe :index do
    manga_url = 'http://myanimelist.net/manga/5114'

    it 'should hit the MyAnimeList anime url' do
      stub_request :get, manga_url
      allow(MangaScraper).to receive(:scrape).and_return nil
      get '/manga/5114'
      assert_requested :get, manga_url
    end

    it 'should return a status code 404 if the manga returned is nil' do
      stub_request :get, manga_url
      allow(MangaScraper).to receive(:scrape).and_return nil
      get '/manga/5114'
      last_response.should be_not_found
    end

    it 'should return a status code 200 if the manga returned is not nil' do
      stub_request :get, manga_url
      allow(MangaScraper).to receive(:scrape).and_return({})
      get '/manga/5114'
      last_response.should be_ok
    end

    it 'should return an anime as json' do
      manga = Manga.new
      stub_request :get, manga_url
      allow(MangaScraper).to receive(:scrape).and_return manga
      get '/manga/5114'
      last_response.body.should eq manga.to_json
    end
  end

  describe :search do
    search_url = 'http://myanimelist.net/manga.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=steins'

    it 'should hit the MyAnimeList manga search url' do
      stub_request :get, search_url
      allow(MangaSearchScraper).to receive(:scrape).and_return nil
      get '/manga/search/steins'
      assert_requested :get, search_url
    end

    it 'should hit the MyAnimeList manga search url with pagination' do
      paging_url = search_url + '&show=40'
      stub_request :get, paging_url
      allow(MangaSearchScraper).to receive(:scrape).and_return nil
      get '/manga/search/steins?page=3'
      assert_requested :get, paging_url
    end

    it 'should return a status code 200' do
      stub_request :get, search_url
      allow(MangaSearchScraper).to receive(:scrape).and_return({})
      get '/manga/search/steins'
      last_response.should be_ok
    end

    it 'should return search results as json' do
      search_results = [Manga.new, Manga.new]
      stub_request :get, search_url
      allow(MangaSearchScraper).to receive(:scrape).and_return search_results
      get '/manga/search/steins'
      last_response.body.should eq search_results.to_json
    end

    it 'should scrape a single anime as json if search page causes a redirect' do
      search_results = Manga.new
      redirect_url = 'http://myanimelist.net/manga/6978'
      stub_request(:get, search_url)
      .to_return status: 302, body: '', headers: { Location: redirect_url }
      stub_request :get, redirect_url
      allow(MangaScraper).to receive(:scrape).and_return search_results
      get '/manga/search/steins'
      last_response.body.should eq [search_results].to_json
    end
  end
end
