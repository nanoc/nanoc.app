require 'time'

def array_to_yaml(array)
  '[ ' + array.map { |s| "'" + s + "'" }.join(', ') + ' ]'
end

class Date
  def format_as_date
    %(#{Date::MONTHNAMES[mon]} #{mday.ordinal}, #{year})
  end
end

class Time
  def format_as_date
    %(#{Date::MONTHNAMES[mon]} #{mday.ordinal}, #{year})
  end

  def format_as_date_id
    "#{year}-#{mon}-#{mday}"
  end
end

class Numeric
  def ordinal
    if (10...20).cover?(self)
      to_s + 'th'
    else
      to_s + %w[th st nd rd th th th th th th][self % 10]
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
      '',
      line,
      "\e[31m" + ' ' * (e.col_nr - 1) + '↑' + "\e[0m"
    ]

    fancy_msg = lines.map { |l| "\e[34m[D*Mark]\e[0m #{l.rstrip}\n" }.join('')
    raise "D*Mark parser error\n\n" + fancy_msg
  else
    raise e
  end
end
