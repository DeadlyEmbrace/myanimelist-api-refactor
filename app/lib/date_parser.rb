class DateParser

  def self.parse_date(date_string)
    date = nil
    date_string = date_string.strip
    parsed_date = Chronic.parse date_string
    date = parsed_date.to_date unless parsed_date.nil?
    date
  end

  def self.parse_date_range(date_string)
    date_range = { start_date: nil, end_date: nil }
    date_string = date_string.strip

    case date_string
      when /^\d{4}$/
        date_range[:start_date] = date_string
        date_range[:end_date] = date_string
      when /^(\d{4}) to \?/
        date_range[:start_date] = $1
      when /^\? to (\d{4})/
        date_range[:end_date] = $1
      else
        date_string = date_string.split(/\s+to\s+/)
        start_date = Chronic.parse(date_string.first)
        end_date = Chronic.parse(date_string.last)
        date_range[:start_date] = start_date.to_date unless start_date.nil?
        date_range[:end_date] = end_date.to_date unless end_date.nil?
    end

    date_range
  end
end