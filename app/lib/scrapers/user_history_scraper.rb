class UserHistoryScraper
  def self.scrape(html)
    invalid_user = html =~ /Invalid member/i
    history = nil

    unless invalid_user
      history = []

      history_page = Nokogiri::HTML(html)
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

        # TODO - date parsing should be investigated
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
    end

    history
  end
end