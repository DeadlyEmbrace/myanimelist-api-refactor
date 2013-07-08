class Profile
  attr_accessor :avatar_url, :details, :anime_stats, :manga_stats

  def initialize
    @avatar_url = nil

    @details = {
        birthday: nil,
        location: nil,
        website: nil,
        aim: nil,
        msn: nil,
        yahoo: nil,
        comments: 0,
        forum_posts: 0,
        last_online: nil,
        gender: nil,
        join_date: nil,
        access_rank: nil,
        anime_list_views: 0,
        manga_list_views: 0
    }

    @anime_stats = {
        time_days: 0,
        watching: 0,
        completed: 0,
        on_hold: 0,
        dropped: 0,
        plan_to_watch: 0,
        total_entries: 0
    }

    @manga_stats = {
        time_days: 0,
        reading: 0,
        completed: 0,
        on_hold: 0,
        dropped: 0,
        plan_to_read: 0,
        total_entries: 0
    }
  end
end