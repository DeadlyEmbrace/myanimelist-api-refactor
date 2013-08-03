class MangaScraper
  def self.scrape(html)
    invalid_manga = html =~ /No manga found/i
    manga = nil

    unless invalid_manga
      manga_page = Nokogiri::HTML html
      left_detail_content = manga_page.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')
      right_detail_content = manga_page.xpath('//div[@id="content"]/table/tr/td/div/table')

      manga = Manga.new({
        id: CommonScraper.scrape_id_input(manga_page, 'mid', %r{http://myanimelist.net/manga/(\d+)/.*?}),
        title: manga_page.at(:h1).children.find { |o| o.text? }.to_s.strip,
        rank: manga_page.at('h1 > div').text.gsub(/\D/, '').to_i,
        image_url: parse_image_url(manga_page),
        other_titles:  parse_alternative_titles(left_detail_content),
        type: CommonScraper.scrape_statistic(left_detail_content.at('//span[text()="Type:"]')),
        status: CommonScraper.scrape_statistic(left_detail_content.at('//span[text()="Status:"]')),
        genres: CommonScraper.scrape_genres(left_detail_content),
        synopsis: CommonScraper.scrape_details_synopsis(right_detail_content)
      })

      result = CommonScraper.scrape_statistic left_detail_content.at('//span[text()="Volumes:"]')
      manga.volumes = result.to_i unless result.nil?

      result = CommonScraper.scrape_statistic left_detail_content.at('//span[text()="Chapters:"]')
      manga.chapters = result.to_i unless result.nil?

      # Statistics
      result = CommonScraper.scrape_statistic left_detail_content.at('//span[text()="Score:"]')
      manga.members_score = result.to_f unless result.nil?

      result = CommonScraper.scrape_statistic left_detail_content.at('//span[text()="Popularity:"]')
      manga.popularity_rank = result.to_i unless result.nil?

      result = CommonScraper.scrape_statistic left_detail_content.at('//span[text()="Members:"]')
      manga.members_count = result.to_i unless result.nil?

      result = CommonScraper.scrape_statistic left_detail_content.at('//span[text()="Favorites:"]')
      manga.favorited_count = result.to_i unless result.nil?

      manga.tags = CommonScraper.scrape_popular_tags left_detail_content.at('//span[preceding-sibling::h2[text()="Popular Tags"]]')

      # Related Manga
      related_manga_h2 = right_detail_content.at('//h2[text()="Related Manga"]')
      if related_manga_h2

        # Get all text between <h2>Related Manga</h2> and the next <h2> tag.
        match_data = related_manga_h2.parent.to_s.match(%r{<h2>Related Manga</h2>(.+?)<h2>}m)

        if match_data
          related_anime_text = match_data[1]

          if related_anime_text.match %r{Adaptation: ?(<a .+?)<br}
            $1.scan(%r{<a href="(http://myanimelist.net/anime/(\d+)/.*?)">(.+?)</a>}) do |url, anime_id, title|
              manga.anime_adaptations << {
                  :anime_id => anime_id,
                  :title => title,
                  :url => url
              }
            end
          end

          if related_anime_text.match %r{.+: ?(<a .+?)<br}
            $1.scan(%r{<a href="(http://myanimelist.net/manga/(\d+)/.*?)">(.+?)</a>}) do |url, manga_id, title|
              manga.related_manga << {
                  :manga_id => manga_id,
                  :title => title,
                  :url => url
              }
            end
          end

          if related_anime_text.match %r{Alternative versions?: ?(<a .+?)<br}
            $1.scan(%r{<a href="(http://myanimelist.net/manga/(\d+)/.*?)">(.+?)</a>}) do |url, manga_id, title|
              manga.alternative_versions << {
                  :manga_id => manga_id,
                  :title => title,
                  :url => url
              }
            end
          end
        end
      end

      # My Info
      read_status_select_node = manga_page.at('select#myinfo_status')
      if read_status_select_node && (selected_option = read_status_select_node.at('option[selected="selected"]'))
        manga.read_status = selected_option['value']
      end
      chapters_node = manga_page.at('input#myinfo_chapters')
      if chapters_node
        manga.chapters_read = chapters_node['value'].to_i
      end
      volumes_node = manga_page.at('input#myinfo_volumes')
      if volumes_node
        manga.volumes_read = volumes_node['value'].to_i
      end
      score_select_node = manga_page.at('select#myinfo_score')
      if score_select_node && (selected_option = score_select_node.at('option[selected="selected"]'))
        manga.score = selected_option['value'].to_i
      end
      listed_manga_id_node = manga_page.at('//a[text()="Edit Details"]')
      if listed_manga_id_node
        manga.listed_manga_id = listed_manga_id_node['href'].match('id=(\d+)')[1].to_i
      end
    end

    manga
  end

  private
    def self.parse_image_url(manga_page)
      image_url = nil

      if (image_node = manga_page.at('div#content tr td div img'))
        image_url = image_node['src']
      end

      image_url
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
end