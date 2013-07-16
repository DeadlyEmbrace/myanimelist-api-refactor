describe Manga do
  before :each do
    @manga = Manga.new
  end

  describe 'read status' do
    read_statuses = [
        { text_value: 'reading', id_value: 1, expected_value: :reading },
        { text_value: 'completed', id_value: 2, expected_value: :completed },
        { text_value: 'on-hold', id_value: 3, expected_value: :'on-hold' },
        { text_value: 'onhold', id_value: 3, expected_value: :'on-hold' },
        { text_value: 'dropped', id_value: 4, expected_value: :dropped },
        { text_value: 'plan to read', id_value: 6, expected_value: :'plan to read' },
    ]

    it 'should default to nil' do
      @manga.read_status.should be_nil
    end

    it 'should be nil when passed an invalid value' do
      @manga.read_status = 'invalid status'
      @manga.read_status.should be_nil
    end

    it 'should be able to set by text' do
      read_statuses.each do |watched_status|
        @manga.read_status = watched_status[:text_value]
        @manga.read_status.should be watched_status[:expected_value]
      end
    end

    it 'should be able to set by id' do
      read_statuses.each do |watched_status|
        @manga.read_status = watched_status[:id_value]
        @manga.read_status.should be watched_status[:expected_value]
      end
    end

    it 'should be able to set by id as text' do
      read_statuses.each do |watched_status|
        @manga.read_status = watched_status[:id_value].to_s
        @manga.read_status.should be watched_status[:expected_value]
      end
    end
  end

  describe 'type' do
    types = [
        { text_value: 'Manga', id_value: 1, expected_value: :Manga },
        { text_value: 'Novel', id_value: 2, expected_value: :Novel },
        { text_value: 'One Shot', id_value: 3, expected_value: :'One Shot' },
        { text_value: 'Doujin', id_value: 4, expected_value: :Doujin },
        { text_value: 'Manwha', id_value: 5, expected_value: :Manwha },
        { text_value: 'Manhua', id_value: 6, expected_value: :Manhua },
        { text_value: 'OEL', id_value: 7, expected_value: :OEL },
    ]

    it 'should default to nil' do
      @manga.type.should be_nil
    end

    it 'should be nil when passed an invalid value' do
      @manga.type = 'not valid'
      @manga.type.should be_nil
    end

    it 'should be able to set by text' do
      types.each do |type|
        @manga.type = type[:text_value]
        @manga.type.should be type[:expected_value]
      end
    end

    it 'should be able to set by id' do
      types.each do |type|
        @manga.type = type[:id_value]
        @manga.type.should be type[:expected_value]
      end
    end

    it 'should be able to set by id as text' do
      types.each do |type|
        @manga.type = type[:id_value].to_s
        @manga.type.should be type[:expected_value]
      end
    end
  end

  describe 'status' do
    statuses = [
        { text_value: 'publishing', id_value: 1, expected_value: :'publishing' },
        { text_value: 'finished', id_value: 2, expected_value: :'finished' },
        { text_value: 'not yet published', id_value: 3, expected_value: :'not yet published' }
    ]

    it 'should default to nil' do
      @manga.status.should be_nil
    end

    it 'should be nil when passed an invalid value' do
      @manga.status = 'invalid value'
      @manga.status.should be_nil
    end

    it 'should be able to set by text' do
      statuses.each do |status|
        @manga.status = status[:text_value]
        @manga.status.should be status[:expected_value]
      end
    end

    it 'should be able to set by id' do
      statuses.each do |status|
        @manga.status = status[:id_value]
        @manga.status.should be status[:expected_value]
      end
    end

    it 'should be able to set by id as text' do
      statuses.each do |status|
        @manga.status = status[:id_value].to_s
        @manga.status.should be status[:expected_value]
      end
    end
  end
end