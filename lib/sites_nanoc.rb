# frozen_string_literal: true

require 'time'

def array_to_yaml(array)
  '[ ' + array.map { |s| "'#{s}'" }.join(', ') + ' ]'
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
      "#{self}th"
    else
      to_s + %w[th st nd rd th th th th th th][self % 10]
    end
  end

  def to_month_name
    Date::MONTHNAMES[self]
  end
end
