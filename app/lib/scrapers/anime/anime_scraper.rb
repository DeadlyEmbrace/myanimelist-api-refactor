class AnimeScraper
  def self.scrape(html)
    invalid_anime = html =~ /No series found/i
    anime = nil

    unless invalid_anime
      anime_page = Nokogiri::HTML(html)
      left_detail_content = anime_page.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')
      right_detail_content = anime_page.xpath('//div[@id="content"]/table/tr/td/div/table')
      date_range = parse_date_range left_detail_content

      anime = Anime.new({
        id: CommonScraper.scrape_id_input(anime_page, 'aid', %r{http://myanimelist.net/anime/(\d+)/.*?}),
        title: anime_page.at(:h1).children.find { |o| o.text? }.to_s,
        rank: anime_page.at('h1 > div').text.gsub(/\D/, '').to_i,
        image_url: parse_image_url(anime_page),
        other_titles: CommonScraper.parse_alternative_titles(left_detail_content),
        type: CommonScraper.scrape_statistic(left_detail_content.at('//span[text()="Type:"]')),
        status: CommonScraper.scrape_statistic(left_detail_content.at('//span[text()="Status:"]')),
        start_date: date_range[:start_date],
        end_date: date_range[:end_date],
        genres: CommonScraper.scrape_genres(left_detail_content),
        synopsis: CommonScraper.scrape_details_synopsis(right_detail_content),
        classification: CommonScraper.scrape_statistic(left_detail_content.at('//span[text()="Rating:"]'))
      })

      result = CommonScraper.scrape_statistic left_detail_content.at('//span[text()="Episodes:"]')
      anime.episodes = result.to_i unless result.nil?

      anime = parse_statistics anime, left_detail_content
      anime = parse_related_anime anime, anime_page
      anime = parse_my_info anime, anime_page
    end

    anime
  end

  private
    def self.parse_image_url(anime_page)
      image_url = nil

      if (image_node = anime_page.at('div#content tr td div img'))
        image_url = image_node['src']
      end

      image_url
    end

    def self.parse_date_range(left_detail_content)
      date_range = { start_date: nil, end_date: nil }

      if (node = left_detail_content.at('//span[text()="Aired:"]')) && node.next
        airdates_text = node.next.text.strip
        date_range = DateParser.parse_date_range airdates_text
      end

      date_range
    end

    def self.parse_statistics(anime, left_detail_content)
      result = CommonScraper.scrape_statistic left_detail_content.at('//span[text()="Score:"]')
      anime.members_score = result.to_f unless result.nil?

      result = CommonScraper.scrape_statistic left_detail_content.at('//span[text()="Popularity:"]')
      anime.popularity_rank = result.to_i unless result.nil?

      result = CommonScraper.scrape_statistic left_detail_content.at('//span[text()="Members:"]')
      anime.members_count = result.to_i unless result.nil?

      result = CommonScraper.scrape_statistic left_detail_content.at('//span[text()="Favorites:"]')
      anime.favorited_count = result.to_i unless result.nil?

      anime.tags = CommonScraper.scrape_popular_tags left_detail_content.at('//span[preceding-sibling::h2[text()="Popular Tags"]]')

      anime
    end

    def self.parse_related_anime(anime, anime_page)
      related_anime_h2 = anime_page.at('//h2[text()="Related Anime"]')
      if related_anime_h2

        # Get all text between <h2>Related Anime</h2> and the next <h2> tag.
        match_data = related_anime_h2.parent.to_s.match(%r{<h2>Related Anime</h2>(.+?)<h2>}m)

        if match_data
          related_anime_text = match_data[1]

          anime.manga_adaptations = CommonScraper.scrape_related_manga related_anime_text, %r{Adaptation: ?(<a .+?)<br}
          anime.prequels = CommonScraper.scrape_related_anime related_anime_text, %r{Prequel: ?(<a .+?)<br}
          anime.sequels = CommonScraper.scrape_related_anime related_anime_text, %r{Sequel: ?(<a .+?)<br}
          anime.side_stories = CommonScraper.scrape_related_anime related_anime_text, %r{Side story: ?(<a .+?)<br}
          anime.parent_story = CommonScraper.scrape_related_anime related_anime_text, %r{Parent story: ?(<a .+?)<br}
          anime.character_anime = CommonScraper.scrape_related_anime related_anime_text, %r{Character: ?(<a .+?)<br}
          anime.spin_offs = CommonScraper.scrape_related_anime related_anime_text, %r{Spin-off: ?(<a .+?)<br}
          anime.summaries = CommonScraper.scrape_related_anime related_anime_text, %r{Summary: ?(<a .+?)<br}
          anime.alternative_versions = CommonScraper.scrape_related_anime related_anime_text, %r{Alternative versions?: ?(<a .+?)<br}
        end
      end

      anime
    end

    def self.parse_my_info(anime, anime_page)
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

      anime
    end
end