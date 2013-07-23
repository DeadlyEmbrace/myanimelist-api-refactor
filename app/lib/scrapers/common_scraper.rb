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

  def self.scrape_synopsis(right_detail_content)
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
end