describe DateParser do
  describe 'parse anime date' do
    it 'should return nil for invalid date format' do
      date_range = DateParser.parse_anime_date('invalid format')
      date_range[:start_date].should be_nil
      date_range[:end_date].should be_nil
    end

    it 'should parse only a year' do
      date_range = DateParser.parse_anime_date '2007'
      date_range[:start_date].should eq '2007'
      date_range[:end_date].should eq '2007'
    end

    it 'should parse ? to year format' do
      date_range = DateParser.parse_anime_date '? to 2013'
      date_range[:start_date].should be_nil
      date_range[:end_date].should eq '2013'
    end

    it 'should parse year to ? format' do
      date_range = DateParser.parse_anime_date '2013 to ?'
      date_range[:start_date].should eq '2013'
      date_range[:end_date].should be_nil
    end

    it 'should parse the mm-dd-yy format' do
      expected = Chronic.parse('09-30-13').to_date
      date_range = DateParser.parse_anime_date '09-30-13'
      date_range[:start_date].should eq expected
      date_range[:end_date].should eq expected
    end

    it 'should parse MMM d, yyyy format' do
      expected = Chronic.parse('Jul 20, 2001').to_date
      date_range = DateParser.parse_anime_date 'Jul 20, 2001'
      date_range[:start_date].should eq expected
      date_range[:end_date].should eq expected
    end

    it 'should parse MMM d, yyyy to ? format' do
      expected_start_date = Chronic.parse('10-04-03').to_date
      date_range = DateParser.parse_anime_date('Oct 4, 2003 to ?')
      date_range[:start_date].should eq expected_start_date
      date_range[:end_date].should be_nil
    end

    it 'should parse ? to MMM d, yyyy format' do
      expected_end_date = Chronic.parse('10-04-03').to_date
      date_range = DateParser.parse_anime_date('? to Oct 4, 2003')
      date_range[:start_date].should be_nil
      date_range[:end_date].should eq expected_end_date
    end
  end
end