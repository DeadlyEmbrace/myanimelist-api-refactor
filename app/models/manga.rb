class Manga
  attr_accessor :id, :title, :rank, :popularity_rank, :image_url, :volumes, :chapters,
                :members_score, :members_count, :favorited_count, :synopsis,
                :listed_manga_id, :type, :status, :genres, :tags, :other_titles,
                :anime_adaptations, :related_manga, :alternative_versions,
                :volumes_read, :chapters_read, :score, :read_status

  def initialize
    @id, @title, @rank, @popularity_rank, @image_url, @volumes, @chapters,
    @members_score, @members_count, @favorited_count, @synopsis,
    @listed_manga_id, @type, @status, @genres, @tags, @other_titles,
    @anime_adaptations, @related_manga, @alternative_versions,
    @volumes_read, @chapters_read, @score, @read_status = nil

    @other_titles = {}
    @genres, @tags, @anime_adaptations, @related_manga,
    @alternative_versions = Array.new(5) { [] }
  end

  def read_status=(value)
    @read_status = case value
      when /reading/i, '1', 1
       :reading
      when /completed/i, '2', 2
       :completed
      when /on-hold/i, /onhold/i, '3', 3
       :'on-hold'
      when /dropped/i, '4', 4
       :dropped
      when /plan/i, '6', 6
       :'plan to read'
    end
  end

  def type=(value)
    @type = case value
      when /manga/i, '1', 1
        :Manga
      when /novel/i, '2', 2
        :Novel
      when /one shot/i, '3', 3
        :'One Shot'
      when /doujin/i, '4', 4
        :Doujin
      when /manwha/i, '5', 5
        :Manwha
      when /manhua/i, '6', 6
        :Manhua
      when /OEL/i, '7', 7
        :OEL
      else
        nil
    end
  end

  def status=(value)
    @status = case value
      when '1', 1, /publishing/i
        :publishing
      when '2', 2, /finished/i
        :finished
      when '3', 3, /not yet published/i
        :'not yet published'
      else
        nil
    end
  end
end