class Anime
  attr_accessor :id, :title, :rank, :popularity_rank, :image_url, :episodes, :classification,
                :members_score, :members_count, :favorited_count, :synopsis, :start_date, :end_date,
                :listed_anime_id, :parent_story, :type, :status, :genres, :tags, :other_titles,
                :manga_adaptations, :prequels, :sequels, :side_stories, :character_anime, :spin_offs,
                :summaries, :alternative_versions, :watched_episodes, :score, :watched_status

  def initialize
    @id, @title, @rank, @popularity_rank, @image_url, @episodes, @classification,
    @members_score, @members_count, @favorited_count, @synopsis, @start_date,
    @end_date, @listed_anime_id, @parent_story, @type, @status, @watched_episodes, @score,
    @watched_status = nil

    @other_titles = {}
    @genres, @tags, @manga_adaptations, @prequels, @sequels, @side_stories,
    @character_anime, @spin_offs, @summaries, @alternative_versions = Array.new(10) { [] }
  end

  def watched_status=(value)
    @watched_status = case value
      when /watching/i, '1', 1
        :watching
      when /completed/i, '2', 2
        :completed
      when /on-hold/i, /onhold/i, '3', 3
        :'on-hold'
      when /dropped/i, '4', 4
        :dropped
      when /plan to watch/i, /plantowatch/i, '6', 6
        :'plan to watch'
    end
  end

  def type=(value)
    @type = case value
      when /TV/i, '1', 1
        :TV
      when /OVA/i, '2', 2
        :OVA
      when /Movie/i, '3', 3
        :Movie
      when /Special/i, '4', 4
        :Special
      when /ONA/i, '5', 5
        :ONA
      when /Music/i, '6', 6
        :Music
    end
  end

  def status=(value)
    @status = case value
      when /currently airing/i, '1', 1
        :'currently airing'
      when /finished airing/i, '2', 2
        :'finished airing'
      when /not yet aired/i, '3', 3
        :'not yet aired'
    end
  end
end