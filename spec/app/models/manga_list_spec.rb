describe MangaList do
  describe 'defaults' do
    before :each do
      @manga_list = MangaList.new
    end

    it 'should have an empty anime list' do
      @manga_list.manga.should be_empty
    end

    it 'should have statistics with days of 0.0' do
      @manga_list.statistics.should eq({ days: 0.0 })
    end
  end
end