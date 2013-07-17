describe DateParser do

  describe 'parse date' do
    it 'should parse the mm-dd-yy format' do
      expected = Chronic.parse('09-30-13').to_date
      parsed_date = DateParser.parse_date '09-30-13'
      parsed_date.should eq expected
    end
  end

  describe 'parse anime date' do
    it 'should return nil for invalid date format' do
      date_range = DateParser.parse_date_range('invalid format')
      date_range[:start_date].should be_nil
      date_range[:end_date].should be_nil
    end

    it 'should parse only a year' do
      date_range = DateParser.parse_date_range '2007'
      date_range[:start_date].should eq '2007'
      date_range[:end_date].should eq '2007'
    end

    it 'should parse ? to year format' do
      date_range = DateParser.parse_date_range '? to 2013'
      date_range[:start_date].should be_nil
      date_range[:end_date].should eq '2013'
    end

    it 'should parse year to ? format' do
      date_range = DateParser.parse_date_range '2013 to ?'
      date_range[:start_date].should eq '2013'
      date_range[:end_date].should be_nil
    end

    it 'should parse MMM d, yyyy format' do
      expected = Chronic.parse('Jul 20, 2001').to_date
      date_range = DateParser.parse_date_range 'Jul 20, 2001'
      date_range[:start_date].should eq expected
      date_range[:end_date].should eq expected
    end

    it 'should parse MMM d, yyyy to ? format' do
      expected_start_date = Chronic.parse('10-04-03').to_date
      date_range = DateParser.parse_date_range('Oct 4, 2003 to ?')
      date_range[:start_date].should eq expected_start_date
      date_range[:end_date].should be_nil
    end

    it 'should parse ? to MMM d, yyyy format' do
      expected_end_date = Chronic.parse('10-04-03').to_date
      date_range = DateParser.parse_date_range('? to Oct 4, 2003')
      date_range[:start_date].should be_nil
      date_range[:end_date].should eq expected_end_date
    end
  end
end