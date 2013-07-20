class TopAnimeScraper
  def self.scrape(html)
    top_anime_page = Nokogiri::HTML(html)
    top_anime = []

    top_anime_page.search('div#content table tr').each do |results_row|
      anime_title_node = results_row.at('td a strong')
      next unless anime_title_node
      anime_url = anime_title_node.parent['href']
      next unless anime_url
      anime_url.match %r{http://myanimelist.net/anime/(\d+)/?.*}

      anime = Anime.new
      anime.id = $1.to_i
      anime.title = anime_title_node.text

      table_cell_nodes = results_row.search('td')
      content_cell = table_cell_nodes.at('div.spaceit_pad')

      members_cell = content_cell.at('span.lightLink')
      members = members_cell.text.strip.gsub!(/\D/, '').to_i
      members_cell.remove

      stats = content_cell.text.strip.split(',')
      type = stats[0]
      episodes = stats[1].gsub!(/\D/, '')
      members_score = stats[2].match(/\d+(\.\d+)?/).to_s.to_f

      anime.type = type
      anime.episodes = episodes.to_i unless episodes.size <= 0
      anime.members_count = members
      anime.members_score = members_score

      if (image_node = results_row.at('td a img'))
        anime.image_url = image_node['src']
      end

      top_anime << anime
    end

    top_anime
  end
end