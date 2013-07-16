class MangaList
  attr_accessor :manga, :statistics

  def initialize
    @manga = []
    @statistics = { days: 0.0 }
  end
end