require 'spec_helper'

describe 'UserController' do
  describe :profile do
    PROFILE_URL = 'http://myanimelist.net/profile/astraldragon88'

    it 'should hit the MyAnimeList profile URL' do
      stub_request(:any, PROFILE_URL)
      ProfileScraper.should_receive(:scrape).and_return nil
      get '/user/astraldragon88/profile'
      assert_requested :get, PROFILE_URL
    end

    it 'should return a status code 404 if the profile returned is nil' do
      stub_request(:any, PROFILE_URL)
      ProfileScraper.should_receive(:scrape).and_return nil
      get '/user/astraldragon88/profile'
      last_response.should be_not_found
    end

    it 'should return a status code 200 when valid profile is returned' do
      stub_request(:any, PROFILE_URL)
      ProfileScraper.should_receive(:scrape).and_return({})
      get '/user/astraldragon88/profile'
      last_response.should be_ok
    end

    it 'should return a profile as json' do
      profile = Profile.new
      stub_request(:any, PROFILE_URL)
      ProfileScraper.should_receive(:scrape).and_return profile
      get '/user/astraldragon88/profile'
      last_response.body.should eq profile.to_json
    end
  end

  describe :animelist do
    ANIME_LIST_URL = 'http://myanimelist.net/malappinfo.php?u=astraldragon88&status=all&type=anime'

    it 'should hit the MyAnimeList anime list URL' do
      stub_request(:any, ANIME_LIST_URL)
      AnimeListScraper.should_receive(:scrape).and_return nil
      get '/user/astraldragon88/animelist'
      assert_requested :get, ANIME_LIST_URL
    end

    it 'should return a status code 404 if the anime list returned is nil' do
      stub_request(:any, ANIME_LIST_URL)
      AnimeListScraper.should_receive(:scrape).and_return nil
      get '/user/astraldragon88/animelist'
      last_response.should be_not_found
    end

    it 'should return a status code 200 if the anime list is not nil' do
      stub_request(:any, ANIME_LIST_URL)
      AnimeListScraper.should_receive(:scrape).and_return({})
      get '/user/astraldragon88/animelist'
      last_response.should be_ok
    end

    it 'should return history as json' do
      anime_list = AnimeList.new
      stub_request(:any, ANIME_LIST_URL)
      AnimeListScraper.should_receive(:scrape).and_return(anime_list)
      get '/user/astraldragon88/animelist'
      last_response.body.should eq anime_list.to_json
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

      it 'should return a status code 404 if the history returned is nil' do
        stub_request(:any, ANIME_HISTORY_URL)
        UserHistoryScraper.should_receive(:scrape).and_return nil
        get '/user/astraldragon88/history/anime'
        last_response.should be_not_found
      end

      it 'should return a status code 200 when valid history is returned' do
        stub_request(:any, ANIME_HISTORY_URL)
        UserHistoryScraper.should_receive(:scrape).and_return({})
        get '/user/astraldragon88/history/anime'
        last_response.should be_ok
      end

      it 'should return history as json' do
        history = []
        stub_request(:any, ANIME_HISTORY_URL)
        UserHistoryScraper.should_receive(:scrape).and_return(history)
        get '/user/astraldragon88/history/anime'
        last_response.body.should eq history.to_json
      end
    end

    describe 'manga history' do
      it 'should hit the MyAnimeList anime history URL' do
        stub_request(:any, MANGA_HISTORY_URL)
        UserHistoryScraper.should_receive(:scrape).and_return nil
        get '/user/astraldragon88/history/manga'
        assert_requested :get, MANGA_HISTORY_URL
      end

      it 'should return a status code 404 if the history returned is nil' do
        stub_request(:any, MANGA_HISTORY_URL)
        UserHistoryScraper.should_receive(:scrape).and_return nil
        get '/user/astraldragon88/history/manga'
        last_response.should be_not_found
      end

      it 'should return a 200 when valid history is returned' do
        stub_request(:any, MANGA_HISTORY_URL)
        UserHistoryScraper.should_receive(:scrape).and_return({})
        get '/user/astraldragon88/history/manga'
        last_response.should be_ok
      end

      it 'should return history as json' do
        history = []
        stub_request(:any, MANGA_HISTORY_URL)
        UserHistoryScraper.should_receive(:scrape).and_return(history)
        get '/user/astraldragon88/history/manga'
        last_response.body.should eq history.to_json
      end
    end
  end
end
