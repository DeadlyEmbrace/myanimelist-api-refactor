class UserHistoryScraper
  def scrape(html)
    history_page = Nokogiri::HTML(html)
    invalid_user = history_page.at('h1:contains("Invalid")')
    history = nil

    if invalid_user.nil?
      history = []
    end

    history_page.search('div#content table tr').each do |tr|
      cells = tr.search('td')
      next unless cells && cells.size == 2

      link = cells[0].at('a')
      anime_id = link['href'][%r{http://myanimelist.net/anime.php\?id=(\d+)}, 1]
      anime_id = link['href'][%r{http://myanimelist.net/anime/(\d+)/?.*}, 1] unless anime_id
      anime_id = anime_id.to_i

      manga_id = link['href'][%r{http://myanimelist.net/manga.php\?id=(\d+)}, 1]
      manga_id = link['href'][%r{http://myanimelist.net/manga/(\d+)/?.*}, 1] unless manga_id
      manga_id = manga_id.to_i

      title = link.text.strip
      episode_or_chapter = cells[0].at('strong').text.to_i

      # TODO - date parsing should be checked out
      #time = Chronic.parse(cells[1].text.strip)

      history << Hash.new.tap do |history_entry|
        history_entry[:anime_id] = anime_id if anime_id > 0
        history_entry[:episode] = episode_or_chapter if anime_id > 0
        history_entry[:manga_id] = manga_id if manga_id > 0
        history_entry[:chapter] = episode_or_chapter if manga_id > 0
        history_entry[:title] = title
        #history_entry[:time] = time
      end
    end

    history
  end
end