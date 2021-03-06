require 'spec_helper'

describe 'UserController' do
  describe :index do
    profile_url = 'http://myanimelist.net/profile/astraldragon88'

    it 'should hit the MyAnimeList profile URL' do
      stub_request(:get, profile_url)
      allow(ProfileScraper).to receive(:scrape).and_return nil
      get '/user/astraldragon88'
      assert_requested :get, profile_url
    end

    it 'should return a status code 404 if the profile returned is nil' do
      stub_request(:get, profile_url)
      allow(ProfileScraper).to receive(:scrape).and_return nil
      get '/user/astraldragon88'
      last_response.should be_not_found
    end

    it 'should return a status code 200 when valid profile is returned' do
      stub_request(:get, profile_url)
      allow(ProfileScraper).to receive(:scrape).and_return({})
      get '/user/astraldragon88'
      last_response.should be_ok
    end

    it 'should return a profile as json' do
      profile = Profile.new
      stub_request(:get, profile_url)
      allow(ProfileScraper).to receive(:scrape).and_return profile
      get '/user/astraldragon88'
      last_response.body.should eq profile.to_json
    end
  end

  describe :animelist do
    anime_list_url = 'http://myanimelist.net/malappinfo.php?u=astraldragon88&status=all&type=anime'

    it 'should hit the MyAnimeList anime list URL' do
      stub_request(:get, anime_list_url)
      allow(AnimeListScraper).to receive(:scrape).and_return nil
      get '/user/astraldragon88/animelist'
      assert_requested :get, anime_list_url
    end

    it 'should return a status code 404 if the anime list returned is nil' do
      stub_request(:get, anime_list_url)
      allow(AnimeListScraper).to receive(:scrape).and_return nil
      get '/user/astraldragon88/animelist'
      last_response.should be_not_found
    end

    it 'should return a status code 200 if the anime list is not nil' do
      stub_request(:get, anime_list_url)
      allow(AnimeListScraper).to receive(:scrape).and_return({})
      get '/user/astraldragon88/animelist'
      last_response.should be_ok
    end

    it 'should return history as json' do
      anime_list = AnimeList.new
      stub_request(:get, anime_list_url)
      allow(AnimeListScraper).to receive(:scrape).and_return anime_list
      get '/user/astraldragon88/animelist'
      last_response.body.should eq anime_list.to_json
    end
  end

  describe :animelist_add do
    it 'should require authentication' do
      post '/user/astraldragon88/animelist/1'
      last_response.status.should eq 401
    end

    it 'should return users anime list' do
      post '/user/astraldragon88/animelist/1', {}, 'REMOTE_USER' => 'test'
      last_response.should be_ok
    end
  end

  describe :mangalist do
    manga_list_url = 'http://myanimelist.net/malappinfo.php?u=astraldragon88&status=all&type=manga'

    it 'should hit the MyAnimeList anime list URL' do
      stub_request(:get, manga_list_url)
      allow(MangaListScraper).to receive(:scrape).and_return nil
      get '/user/astraldragon88/mangalist'
      assert_requested :get, manga_list_url
    end

    it 'should return a status code 404 if the anime list returned is nil' do
      stub_request(:get, manga_list_url)
      allow(MangaListScraper).to receive(:scrape).and_return nil
      get '/user/astraldragon88/mangalist'
      last_response.should be_not_found
    end

    it 'should return a status code 200 if the anime list is not nil' do
      stub_request(:get, manga_list_url)
      allow(MangaListScraper).to receive(:scrape).and_return({})
      get '/user/astraldragon88/mangalist'
      last_response.should be_ok
    end

    it 'should return history as json' do
      manga_list = MangaList.new
      stub_request(:get, manga_list_url)
      allow(MangaListScraper).to receive(:scrape).and_return manga_list
      get '/user/astraldragon88/mangalist'
      last_response.body.should eq manga_list.to_json
    end
  end

  describe :history do
    base_history_url = 'http://myanimelist.net/history/astraldragon88'

    describe 'anime history' do
      anime_history_url = base_history_url + '/anime'

      it 'should hit the MyAnimeList anime history URL' do
        stub_request(:get, anime_history_url)
        allow(UserHistoryScraper).to receive(:scrape).and_return nil
        get '/user/astraldragon88/history/anime'
        assert_requested :get, anime_history_url
      end

      it 'should return a status code 404 if the history returned is nil' do
        stub_request(:get, anime_history_url)
        allow(UserHistoryScraper).to receive(:scrape).and_return nil
        get '/user/astraldragon88/history/anime'
        last_response.should be_not_found
      end

      it 'should return a status code 200 when valid history is returned' do
        stub_request(:get, anime_history_url)
        allow(UserHistoryScraper).to receive(:scrape).and_return({})
        get '/user/astraldragon88/history/anime'
        last_response.should be_ok
      end

      it 'should return history as json' do
        history = []
        stub_request(:get, anime_history_url)
        allow(UserHistoryScraper).to receive(:scrape).and_return history
        get '/user/astraldragon88/history/anime'
        last_response.body.should eq history.to_json
      end
    end

    describe 'manga history' do
      manga_history_url = base_history_url + '/manga'

      it 'should hit the MyAnimeList anime history URL' do
        stub_request(:get, manga_history_url)
        allow(UserHistoryScraper).to receive(:scrape).and_return nil
        get '/user/astraldragon88/history/manga'
        assert_requested :get, manga_history_url
      end

      it 'should return a status code 404 if the history returned is nil' do
        stub_request(:get, manga_history_url)
        allow(UserHistoryScraper).to receive(:scrape).and_return nil
        get '/user/astraldragon88/history/manga'
        last_response.should be_not_found
      end

      it 'should return a 200 when valid history is returned' do
        stub_request(:get, manga_history_url)
        allow(UserHistoryScraper).to receive(:scrape).and_return({})
        get '/user/astraldragon88/history/manga'
        last_response.should be_ok
      end

      it 'should return history as json' do
        history = []
        stub_request(:get, manga_history_url)
        allow(UserHistoryScraper).to receive(:scrape).and_return history
        get '/user/astraldragon88/history/manga'
        last_response.body.should eq history.to_json
      end
    end
  end
end
