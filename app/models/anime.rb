class Anime
  attr_accessor :id, :title, :rank, :popularity_rank, :image_url, :episodes, :classification,
                :members_score, :members_count, :favorited_count, :synopsis, :start_date, :end_date,
                :listed_anime_id, :parent_story, :type, :status, :genres, :tags, :other_titles,
                :manga_adaptations, :prequels, :sequels, :side_stories, :character_anime, :spin_offs,
                :summaries, :alternative_versions, :watched_episodes, :score, :watched_status

  def initialize
    # TODO: Not sure if this is the best way to do this, but I need to set them
    # so they are returned in json result.
    @id, @title, @rank, @popularity_rank, @image_url, @episodes, @classification,
    @members_score, @members_count, @favorited_count, @synopsis, @start_date,
    @end_date, @listed_anime_id, @parent_story, @type, @status, @watched_episodes, @score,
    @watched_status = nil

    @other_titles = {}
    @genres, @tags, @manga_adaptations, @prequels, @sequels, @side_stories,
    @character_anime, @spin_offs, @summaries, @alternative_versions = []
  end
end