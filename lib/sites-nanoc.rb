# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

# Default
include Nanoc::Extensions::Blogging
include Nanoc::Extensions::HTMLEscape
include Nanoc::Extensions::LinkTo

# Custom
include Nanoc::Extensions::ReleaseNotes
include Nanoc::Extensions::TOC

def nav_link_to_unless_current(text, path)
  if @page_rep and @page_rep.path == path
    "<span class=\"active\"><span>#{text}</span></span>"
  else
    "<a href=\"#{path}\"><span>#{text}</span></a>"
  end
end

# Returns the asset with the given asset ID.
def asset(asset_id)
  @assets.find { |asset| asset.asset_id == asset_id }
end

# Extensions

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
