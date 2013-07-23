class MangaListScraper
  def self.scrape(xml)
    invalid_manga_list = xml =~ /invalid username/i
    manga_list = nil

    unless invalid_manga_list
      manga_list_xml = Nokogiri::XML.parse(xml)
      manga_list = MangaList.new


      manga_list_xml.search('manga').each do |manga_node|
        manga_list.manga << self.parse_manga(manga_node)
      end
    end

    manga_list
  end

  private
    def self.parse_manga(manga_node)
      Manga.new({
        id: manga_node.at('series_mangadb_id').text.to_i,
        title: manga_node.at('series_title').text,
        type: manga_node.at('series_type').text,
        status: manga_node.at('series_status').text,
        chapters: manga_node.at('series_chapters').text.to_i,
        volumes: manga_node.at('series_volumes').text.to_i,
        image_url: manga_node.at('series_image').text,
        listed_manga_id: manga_node.at('my_id').text.to_i,
        volumes_read: manga_node.at('my_read_volumes').text.to_i,
        chapters_read: manga_node.at('my_read_chapters').text.to_i,
        score: manga_node.at('my_score').text.to_i,
        read_status: manga_node.at('my_status').text
      })
    end
end