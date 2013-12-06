#!/bin/env ruby
# encoding: utf-8

describe MangaScraper do
  describe 'invalid manga' do
    it 'should return nil' do
      VCR.use_cassette('manga/invalid_manga') do
        response = HTTParty.get('http://myanimelist.net/manga/1231313213131231')
        manga = MangaScraper.scrape(response.body)
        manga.should be_nil
      end
    end
  end

  describe 'id' do
    it 'should be able to scrape id out of mid textbox' do
      html = create_left_detail
      manga = MangaScraper.scrape html
      manga.id.should be 1234
    end

    it 'should be able to scrape id out of details link' do
      html = "<a href='http://myanimelist.net/manga/1234/Bleach/'>Details</a>
      <h1>Bleach <div>Ranked #450</div></h1>
      <div id='content'>
      <table>
      <tr><td class='borderClass'>
      </td></tr>
      </table>
      </div>"

      manga = MangaScraper.scrape html
      manga.id.should be 1234
    end
  end

  describe 'title' do
    it 'should be able to scrape title' do
      html = create_left_detail
      manga = MangaScraper.scrape html
      manga.title.should eq 'Bleach'
    end
  end

  describe 'rank' do
    it 'should be able to scrape rank' do
      html = create_left_detail
      manga = MangaScraper.scrape html
      manga.rank.should be 450
    end
  end

  describe 'image url' do
    it 'should be able to scrape no image url' do
      html = create_left_detail
      manga = MangaScraper.scrape html
      manga.image_url.should be_nil
    end

    it 'should be able to scrape image url' do
      expected = 'http://cdn.myanimelist.net/images/anime/3/20349.jpg'
      html = create_left_detail "<div><img src='#{expected}' /></div>"
      manga = MangaScraper.scrape html
      manga.image_url.should eq expected
    end
  end

  describe 'alternative titles' do
    it 'should be able to handle no alternative titles' do
      html = create_left_detail
      manga = MangaScraper.scrape html
      manga.other_titles.should be_empty
    end

    it 'should be able to english titles' do
      html = create_left_detail '<div><span>English:</span> Bleach, Bleach 2</div>'
      manga = MangaScraper.scrape html
      manga.other_titles.should eq({ english: ['Bleach', 'Bleach 2'] })
    end

    it 'should be able to scrape synonym titles' do
      html = create_left_detail '<div><span>Synonyms:</span> Bleach 2, Bleach 3</div>'
      manga = MangaScraper.scrape html
      manga.other_titles.should eq({ synonyms: ['Bleach 2', 'Bleach 3'] })
    end

    it 'should be able to scrape japanese titles' do
      html = create_left_detail '<div><span>Japanese:</span> ブリーチ, ブリー</div>'
      manga = MangaScraper.scrape html
      manga.other_titles.should eq({ japanese: %w(ブリーチ ブリー)})
    end
  end

  describe 'information' do
    it 'should be able to scrape type' do
      html = create_left_detail '<div><span>Type:</span> Manga</div>'
      manga = MangaScraper.scrape html
      manga.type.should be :Manga
    end

    it 'should be able to scrape volumes' do
      html = create_left_detail '<div><span>Volumes:</span> 3</div>'
      manga = MangaScraper.scrape html
      manga.volumes.should be 3
    end

    it 'should be able to scrape ? volumes' do
      html = create_left_detail '<div><span>Volumes:</span> ?</div>'
      manga = MangaScraper.scrape html
      manga.volumes.should be_nil
    end

    it 'should be able to scrape chapters' do
      html = create_left_detail '<div><span>Chapters:</span> 300</div>'
      manga = MangaScraper.scrape html
      manga.chapters.should be 300
    end

    it 'should be able to scrape ? chapters' do
      html = create_left_detail '<div><span>Chapters:</span> ?</div>'
      manga = MangaScraper.scrape html
      manga.chapters.should be_nil
    end

    it 'should be able to scrape status' do
      html = create_left_detail '<div><span>Status:</span> Publishing</div>'
      manga = MangaScraper.scrape html
      manga.status.should be :publishing
    end

    it 'should be able to scrape genres' do
      html = create_left_detail '<div><span>Genres:</span><a>comedy</a><a>horror</a></div>'
      manga = MangaScraper.scrape html
      manga.genres.should eq %w(comedy horror)
    end
  end

  describe 'statistics' do
    it 'should be able to scrape score' do
      html = create_left_detail '<div><span>Score:</span>8.56</div>'
      manga = MangaScraper.scrape html
      manga.members_score.should eq 8.56
    end

    it 'should be able to scrape popularity' do
      html = create_left_detail '<div><span>Popularity:</span>#1,350</div>'
      manga = MangaScraper.scrape html
      manga.popularity_rank.should be 1350
    end

    it 'should be able to scrape members' do
      html = create_left_detail '<div><span>Members:</span>1,234</div>'
      manga = MangaScraper.scrape html
      manga.members_count.should be 1234
    end

    it 'should be able to scrape favorites' do
      html = create_left_detail '<div><span>Favorites:</span>1,234</div>'
      manga = MangaScraper.scrape html
      manga.favorited_count.should be 1234
    end
  end

  describe 'popular tags' do
    it 'should be able to scrape popular tags' do
      html = create_left_detail '<h2>Popular Tags</h2><span><a>comedy</a><a>horror</a></span>'
      manga = MangaScraper.scrape html
      manga.tags.should eq %w(comedy horror)
    end
  end

  describe 'synopsis' do
    it 'should scrape single line synopsis' do
      html = create_right_detail '<h2>Synopsis</h2>This is my synopsis'
      manga = MangaScraper.scrape html
      manga.synopsis.should eq 'This is my synopsis'
    end
  end

  def create_left_detail(html = '')
    "<input name='mid' value='1234' /><h1>Bleach<div>Ranked #450</div></h1>
      <div id='content'>
      <table>
      <tr><td class='borderClass'>
      #{html}
      </td></tr>
      </table>
      </div>"
  end

  def create_right_detail(html = '')
    "<input name='mid' value='1234' /><h1>Bleach <div>Ranked #450</div></h1>
      <div id='content'>
      <table>
      <tr><td><div><table>
#{html}</td></tr></div></table></table></div>"
  end
end