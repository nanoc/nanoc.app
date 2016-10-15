require 'time'

def array_to_yaml(array)
  '[ ' + array.map { |s| "'" + s + "'" }.join(', ') + ' ]'
end

class Date
  def format_as_date
    %[#{Date::MONTHNAMES[self.mon]} #{self.mday.ordinal}, #{self.year}]
  end
end

class Time
  def format_as_date
    %[#{Date::MONTHNAMES[self.mon]} #{self.mday.ordinal}, #{self.year}]
  end

  def format_as_date_id
    "#{self.year}-#{self.mon}-#{self.mday}"
  end
end

class Numeric
  def ordinal
    if (10...20).include?(self) then
      self.to_s + 'th'
    else
      self.to_s + %w{th st nd rd th th th th th th}[self % 10]
    end
  end

  def to_month_name
    Date::MONTHNAMES[self]
  end
end

def handle_error(e, content)
  case e
  when DMark::Parser::ParserError
    line = content.lines[e.line_nr]

    lines = [
      e.message,
      "",
      line,
      "\e[31m" + ' ' * (e.col_nr - 1) + '↑' + "\e[0m",
    ]

    fancy_msg = lines.map { |l| "\e[34m[D*Mark]\e[0m #{l.rstrip}\n" }.join('')
    raise "D*Mark parser error\n\n" + fancy_msg
  else
    raise e
  end
end
