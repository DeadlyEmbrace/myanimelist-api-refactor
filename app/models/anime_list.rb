class AnimeList
  attr_accessor :anime, :statistics

  def initialize
    @anime = []
    @statistics = { days: 0.0 }
  end
end