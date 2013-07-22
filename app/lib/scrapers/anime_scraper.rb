class AnimeScraper
  def self.scrape(html)
    invalid_anime = html =~ /No series found/i
    anime = nil

    unless invalid_anime
      anime_page = Nokogiri::HTML(html)
      left_detail_content = anime_page.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')
      right_detail_content = anime_page.xpath('//div[@id="content"]/table/tr/td/div/table')
      date_range = self.parse_date_range left_detail_content

      anime = Anime.new({
        id: self.parse_id(anime_page),
        title: anime_page.at(:h1).children.find { |o| o.text? }.to_s,
        rank: anime_page.at('h1 > div').text.gsub(/\D/, '').to_i,
        image_url: self.parse_image_url(anime_page),
        other_titles: self.parse_alternative_titles(left_detail_content),
        type: self.parse_generic(left_detail_content.at('//span[text()="Type:"]')),
        episodes: self.parse_episodes(left_detail_content),
        status: self.parse_generic(left_detail_content.at('//span[text()="Status:"]')),
        start_date: date_range[:start_date],
        end_date: date_range[:end_date],
        genres: self.parse_genres(left_detail_content),
        synopsis: self.parse_synopsis(right_detail_content),
        classification: self.parse_generic(left_detail_content.at('//span[text()="Rating:"]')),
      })

      # Statistics
      if (node = left_detail_content.at('//span[text()="Score:"]')) && node.next
        anime.members_score = node.next.text.strip.to_f
      end

      if (node = left_detail_content.at('//span[text()="Popularity:"]')) && node.next
        anime.popularity_rank = node.next.text.strip.sub('#', '').gsub(',', '').to_i
      end

      if (node = left_detail_content.at('//span[text()="Members:"]')) && node.next
        anime.members_count = node.next.text.strip.gsub(',', '').to_i
      end

      if (node = left_detail_content.at('//span[text()="Favorites:"]')) && node.next
        anime.favorited_count = node.next.text.strip.gsub(',', '').to_i
      end

      # Popular Tags
      if (node = left_detail_content.at('//span[preceding-sibling::h2[text()="Popular Tags"]]'))
        node.search('a').each do |a|
          anime.tags << a.text
        end
      end

      # Related Anime
      related_anime_h2 = anime_page.at('//h2[text()="Related Anime"]')
      if related_anime_h2

        # Get all text between <h2>Related Anime</h2> and the next <h2> tag.
        match_data = related_anime_h2.parent.to_s.match(%r{<h2>Related Anime</h2>(.+?)<h2>}m)

        if match_data
          related_anime_text = match_data[1]

          if related_anime_text.match %r{Adaptation: ?(<a .+?)<br}
            $1.scan(%r{<a href="(http://myanimelist.net/manga/(\d+)/.*?)">(.+?)</a>}) do |url, manga_id, title|
              anime.manga_adaptations << {
                  :manga_id => manga_id,
                  :title => title,
                  :url => url
              }
            end
          end

          if related_anime_text.match %r{Prequel: ?(<a .+?)<br}
            $1.scan(%r{<a href="(http://myanimelist.net/anime/(\d+)/.*?)">(.+?)</a>}) do |url, anime_id, title|
              anime.prequels << {
                  :anime_id => anime_id,
                  :title => title,
                  :url => url
              }
            end
          end

          if related_anime_text.match %r{Sequel: ?(<a .+?)<br}
            $1.scan(%r{<a href="(http://myanimelist.net/anime/(\d+)/.*?)">(.+?)</a>}) do |url, anime_id, title|
              anime.sequels << {
                  :anime_id => anime_id,
                  :title => title,
                  :url => url
              }
            end
          end

          if related_anime_text.match %r{Side story: ?(<a .+?)<br}
            $1.scan(%r{<a href="(http://myanimelist.net/anime/(\d+)/.*?)">(.+?)</a>}) do |url, anime_id, title|
              anime.side_stories << {
                  :anime_id => anime_id,
                  :title => title,
                  :url => url
              }
            end
          end

          if related_anime_text.match %r{Parent story: ?(<a .+?)<br}
            $1.scan(%r{<a href="(http://myanimelist.net/anime/(\d+)/.*?)">(.+?)</a>}) do |url, anime_id, title|
              anime.parent_story = {
                  :anime_id => anime_id,
                  :title => title,
                  :url => url
              }
            end
          end

          if related_anime_text.match %r{Character: ?(<a .+?)<br}
            $1.scan(%r{<a href="(http://myanimelist.net/anime/(\d+)/.*?)">(.+?)</a>}) do |url, anime_id, title|
              anime.character_anime << {
                  :anime_id => anime_id,
                  :title => title,
                  :url => url
              }
            end
          end

          if related_anime_text.match %r{Spin-off: ?(<a .+?)<br}
            $1.scan(%r{<a href="(http://myanimelist.net/anime/(\d+)/.*?)">(.+?)</a>}) do |url, anime_id, title|
              anime.spin_offs << {
                  :anime_id => anime_id,
                  :title => title,
                  :url => url
              }
            end
          end

          if related_anime_text.match %r{Summary: ?(<a .+?)<br}
            $1.scan(%r{<a href="(http://myanimelist.net/anime/(\d+)/.*?)">(.+?)</a>}) do |url, anime_id, title|
              anime.summaries << {
                  :anime_id => anime_id,
                  :title => title,
                  :url => url
              }
            end
          end

          if related_anime_text.match %r{Alternative versions?: ?(<a .+?)<br}
            $1.scan(%r{<a href="(http://myanimelist.net/anime/(\d+)/.*?)">(.+?)</a>}) do |url, anime_id, title|
              anime.alternative_versions << {
                  :anime_id => anime_id,
                  :title => title,
                  :url => url
              }
            end
          end
        end
      end

      # My Info
      watched_status_select_node = anime_page.at('select#myinfo_status')
      if watched_status_select_node && (selected_option = watched_status_select_node.at('option[selected="selected"]'))
        anime.watched_status = selected_option['value']
      end
      episodes_input_node = anime_page.at('input#myinfo_watchedeps')
      if episodes_input_node
        anime.watched_episodes = episodes_input_node['value'].to_i
      end
      score_select_node = anime_page.at('select#myinfo_score')
      if score_select_node && (selected_option = score_select_node.at('option[selected="selected"]'))
        anime.score = selected_option['value'].to_i
      end
      listed_anime_id_node = anime_page.at('//a[text()="Edit Details"]')
      if listed_anime_id_node
        anime.listed_anime_id = listed_anime_id_node['href'].match('id=(\d+)')[1].to_i
      end
    end

    anime
  end

  private
    def self.parse_id(anime_page)
      anime_id_input = anime_page.at('input[@name="aid"]')
      if anime_id_input
        anime_id_input['value'].to_i
      else
        details_link = anime_page.at('//a[text()="Details"]')
        details_link['href'][%r{http://myanimelist.net/anime/(\d+)/.*?}, 1].to_i
      end
    end

    def self.parse_alternative_titles(left_detail_content)
      alternative_titles = {}

      if (node = left_detail_content.at('//span[text()="English:"]')) && node.next
        alternative_titles[:english] = node.next.text.strip.split(/,\s?/)
      end

      if (node = left_detail_content.at('//span[text()="Synonyms:"]')) && node.next
        alternative_titles[:synonyms] = node.next.text.strip.split(/,\s?/)
      end

      if (node = left_detail_content.at('//span[text()="Japanese:"]')) && node.next
        alternative_titles[:japanese] = node.next.text.strip.split(/,\s?/)
      end

      alternative_titles
    end

    def self.parse_image_url(anime_page)
      image_url = nil

      if (image_node = anime_page.at('div#content tr td div img'))
        image_url = image_node['src']
      end

      image_url
    end

    def self.parse_episodes(left_detail_content)
      episodes = nil

      if (node = left_detail_content.at('//span[text()="Episodes:"]')) && node.next
        episodes = node.next.text.strip.gsub(',', '').to_i
        episodes = nil if episodes == 0
      end

      episodes
    end

    def self.parse_genres(left_detail_content)
      genres = []

      if (node = left_detail_content.at('//span[text()="Genres:"]'))
        node.parent.search('a').each do |a|
          genres << a.text.strip
        end
      end

      genres
    end

    def self.parse_synopsis(right_detail_content)
      synopsis = nil
      synopsis_h2 = right_detail_content.at('//h2[text()="Synopsis"]')

      if synopsis_h2
        node = synopsis_h2.next
        while node
          if synopsis
            synopsis << node.to_s
          else
            synopsis = node.to_s
          end

          node = node.next
        end
      end

      synopsis
    end

    def self.parse_date_range(left_detail_content)
      date_range = { start_date: nil, end_date: nil }

      if (node = left_detail_content.at('//span[text()="Aired:"]')) && node.next
        airdates_text = node.next.text.strip
        date_range = DateParser.parse_date_range airdates_text
      end

      date_range
    end

    def self.parse_generic(node)
      result = nil

      if node && node.next
        result = node.next.text.strip
      end

      result
    end
end