class AnimeListScraper
  def self.scrape(xml)
    invalid_anime_list = xml =~ /invalid username/i
    anime_list = nil

    unless invalid_anime_list
      anime_list_xml = Nokogiri::XML.parse(xml)
      anime_list = AnimeList.new

      anime_list_xml.search('anime').each do |anime_node|
        anime_list.anime << self.parse_anime(anime_node)
      end

      anime_list.statistics[:days] = anime_list_xml.at('myinfo user_days_spent_watching').text.to_f
    end

    anime_list
  end

  private
    def self.parse_anime(anime_node)
      Anime.new({
        id: anime_node.at('series_animedb_id').text.to_i,
        title: anime_node.at('series_title').text,
        type: anime_node.at('series_type').text,
        status: anime_node.at('series_status').text,
        episodes: anime_node.at('series_episodes').text.to_i,
        image_url: anime_node.at('series_image').text,
        listed_anime_id: anime_node.at('my_id').text.to_i,
        watched_episodes: anime_node.at('my_watched_episodes').text.to_i,
        score: anime_node.at('my_score').text.to_i,
        watched_status: anime_node.at('my_status').text
      })
    end
end