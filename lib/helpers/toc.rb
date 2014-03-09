require 'pp'

class HeaderFinder < ::Nokogiri::XML::SAX::Document

  attr_reader :headers

  def initialize
    @headers = []
    @current_header = nil
  end

  def start_element(name, attributes)
    if name =~ /h[1-6]/
      @current_header = {
        depth: name[1].to_i,
        text: '',
        id: attributes.find { |e| e[0] == "id" }[1]
      }
    end
  end

  def characters(string)
    if @current_header
      @current_header[:text] << string
    end
  end

  def end_element(name)
    if name =~ /h[1-6]/
      @headers << @current_header
      @current_header = nil
    end
  end

end

def toc_structure_from_headers(headers)
  if headers.empty?
    return []
  end

  entries = []
  this_level = headers[0][:depth]
  headers.each do |header|
    if header[:depth] == this_level
      entries << { id: header[:id], text: header[:text], children: [], unprocessed: [] }
    elsif header[:depth] < this_level
      raise "Invalid header nesting for #{header.inspect}"
    else
      entries[-1][:unprocessed] << header
    end
  end

  entries.each do |entry|
    entry[:children] = toc_structure_from_headers(entry[:unprocessed])
    entry.delete(:unprocessed)
  end

  entries
end

def subtoc_for(elements, item_identifier, limit)
  if elements.size < 2 || limit < 1
    return ''
  end

  out = ''
  out << '<ol class="toc">'
  elements.each do |e|
    out << '<li>'
    out << link_to(e[:text], item_identifier + '#' + e[:id]).strip
    out << subtoc_for(e[:children], item_identifier, limit-1)
    out << '</li>'
  end
  out << '</ol>'
end

def detailed_toc_for(item_identifier, params={})
  limit = params.fetch(:limit, 999)
  item = @items.glob(item_identifier).first
  content = item.compiled_content(snapshot: :before_layout)

  header_finder = HeaderFinder.new
  Nokogiri::HTML::SAX::Parser.new(header_finder).parse(content)
  headers = header_finder.headers

  toc = toc_structure_from_headers(headers)

  out = ''
  out << '<li>' << link_to(item[:title], item)
  out << subtoc_for(toc, item_identifier, limit)
  out << '</li>'
  out
end
