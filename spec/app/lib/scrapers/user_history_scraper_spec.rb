describe UserHistoryScraper do
  describe 'history for invalid user' do
    it 'should return nil' do
      VCR.use_cassette('history/invalid_history') do
        response = HTTParty.get('http://myanimelist.net/history/user_does_not_exist')
        history = UserHistoryScraper.scrape(response.body)
        history.should be_nil
      end
    end

    it 'should return nil for anime history' do
      VCR.use_cassette('history/invalid_anime_history') do
        response = HTTParty.get('http://myanimelist.net/history/user_does_not_exist/anime')
        history = UserHistoryScraper.scrape(response.body)
        history.should be_nil
      end
    end

    it 'should return nil for manga history' do
      VCR.use_cassette('history/invalid_manga_history') do
        response = HTTParty.get('http://myanimelist.net/history/user_does_not_exist/manga')
        history = UserHistoryScraper.scrape(response.body)
        history.should be_nil
      end
    end
  end

  describe 'user with no history' do
    it 'should return an empty history' do
      VCR.use_cassette('history/no_history') do
        response = HTTParty.get('http://myanimelist.net/history/partial_profile')
        history = UserHistoryScraper.scrape(response.body)
        history.should be_empty
      end
    end

    it 'should return an empty anime history' do
      VCR.use_cassette('history/no_anime_history') do
        response = HTTParty.get('http://myanimelist.net/history/partial_profile/anime')
        history = UserHistoryScraper.scrape(response.body)
        history.should be_empty
      end
    end

    it 'should return an empty manga history' do
      VCR.use_cassette('history/no_manga_history') do
        response = HTTParty.get('http://myanimelist.net/history/partial_profile/manga')
        history = UserHistoryScraper.scrape(response.body)
        history.should be_empty
      end
    end
  end

  describe 'history for valid user' do
    describe 'all history' do
      it 'should scrape the history page' do
        expected = [
            { manga_id: 8795, chapter: 59, title: 'Area no Kishi' },
            { anime_id: 11757, episode: 8, title: 'Sword Art Online' },
            { anime_id: 11757, episode: 2, title: 'Sword Art Online' },
            { anime_id: 11757, episode: 1, title: 'Sword Art Online' },
        ]

        VCR.use_cassette('history/valid_history') do
          response = HTTParty.get('http://myanimelist.net/history/astraldragon88')
          history = UserHistoryScraper.scrape(response.body)
          history.should eq expected
        end
      end
    end

    describe 'anime history' do
      it 'should scrape the history page' do
        expected = [
            { anime_id: 11757, episode: 8, title: 'Sword Art Online' },
            { anime_id: 11757, episode: 2, title: 'Sword Art Online' },
            { anime_id: 11757, episode: 1, title: 'Sword Art Online' },
        ]

        VCR.use_cassette('history/valid_anime_history') do
          response = HTTParty.get('http://myanimelist.net/history/astraldragon88/anime')
          history = UserHistoryScraper.scrape(response.body)
          history.should eq expected
        end
      end
    end

    describe 'manga history' do
      it 'should scrape the history page' do
        expected = [
            { manga_id: 8795, chapter: 59, title: 'Area no Kishi' }
        ]

        VCR.use_cassette('history/valid_manga_history') do
          response = HTTParty.get('http://myanimelist.net/history/astraldragon88/manga')
          history = UserHistoryScraper.scrape(response.body)
          history.should eq expected
        end
      end
    end
  end
end