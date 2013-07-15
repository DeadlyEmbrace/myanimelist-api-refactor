class ProfileScraper

  def self.scrape(html)
    invalid_user = html =~ /Invalid user/i
    profile = nil

    unless invalid_user
      profile = Profile.new

      profile_page = Nokogiri::HTML(html)
      page_content = profile_page.at('#content')
      left_profile_content = page_content.at('.profile_leftcell')
      main_profile_content = page_content.at('#horiznav_nav').next_element

      details = main_profile_content.at('div.normal_header:contains("Details")').next_element
      anime_stats = main_profile_content.at('h2:contains("Anime Stats")').next_element
      manga_stats = main_profile_content.at('h2:contains("Manga Stats")').next_element

      profile.avatar_url = left_profile_content.at("#profileRows").previous_element.at('img')['src']
      profile.details = scrape_details(profile.details, details)
      profile.anime_stats = self.scrape_stats(profile.anime_stats, anime_stats)
      profile.manga_stats = self.scrape_stats(profile.manga_stats, manga_stats)
    end

    profile
  end

  private
    def self.scrape_details(details, details_node)
      details_node.search('tr').each do |tr|
        label, value = tr.search('> td')
        parameterized_label = label.text.downcase.gsub(/\s+/, '_').to_sym

        details[parameterized_label] = case parameterized_label
           when :anime_list_views, :manga_list_views, :comments
             value.text.to_i
           when :forum_posts
             value.text.match(/^[,0-9]+/)[0].to_i
           when :website
             value.at('a')['href']
           else
             value.text
         end
      end

      details
    end

    def self.scrape_stats(stats, stats_node)
      stats_node.search('tr').each do |tr|
        label, value, _ = tr.search('td')
        parameterized_label = label.text.downcase.gsub(/[\(\)]/, '').gsub(/\s+/, '_').to_sym
        stats[parameterized_label] = value.text.to_f
      end

      stats
    end
end