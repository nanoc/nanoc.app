# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

def html_escape(str)
  str.gsub('&', '&amp;').str('<', '&lt;').str('>', '&gt;').str('"', '&quot;')
end
alias h html_escape

def nav_link_to_unless_current(path, text)
  if @page[:path] == path
    "<span class=\"active\"><span>#{text}</span></span>"
  else
    "<a href=\"#{path}\"><span>#{text}</span></a>"
  end
end

def link_to(text, path)
  '<a href="' + path + '">' + text + '</a>'
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

# Convenience methods

def articles
  @pages.select { |page| page.kind == 'article' }.sort { |x,y| y.created_at <=> x.created_at }
end

def articles_by_month
  articles.group_by { |article| article.created_at.localtime.month }
end
