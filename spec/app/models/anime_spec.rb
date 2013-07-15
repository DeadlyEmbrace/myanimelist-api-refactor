describe Anime do
  
  before :each do
    @anime = Anime.new
  end

  describe 'watched status' do
    WATCHED_STATUSES = [
      { text_value: 'watching', id_value: 1, expected_value: :watching },
      { text_value: 'completed', id_value: 2, expected_value: :completed },
      { text_value: 'on-hold', id_value: 3, expected_value: :'on-hold' },
      { text_value: 'dropped', id_value: 4, expected_value: :dropped },
      { text_value: 'plan to watch', id_value: 6, expected_value: :'plan to watch' },
      { text_value: 'plantowatch', id_value: 6, expected_value: :'plan to watch' },
    ]

    it 'should default to nil' do      
      @anime.watched_status.should be_nil
    end

    it 'should be nil when passed an invalid value' do
      @anime.watched_status = 'invalid status'
      @anime.watched_status.should be_nil
    end

    it 'should be able to set by text' do
      WATCHED_STATUSES.each do |watched_status|
        @anime.watched_status = watched_status[:text_value]
        @anime.watched_status.should be watched_status[:expected_value]
      end
    end

    it 'should be able to set by id' do
      WATCHED_STATUSES.each do |watched_status|
        @anime.watched_status = watched_status[:id_value]
        @anime.watched_status.should be watched_status[:expected_value]
      end
    end

    it 'should be able to set by id as text' do
      WATCHED_STATUSES.each do |watched_status|
        @anime.watched_status = watched_status[:id_value].to_s
        @anime.watched_status.should be watched_status[:expected_value]
      end
    end
  end

  describe 'type' do
    TYPES = [
      { text_value: 'TV', id_value: 1, expected_value: :TV },
      { text_value: 'OVA', id_value: 2, expected_value: :OVA },
      { text_value: 'Movie', id_value: 3, expected_value: :Movie },
      { text_value: 'Special', id_value: 4, expected_value: :Special },
      { text_value: 'ONA', id_value: 5, expected_value: :ONA },
      { text_value: 'Music', id_value: 6, expected_value: :Music },
    ]

    it 'should default to nil' do
      @anime.type.should be_nil
    end

    it 'should be nil when passed an invalid value' do
      @anime.type = 'not valid'
      @anime.type.should be_nil
    end

    it 'should be able to set by text' do
      TYPES.each do |type|
        @anime.type = type[:text_value]
        @anime.type.should be type[:expected_value]
      end
    end

    it 'should be able to set by id' do
      TYPES.each do |type|
        @anime.type = type[:id_value]
        @anime.type.should be type[:expected_value]
      end
    end

    it 'should be able to set by id as text' do
      TYPES.each do |type|
        @anime.type = type[:id_value].to_s
        @anime.type.should be type[:expected_value]
      end
    end
  end

  describe 'status' do
    STATUSES = [
      { text_value: 'currently airing', id_value: 1, expected_value: :'currently airing' },
      { text_value: 'finished airing', id_value: 2, expected_value: :'finished airing' },
      { text_value: 'not yet aired', id_value: 3, expected_value: :'not yet aired' }
    ]

    it 'should default to nil' do
      @anime.status.should be_nil
    end

    it 'should be nil when passed an invalid value' do
      @anime.status = 'invalid value'
      @anime.status.should be_nil
    end

    it 'should be able to set by text' do
      STATUSES.each do |status|
        @anime.status = status[:text_value]
        @anime.status.should be status[:expected_value]
      end
    end

    it 'should be able to set by id' do
      STATUSES.each do |status|
        @anime.status = status[:id_value]
        @anime.status.should be status[:expected_value]
      end
    end

    it 'should be able to set by id as text' do
      STATUSES.each do |status|
        @anime.status = status[:id_value].to_s
        @anime.status.should be status[:expected_value]
      end
    end
  end
end