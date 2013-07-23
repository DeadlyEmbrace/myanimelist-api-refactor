describe AnimeScraper do
  describe 'invalid anime' do
    it 'should return nil' do
      VCR.use_cassette('anime/invalid_anime') do
        response = HTTParty.get('http://myanimelist.net/anime/1231313213131231')
        anime = AnimeScraper.scrape(response.body)
        anime.should be_nil
      end
    end
  end

  describe 'id' do
    it 'should be able to scrape id out of aid textbox' do
      html = create_left_detail
      anime = AnimeScraper.scrape(html)
      anime.id.should be 1234
    end

    it 'should be able to scrape id out of details link' do
      html = "<a href='http://myanimelist.net/anime/1234/Bleach/'>Details</a>
      <h1>Bleach <div>Ranked #450</div></h1>
      <div id='content'>
      <table>
      <tr><td class='borderClass'>
      </td></tr>
      </table>
      </div>"

      anime = AnimeScraper.scrape(html)
      anime.id.should be 1234
    end
  end

  describe 'title' do
    it 'should be able to scrape title' do
      html = create_left_detail
      anime = AnimeScraper.scrape(html)
      anime.title.should eq 'Bleach'
    end
  end

  describe 'rank' do
    it 'should be able to scrape rank' do
      html = create_left_detail
      anime = AnimeScraper.scrape(html)
      anime.rank.should be 450
    end
  end

  describe 'image url' do
    it 'should be able to scrape anime with no image url' do
      html = create_left_detail
      anime = AnimeScraper.scrape(html)
      anime.image_url.should be_nil
    end

    it 'should be able to scrape anime with image url' do
      expected = 'http://cdn.myanimelist.net/images/anime/3/20349.jpg'
      html = create_left_detail "<div><img src='#{expected}' /></div>"
      anime = AnimeScraper.scrape(html)
      anime.image_url.should eq expected
    end
  end

  describe 'alternative titles' do
    it 'should be able to handle no alternative titles' do
      html = create_left_detail
      anime = AnimeScraper.scrape(html)
      anime.other_titles.should be_empty
    end

    it 'should be able to english titles' do
      html = create_left_detail '<div><span>English:</span> Bleach, Bleach 2</div>'
      anime = AnimeScraper.scrape(html)
      anime.other_titles.should eq({ english: ['Bleach', 'Bleach 2'] })
    end

    it 'should be able to scrape synonym titles' do
      html = create_left_detail '<div><span>Synonyms:</span> Bleach 2, Bleach 3</div>'
      anime = AnimeScraper.scrape(html)
      anime.other_titles.should eq({ synonyms: ['Bleach 2', 'Bleach 3'] })
    end

    it 'should be able to scrape japanese titles' do
      html = create_left_detail '<div><span>Japanese:</span> ブリーチ, ブリー</div>'
      anime = AnimeScraper.scrape(html)
      anime.other_titles.should eq({ japanese: %w(ブリーチ ブリー)})
    end
  end

  describe 'information' do
    it 'should be able to scrape type' do
      html = create_left_detail '<div><span>Type:</span> TV</div>'
      anime = AnimeScraper.scrape(html)
      anime.type.should be :TV
    end

    it 'should be able to scrape episodes' do
      html = create_left_detail '<div><span>Episodes:</span> 100</div>'
      anime = AnimeScraper.scrape(html)
      anime.episodes.should be 100
    end

    it 'should be able to scrape status' do
      html = create_left_detail '<div><span>Status:</span> Currently Airing</div>'
      anime = AnimeScraper.scrape(html)
      anime.status.should be :'currently airing'
    end

    it 'should be able to scrape genres' do
      html = create_left_detail '<div><span>Genres:</span><a>comedy</a><a>horror</a></div>'
      anime = AnimeScraper.scrape(html)
      anime.genres.should eq %w(comedy horror)
    end

    it 'should be able to scrape rating' do
      html = create_left_detail '<div><span>Rating:</span>PG-13</div>'
      anime = AnimeScraper.scrape(html)
      anime.classification.should eq 'PG-13'
    end
  end

  describe 'statistics' do
    it 'should be able to scrape score' do
      html = create_left_detail '<div><span>Score:</span>8.56</div>'
      anime = AnimeScraper.scrape(html)
      anime.members_score.should be 8.56
    end

    it 'should be able to scrape popularity' do
      html = create_left_detail '<div><span>Popularity:</span>#1,350</div>'
      anime = AnimeScraper.scrape(html)
      anime.popularity_rank.should be 1350
    end

    it 'should be able to scrape members' do
      html = create_left_detail '<div><span>Members:</span>1,234</div>'
      anime = AnimeScraper.scrape(html)
      anime.members_count.should be 1234
    end

    it 'should be able to scrape favorites' do
      html = create_left_detail '<div><span>Favorites:</span>1,234</div>'
      anime = AnimeScraper.scrape(html)
      anime.favorited_count.should be 1234
    end
  end

  describe 'popular tags' do
    it 'should be able to scrape popular tags' do
      html = create_left_detail '<h2>Popular Tags</h2><span><a>comedy</a><a>horror</a></span>'
      anime = AnimeScraper.scrape(html)
      anime.tags.should eq %w(comedy horror)
    end
  end

  describe 'synopsis' do
    it 'should scrape single line synopsis' do
      html = create_right_detail '<h2>Synopsis</h2>This is my synopsis'
      anime = AnimeScraper.scrape(html)
      anime.synopsis.should eq 'This is my synopsis'
    end
  end

  def create_left_detail(html = '')
    "<input name='aid' value='1234' /><h1>Bleach<div>Ranked #450</div></h1>
      <div id='content'>
      <table>
      <tr><td class='borderClass'>
      #{html}
      </td></tr>
      </table>
      </div>"
  end

  def create_right_detail(html = '')
    "<input name='aid' value='1234' /><h1>Bleach <div>Ranked #450</div></h1>
      <div id='content'>
      <table>
      <tr><td><div><table>
#{html}</td></tr></div></table></table></div>"
  end
end