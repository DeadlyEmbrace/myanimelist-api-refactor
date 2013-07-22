class AnimeSearchScraper
  def self.scrape(html)
    anime_search_page = Nokogiri::HTML(html)
    animes = []

    search_results = anime_search_page.xpath('//div[@id="content"]/div[2]/table')
    search_results.search('tr').each do |search_result|
      anime_title_node = search_result.at('td a strong')
      next unless anime_title_node
      url = anime_title_node.parent['href']
      next unless url.match %r{http://myanimelist.net/anime/(\d+)/?.*}
      animes << self.parse_anime($1, search_result, anime_title_node)
    end

    animes
  end

  private
    def self.parse_anime(id, search_result, anime_title_node)
      anime_info = search_result.search('td')
      classification = nil
      classification = anime_info[8].text if anime_info[8] and not anime_info[8].text.empty?

      Anime.new({
        id: id.to_i,
        title: anime_title_node.text,
        image_url: self.parse_image_url(search_result),
        synopsis: self.parse_synopsis(search_result),
        type: anime_info[2].text,
        episodes: anime_info[3].text.to_i,
        members_score: anime_info[4].text.to_f,
        start_date: DateParser.parse_date(anime_info[5].text),
        end_date: DateParser.parse_date(anime_info[6].text),
        classification: classification
      })
    end

    def self.parse_image_url(search_result)
      image_url = nil

      if (image_node = search_result.at('td a img'))
        image_url = image_node['src']
      end

      image_url
    end

    def self.parse_synopsis(search_result)
      synopsis = nil
      synopsis_node = search_result.at('div.spaceit')

      if synopsis_node
        synopsis_node.search('a').remove
        synopsis = synopsis_node.text.strip
      end

      synopsis
    end
end