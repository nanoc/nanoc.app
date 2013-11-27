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

def detailed_toc_for(item_identifier)
  item = @items[item_identifier]
  content = item.compiled_content(snapshot: :pre)

  header_finder = HeaderFinder.new
  Nokogiri::HTML::SAX::Parser.new(header_finder).parse(content)
  headers = header_finder.headers

  out = ''
  out << '<h3>' << link_to(item[:title], item) << '</h3>'
  start_depth = 1
  current_depth = start_depth
  headers.each do |header|
    (header[:depth] - current_depth).times { out << '<ol>' }
    (current_depth - header[:depth]).times { out << '</ol>' }
    current_depth = header[:depth]
    out << '<li>' << link_to(header[:text], item.identifier + '#' + header[:id]) << '</li>'
  end
  (current_depth - start_depth).times { out << '</ol>' }
  out
end
