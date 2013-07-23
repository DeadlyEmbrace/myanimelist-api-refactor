describe AnimeListScraper do
  describe 'invalid anime list' do
    it 'should return nil' do
      VCR.use_cassette('anime_list/invalid_list') do
        response = HTTParty.get('http://myanimelist.net/malappinfo.php?u=does_not_exist&status=all&type=anime')
        anime_list = AnimeListScraper.scrape(response.body)
        anime_list.should be_nil
      end
    end
  end

  describe 'empty anime list' do
    it 'should have an empty anime list and 0 days in statistics' do
      VCR.use_cassette('anime_list/empty_list') do
        response = HTTParty.get('http://myanimelist.net/malappinfo.php?u=partial_profile&status=all&type=anime')
        anime_list = AnimeListScraper.scrape(response.body)
        anime_list.anime.should be_empty
        anime_list.statistics.should eq({ days: 0.0 })
      end
    end
  end

  describe 'populated anime list' do
    it 'should parse the list properly' do
      VCR.use_cassette('anime_list/populated_list') do
        response = HTTParty.get('http://myanimelist.net/malappinfo.php?u=small_profile&status=all&type=anime')
        anime_list = AnimeListScraper.scrape(response.body)
        anime_list.anime.size.should be 5
      end
    end

    it 'should parse an anime' do
      VCR.use_cassette('anime_list/populated_list') do
        response = HTTParty.get('http://myanimelist.net/malappinfo.php?u=small_profile&status=all&type=anime')
        anime_list = AnimeListScraper.scrape(response.body)
        anime = anime_list.anime[0]

        anime.id.should be 934
        anime.title.should eq 'Higurashi no Naku Koro ni'
        anime.type.should be :TV
        anime.status.should be :'finished airing'
        anime.episodes.should be 26
        anime.image_url.should eq 'http://cdn.myanimelist.net/images/anime/12/19634.jpg'
        anime.listed_anime_id.should be 0
        anime.watched_episodes.should be 26
        anime.score.should be 10
        anime.watched_status.should be :completed
      end
    end

    it 'should parse the statistics' do
      VCR.use_cassette('anime_list/populated_list') do
        response = HTTParty.get('http://myanimelist.net/malappinfo.php?u=small_profile&status=all&type=anime')
        anime_list = AnimeListScraper.scrape(response.body)
        anime_list.statistics[:days].should be 1.25
      end
    end
  end
end