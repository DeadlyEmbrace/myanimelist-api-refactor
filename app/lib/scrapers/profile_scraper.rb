class ProfileScraper

  def scrape(html)
    profile_page = Nokogiri::HTML(html)
    invalid_user = profile_page.at('h1:contains("Invalid user")')

    profile = nil

    if invalid_user.nil?
      profile = Profile.new

      page_content = profile_page.at('#content')
      left_profile_content = page_content.at('.profile_leftcell')
      main_profile_content = page_content.at('#horiznav_nav').next_element
      details, updates, anime_stats, manga_stats = main_profile_content.search('> table table')

      profile.avatar_url = left_profile_content.at("#profileRows").previous_element.at('img')['src']
      profile.details = scrape_details(profile.details, details)
      profile.anime_stats = scrape_stats(profile.anime_stats, anime_stats)
      profile.manga_stats = scrape_stats(profile.manga_stats, manga_stats)
    end

    profile
  end

  private
    def scrape_details(details, details_node)
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

    def scrape_stats(stats, stats_node)
      stats_node.search('tr').each do |tr|
        label, value, _ = tr.search('td')
        parameterized_label = label.text.downcase.gsub(/[\(\)]/, '').gsub(/\s+/, '_').to_sym
        stats[parameterized_label] = value.text.to_f
      end

      stats
    end
end