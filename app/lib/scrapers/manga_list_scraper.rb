class MangaListScraper
  def self.scrape(xml)
    invalid_manga_list = xml =~ /invalid username/i
    manga_list = nil

    unless invalid_manga_list
      manga_list_xml = Nokogiri::XML.parse(xml)
      manga_list = MangaList.new

      manga_list.manga = manga_list_xml.search('manga').map do |manga_node|
        manga = Manga.new
        manga.id = manga_node.at('series_mangadb_id').text.to_i
        manga.title = manga_node.at('series_title').text
        manga.type = manga_node.at('series_type').text
        manga.status = manga_node.at('series_status').text
        manga.chapters = manga_node.at('series_chapters').text.to_i
        manga.volumes = manga_node.at('series_volumes').text.to_i
        manga.image_url = manga_node.at('series_image').text
        manga.listed_manga_id = manga_node.at('my_id').text.to_i
        manga.volumes_read = manga_node.at('my_read_volumes').text.to_i
        manga.chapters_read = manga_node.at('my_read_chapters').text.to_i
        manga.score = manga_node.at('my_score').text.to_i
        manga.read_status = manga_node.at('my_status').text

        manga
      end
    end

    manga_list
  end
end