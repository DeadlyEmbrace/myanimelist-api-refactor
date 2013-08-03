class MangaSearchScraper
  def self.scrape(html)
    manga_search_page = Nokogiri::HTML(html)
    manga = []

    search_results = manga_search_page.xpath('//div[@id="content"]/div[2]/table')
    search_results.search('tr').each do |search_result|
      manga_title_node = search_result.at('td a strong')
      next unless manga_title_node
      url = manga_title_node.parent['href']
      next unless url.match %r{http://myanimelist.net/manga/(\d+)/?.*}
      manga << parse_manga($1, search_result, manga_title_node)
    end

    manga
  end

  private
    def self.parse_manga(id, search_result, manga_title_node)
      manga_info = search_result.search('td')

      Manga.new({
        id: id.to_i,
        title: manga_title_node.text,
        image_url: parse_image_url(search_result),
        synopsis: CommonScraper.scrape_search_synopsis(search_result, 'div.spaceit_pad'),
        type: manga_info[2].text,
        volumes: manga_info[3].text.to_i,
        chapters: manga_info[4].text.to_i,
        members_score: manga_info[5].text.to_f,
      })
    end

    def self.parse_image_url(search_result)
      image_url = nil

      if (image_node = search_result.at('td a img'))
        image_url = image_node['src']
      end

      image_url
    end
end