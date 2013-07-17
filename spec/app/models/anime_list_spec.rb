describe AnimeList do
  describe 'defaults' do
    before :each do
      @anime_list = AnimeList.new
    end

    it 'should have an empty anime list' do
      @anime_list.anime.should be_empty
    end

    it 'should have statistics with days of 0.0' do
      @anime_list.statistics.should eq({ days: 0.0 })
    end
  end
end