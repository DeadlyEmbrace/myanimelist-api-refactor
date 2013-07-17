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

      anime = Anime.new
      anime.id = $1.to_i
      anime.title = anime_title_node.text

      if (image_node = search_result.at('td a img'))
        anime.image_url = image_node['src']
      end

      synopsis_node = search_result.at('div.spaceit')
      if synopsis_node
        synopsis_node.search('a').remove
        anime.synopsis = synopsis_node.text.strip
      end

      anime_info = search_result.search('td')
      anime.type = anime_info[2].text
      anime.episodes = anime_info[3].text.to_i
      anime.members_score = anime_info[4].text.to_f
      anime.start_date = DateParser.parse_date(anime_info[5].text)
      anime.end_date = DateParser.parse_date(anime_info[6].text)
      anime.classification = anime_info[8].text if anime_info[8] and not anime_info[8].text.empty?

      animes << anime
    end

    animes
  end
end