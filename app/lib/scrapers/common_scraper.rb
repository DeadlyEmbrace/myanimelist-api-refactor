class CommonScraper

  def self.scrape_id_input(page, input_id, matching_expression)
    id_input = page.at("input[@name='#{input_id}']")
    if id_input
      id_input['value'].to_i
    else
      details_link = page.at('//a[text()="Details"]')
      details_link['href'][matching_expression, 1].to_i
    end
  end

  def self.scrape_genres(left_detail_content)
    genres = []

    if (node = left_detail_content.at('//span[text()="Genres:"]'))
      node.parent.search('a').each do |a|
        genres << a.text.strip
      end
    end

    genres
  end

  def self.scrape_statistic(node)
    result = nil

    if node && node.next
      result = node.next.text.strip.gsub(/[#,\?]/, '')
      result = nil if result.empty?
    end

    result
  end

  def self.scrape_popular_tags(node)
    result = []

    unless node.nil?
      node.search('a').each do |tag|
        result << tag.text
      end
    end

    result
  end

  def self.scrape_details_synopsis(right_detail_content)
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

  def self.scrape_search_synopsis(search_result, synopsis_class)
    synopsis = nil
    synopsis_node = search_result.at(synopsis_class)

    if synopsis_node
      synopsis_node.search('a').remove
      synopsis = synopsis_node.text.strip
    end

    synopsis
  end

  def self.scrape_related_anime(related_anime_text, expression)
    results = []

    if related_anime_text.match expression
      $1.scan(%r{<a href="(http://myanimelist.net/anime/(\d+)/.*?)">(.+?)</a>}) do |url, anime_id, title|
        results << {
          :anime_id => anime_id,
          :title => title,
          :url => url
        }
      end
    end

    results
  end

  def self.scrape_related_manga(related_manga_text, expression)
    if related_manga_text.match expression
      $1.scan(%r{<a href="(http://myanimelist.net/manga/(\d+)/.*?)">(.+?)</a>}) do |url, manga_id, title|
        manga.related_manga << {
          :manga_id => manga_id,
          :title => title,
          :url => url
        }
      end
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
end