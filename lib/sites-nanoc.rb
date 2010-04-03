require 'time'

def nav_item_for(identifier, params={})
  # Parse params
  params[:include_children] = true unless params.has_key?(:include_children)

  # Get other item
  other = @items.find { |i| i.identifier == identifier }

  # Check whether we are in other or a child
  in_other_tree = @item == other || @item.parent == other

  res = '<li>'

  # Add link itself
  res << link_to_unless_current(
    '<span>' + (other[:short_title] || other[:title]) + '</span>',
    other
  )

  # Children
  if in_other_tree && other[:toc_includes_children] && params[:include_children]
    res << '<ol>'
    other.children.each { |c| res << nav_item_for(c.identifier) unless c[:is_hidden] }
    res << '</ol>'
  elsif in_other_tree && other[:toc_includes_sections] && params[:include_children]
    res << toc_for(@item)
  end

  res << '</li>'

  res
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
