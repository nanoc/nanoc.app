require 'time'

def nav_link_to_unless_current(identifier)
  other = @items.find { |i| i.identifier == identifier }
  link_to_unless_current(other[:short_title] || other[:title], other)
end

# Returns the item with the given identifier.
def item_named(identifier)
  @items.find { |item| item.identifier == identifier }
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

module Enumerable
  def group_by
    inject({}) do |groups, element|
      (groups[yield(element)] ||= []) << element
      groups
    end
  end
end

# This is necessary because the markdown-generated files have a doctype and
# cannot really be used as partials.
def strip_doctype(s)
  s.sub(/^<!DOCTYPE.*?>\s*/, '')
end
