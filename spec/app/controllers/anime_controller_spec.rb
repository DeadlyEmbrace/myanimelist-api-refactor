require 'spec_helper'

describe "AnimeController" do
  describe :show do
    anime_url = 'http://myanimelist.net/anime/5114'

    it 'should hit the MyAnimeList anime url' do
      stub_request(:any, anime_url)
      AnimeScraper.should_receive(:scrape).and_return nil
      get '/anime/5114'
      assert_requested :get, anime_url
    end

    it 'should return a status code 404 if the anime returned is nil' do
      stub_request(:any, anime_url)
      AnimeScraper.should_receive(:scrape).and_return nil
      get '/anime/5114'
      last_response.should be_not_found
    end

    it 'should return a status code 200 if the anime returned is not nil' do
      stub_request(:any, anime_url)
      AnimeScraper.should_receive(:scrape).and_return({})
      get '/anime/5114'
      last_response.should be_ok
    end

    it 'should return an anime as json' do
      anime = Anime.new
      stub_request(:any, anime_url)
      AnimeScraper.should_receive(:scrape).and_return(anime)
      get '/anime/5114'
      last_response.body.should eq anime.to_json
    end
  end
end
