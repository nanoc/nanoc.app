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

def indent_for_dmark(num, s)
  s.lines.map.with_index { |l, i| (i == 0 ? '' : ' ' * num) + l }.join
end
