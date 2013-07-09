class AnimeScraper
  def scrape(html)
    invalid_anime = html =~ /No series found/i
    anime = nil

    unless invalid_anime
      anime_page = Nokogiri::HTML(html)
      anime = Anime.new

      anime_id_input = anime_page.at('input[@name="aid"]')
      if anime_id_input
        anime.id = anime_id_input['value'].to_i
      else
        details_link = anime_page.at('//a[text()="Details"]')
        anime.id = details_link['href'][%r{http://myanimelist.net/anime/(\d+)/.*?}, 1].to_i
      end
    end

    anime
  end
end