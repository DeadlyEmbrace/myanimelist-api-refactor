describe ProfileScraper do
  before :each do
    @profile_scraper = ProfileScraper.new
  end

  describe 'invalid profile' do
    it 'should return a nil profile' do
      VCR.use_cassette('profile/invalid_profile') do
        response = HTTParty.get('http://myanimelist.net/profile/user_does_not_exist')
        profile = @profile_scraper.scrape(response.body)
        profile.should be_nil
      end
    end
  end

  describe 'complete profile' do
    before :each  do
      VCR.use_cassette('profile/valid_profile') do
        response = HTTParty.get('http://myanimelist.net/profile/astraldragon88')
        @profile = @profile_scraper.scrape(response.body)
      end
    end

    it 'should scrape a profile avatar' do
      @profile.avatar_url.should eq('http://cdn.myanimelist.net/images/userimages/128152.jpg')
    end

    it 'should scrape user details' do
      @profile.details.should eq({ birthday: 'September  4, 1988', location: 'Saint John, New Brunswick',
                                   website: 'http://www.google.ca', aim: 'myaim', msn: 'mymsn',
                                   yahoo: 'myyahoo', comments: 2, forum_posts: 33, last_online: 'Now',
                                   gender: 'Male', join_date: 'December 28, 2008', access_rank: 'Member',
                                   anime_list_views: 860, manga_list_views: 533 })
    end

    it 'should scrape anime stats' do
      @profile.anime_stats.should eq({ time_days: 61.2, watching: 4.0, completed: 263.0, on_hold: 9.0,
                                       dropped: 0.0, plan_to_watch: 211.0, total_entries: 487.0 })
    end

    it 'should scrape manga stats' do
      @profile.manga_stats.should eq({ time_days: 11.7, reading: 5.0, completed: 18.0, on_hold: 6.0,
                                       dropped: 0.0, plan_to_read: 68.0, total_entries: 97.0 })
    end
  end

  describe 'partial profile' do
    before :each do
      VCR.use_cassette('profile/partial_profile') do
        response = HTTParty.get('http://myanimelist.net/profile/partial_profile')
        @profile = @profile_scraper.scrape(response.body)
      end
    end

    it 'should have optional detail fields set to nil' do
      @profile.details.should eq({ birthday: nil, location: nil, website: nil, aim: nil, msn: nil,
                                   yahoo: nil, comments: 0, forum_posts: 0, last_online: 'Now',
                                   gender: 'Not specified', join_date: 'July 8, 2013', access_rank: 'Member',
                                   anime_list_views: 0, manga_list_views: 0 })
    end
  end
end