describe MangaListScraper do
  describe 'invalid manga list' do
    it 'should return nil' do
      VCR.use_cassette('manga_list/invalid_list') do
        response = HTTParty.get('http://myanimelist.net/malappinfo.php?u=does_not_exist&status=all&type=manga')
        anime_list = MangaListScraper.scrape(response.body)
        anime_list.should be_nil
      end
    end
  end

  describe 'empty manga list' do
    it 'should have an empty manga list and 0 days in statistics' do
      VCR.use_cassette('manga_list/empty_list') do
        response = HTTParty.get('http://myanimelist.net/malappinfo.php?u=partial_profile&status=all&type=manga')
        manga_list = MangaListScraper.scrape(response.body)
        manga_list.manga.should be_empty
        manga_list.statistics.should eq({ days: 0.0 })
      end
    end
  end

  describe 'populated manga list' do
    it 'should parse the list properly' do
      VCR.use_cassette('manga_list/populated_list') do
        response = HTTParty.get('http://myanimelist.net/malappinfo.php?u=small_profile&status=all&type=manga')
        manga_list = MangaListScraper.scrape(response.body)
        manga_list.manga.size.should be 5
      end
    end

    it 'should parse a manga' do
      VCR.use_cassette('manga_list/populated_list') do
        response = HTTParty.get('http://myanimelist.net/malappinfo.php?u=small_profile&status=all&type=manga')
        manga_list = MangaListScraper.scrape(response.body)
        manga = manga_list.manga[0]

        manga.id.should be 2
        manga.title.should eq 'Berserk'
        manga.type.should be :Manga
        manga.status.should be :publishing
        manga.chapters.should be 0
        manga.volumes.should be 0
        manga.image_url.should eq 'http://cdn.myanimelist.net/images/manga/3/26544.jpg'
        manga.listed_manga_id.should be 24710533
        manga.volumes_read.should be 1
        manga.chapters_read.should be 1
        manga.score.should be 0
        manga.read_status.should be :reading
      end
    end

    it 'should parse statistics' do
      VCR.use_cassette('manga_list/populated_list') do
        response = HTTParty.get('http://myanimelist.net/malappinfo.php?u=small_profile&status=all&type=manga')
        manga_list = MangaListScraper.scrape(response.body)
        manga_list.statistics[:days].should be 0.0
      end
    end
  end
end