describe AnimeScraper do
  before :each do
    @anime_scraper = AnimeScraper.new
  end

  describe 'invalid anime' do
    it 'should return nil' do
      VCR.use_cassette('anime/invalid_anime') do
        response = HTTParty.get('http://myanimelist.net/anime/1231313213131231')
        anime = @anime_scraper.scrape(response.body)
        anime.should be_nil
      end
    end
  end

  # This may not be as useful as the in other tests.  VCR seems
  # to be returning a binary string instead of HTML.
  describe 'valid anime' do
    it 'should scrape anime properly' do
      expected = create_anime

      VCR.use_cassette('anime/valid_anime') do
        response = HTTParty.get('http://myanimelist.net/anime/1887')
        anime = @anime_scraper.scrape(response.body)
        anime.should eq expected
      end
    end
  end

  describe 'alternative titles' do
    it 'should be able to handle no alternative titles' do
      html = '<input name="aid" value="1234" /><h1>Bleach <div>Ranked #450</div></h1>
        <div id="content">
        <table>
        <tr><td class="borderClass"></td></tr>
        </table>
        </div>'

      anime = @anime_scraper.scrape(html)
      anime.other_titles.should be_empty
    end

    it 'should be able to english titles' do
      html = '<input name="aid" value="1234" /><h1>Bleach <div>Ranked #450</div></h1>
        <div id="content">
        <table>
        <tr><td class="borderClass"><div><span>English:</span> Bleach, Bleach 2</div></td></tr>
        </table>
        </div>'

      anime = @anime_scraper.scrape(html)
      anime.other_titles.should eq({ english: ['Bleach', 'Bleach 2'] })
    end

    it 'should be able to scrape synonym titles' do
      html = '<input name="aid" value="1234" /><h1>Bleach <div>Ranked #450</div></h1>
        <div id="content">
        <table>
        <tr><td class="borderClass"><div><span>Synonyms:</span> Bleach 2, Bleach 3</div></td></tr>
        </table>
        </div>'

      anime = @anime_scraper.scrape(html)
      anime.other_titles.should eq({ synonyms: ['Bleach 2', 'Bleach 3'] })
    end

    it 'should be able to scrape japanese titles' do
      html = '<input name="aid" value="1234" /><h1>Bleach <div>Ranked #450</div></h1>
        <div id="content">
        <table>
        <tr><td class="borderClass"><div><span>Japanese:</span> ブリーチ, ブリー</div></td></tr>
        </table>
        </div>'

      anime = @anime_scraper.scrape(html)
      anime.other_titles.should eq({ japanese: ['ブリーチ', 'ブリー'] })
    end
  end

  private
    # TODO - Move this into a test helper.  Also, look at better way of constructing an object
    def create_anime
      anime = Anime.new
      anime.id = 1887
      anime.title = 'Lucky&#9734;Star'
      anime.rank = 370
      anime.popularity_rank = 29
      anime.image_url = 'http://cdn.myanimelist.net/images/anime/3/29625.jpg'
      anime.episodes = 24
      anime.classification = 'PG-13 - Teens 13 or older'
      anime.members_score = 8.1
      anime.members_count = 157194
      anime.favorited_count = 6412
      anime.synopsis = 'Having fun in school, doing homework together, cooking and eating, playing videogames, watching anime. All those little things make up the daily life of the anime- and chocolate-loving Izumi Konata and her friends. Sometimes relaxing but more than often simply funny! <br><br>
(Source: AniDB)'
      anime.start_date = Chronic.parse('2007-04-08 12:00:00 -0300')
      anime.end_date = Chronic.parse('2007-09-17 12:00:00 -0300')
      anime.type = :TV
      anime.status = 'finished airing'
      anime.watched_episodes = 0
      anime.score = nil
      anime.watched_status = nil
      anime.other_titles = {english: ['Lucky☆Star'], japanese: ['らき☆すた']}
      anime.genres = ['Comedy', 'Parody', 'School', 'Slice of Life']
      anime.tags = ['comedy', 'parody', 'school', 'slice of life']
      anime.manga_adaptations = [{manga_id: '587', title: 'Lucky&#9734;Star', url: 'http://myanimelist.net/manga/587/Lucky%E2%98%86Star'}]
      anime.sequels = [{:anime_id=>'4472', :title=>'Lucky&#9734;Star OVA', :url=>'http://myanimelist.net/anime/4472/Lucky%E2%98%86Star_OVA'}]
      anime.character_anime = [{:anime_id=>'3080', :title=>'Anime Tenchou', :url=>'http://myanimelist.net/anime/3080/Anime_Tenchou'}]
      anime.spin_offs=[{:anime_id=>'17637', :title=>'Miyakawa-ke no Kuufuku', :url=>'http://myanimelist.net/anime/17637/Miyakawa-ke_no_Kuufuku'}]
      
      anime
    end
end