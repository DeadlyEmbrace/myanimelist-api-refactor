class TopAnimeScraper
  def self.scrape(html)
    top_anime_page = Nokogiri::HTML(html)
    top_anime = []

    top_anime_page.search('div#content table tr').each do |search_result|
      anime_title_node = search_result.at('td a strong')
      next unless anime_title_node
      anime_url = anime_title_node.parent['href']
      next unless anime_url
      anime_url.match %r{http://myanimelist.net/anime/(\d+)/?.*}
      top_anime << parse_anime($1, search_result, anime_title_node)
    end

    top_anime
  end

  private

    def self.parse_anime(id, search_result, anime_title_node)
      table_cell_nodes = search_result.search('td')
      content_cell = table_cell_nodes.at('div.spaceit_pad')
      members_count = parse_members_count(content_cell.at('span.lightLink'))
      stats = content_cell.text.strip.split(',')

      Anime.new({
        id: id.to_i,
        title: anime_title_node.text,
        type: stats[0],
        image_url: parse_image_url(search_result),
        members_count: members_count,
        members_score: stats[2].match(/\d+(\.\d+)?/).to_s.to_f,
        episodes: parse_episodes(stats[1])
      })
    end

    def self.parse_image_url(search_result)
      image_url = nil

      if (image_node = search_result.at('td a img'))
        image_url = image_node['src']
      end

      image_url
    end

    def self.parse_members_count(members_cell)
      members = members_cell.text.strip.gsub!(/\D/, '').to_i
      members_cell.remove
      members
    end

    def self.parse_episodes(episode_stats)
      episodes = episode_stats.gsub!(/\D/, '')
      episodes.to_i unless episodes.size <= 0
    end
end