require 'time'

# Returns the item with the given identifier.
def item_named(identifier)
  @_item_named_cache ||= {}
  res = @_item_named_cache[identifier]
  if res.nil?
    res = @items.find { |item| item.identifier == identifier }
    @_item_named_cache[identifier] = res
  end
  res
end

def api_doc_root
  version = latest_release_info[:version]
  api_version = version.size == 5 ? version[0..-3] : version
  '/docs/api/' + api_version + '/'
end

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
