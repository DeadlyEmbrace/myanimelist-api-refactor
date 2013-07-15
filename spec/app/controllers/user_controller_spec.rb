require 'spec_helper'

describe 'UserController' do
  before :each do
    @mock_httparty = double('HTTParty')
    @mock_profile_scraper = double('ProfileScraper')
  end

  describe :profile do
    PROFILE_URL = 'http://myanimelist.net/profile/astraldragon88'

    it 'should hit the MyAnimeList profile URL' do
      stub_request(:any, PROFILE_URL)
      ProfileScraper.should_receive(:scrape).and_return nil
      get '/user/astraldragon88/profile'
      assert_requested :get, PROFILE_URL
    end

    it 'should return a 404 if the profile returned is nil' do
      stub_request(:any, PROFILE_URL)
      ProfileScraper.should_receive(:scrape).and_return nil
      response = get '/user/astraldragon88/profile'
      response.status.should be 404
    end

    it 'should return a status code 200 when valid profile is returned' do
      stub_request(:any, PROFILE_URL)
      ProfileScraper.should_receive(:scrape).and_return({})
      response = get '/user/astraldragon88/profile'
      response.status.should be 200
    end

    it 'should return a profile as json' do
      profile = Profile.new
      stub_request(:any, PROFILE_URL)
      ProfileScraper.should_receive(:scrape).and_return profile
      response = get '/user/astraldragon88/profile'
      response.body.should eq profile.to_json
    end
  end

  describe :history do
    BASE_HISTORY_URL = 'http://myanimelist.net/history/astraldragon88'
    ANIME_HISTORY_URL = BASE_HISTORY_URL + '/anime'
    MANGA_HISTORY_URL = BASE_HISTORY_URL + '/manga'

    describe 'anime history' do
      it 'should hit the MyAnimeList anime history URL' do
        stub_request(:any, ANIME_HISTORY_URL)
        UserHistoryScraper.should_receive(:scrape).and_return nil
        get '/user/astraldragon88/history/anime'
        assert_requested :get, ANIME_HISTORY_URL
      end

      it 'should return a 404 if the history returned is nil' do
        stub_request(:any, ANIME_HISTORY_URL)
        UserHistoryScraper.should_receive(:scrape).and_return nil
        response = get '/user/astraldragon88/history/anime'
        response.status.should be 404
      end

      it 'should return a status code 200 when valid history is returned' do
        stub_request(:any, ANIME_HISTORY_URL)
        UserHistoryScraper.should_receive(:scrape).and_return({})
        response = get '/user/astraldragon88/history/anime'
        response.status.should be 200
      end

      it 'should return history as json' do
        history = []
        stub_request(:any, ANIME_HISTORY_URL)
        UserHistoryScraper.should_receive(:scrape).and_return(history)
        response = get '/user/astraldragon88/history/anime'
        response.body.should eq history.to_json
      end
    end

    describe 'manga history' do
      it 'should hit the MyAnimeList anime history URL' do
        stub_request(:any, MANGA_HISTORY_URL)
        UserHistoryScraper.should_receive(:scrape).and_return nil
        get '/user/astraldragon88/history/manga'
        assert_requested :get, MANGA_HISTORY_URL
      end

      it 'should return a 404 if the history returned is nil' do
        stub_request(:any, MANGA_HISTORY_URL)
        UserHistoryScraper.should_receive(:scrape).and_return nil
        response = get '/user/astraldragon88/history/manga'
        response.status.should be 404
      end

      it 'should return a 200 when valid history is returned' do
        stub_request(:any, MANGA_HISTORY_URL)
        UserHistoryScraper.should_receive(:scrape).and_return({})
        response = get '/user/astraldragon88/history/manga'
        response.status.should be 200
      end

      it 'should return history as json' do
        history = []
        stub_request(:any, MANGA_HISTORY_URL)
        UserHistoryScraper.should_receive(:scrape).and_return(history)
        response = get '/user/astraldragon88/history/manga'
        response.body.should eq history.to_json
      end
    end
  end
end
