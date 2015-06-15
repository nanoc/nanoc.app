# encoding: utf-8

class NavLinker

  def initialize(item)
    @item = item
  end

  def nav_link(item)
    link_text = item[:nav_title] || item[:short_title] || item[:title]

    html_class = html_class_for(item)

    if item == @item
      li(
        span(span(link_text)),
        :class => html_class
      )
    else
      li(
        a(span(link_text), :href => item.path),
        :class => html_class
      )
    end
  end

  private

  def html_class_for(item)
    html_classes = []

    if item.identifier =~ '/index.*'
      html_classes << 'home'
    end

    if @item == item || @item.identifier.with_ext('').start_with?(item.identifier.with_ext(''))
      html_classes << 'active'
    end

    html_classes.empty? ? nil : html_classes.join(' ')
  end

  def a(content, params = {})
    href = params.fetch(:href)

    start_tag = %(<a href="#{href}">)
    end_tag   = '</a>'

    start_tag + content + end_tag
  end

  def span(content)
    start_tag = '<span>'
    end_tag   = '</span>'

    start_tag + content + end_tag
  end

  def li(content, params = {})
    html_class = params.fetch(:class, nil)

    start_tag = html_class ? %(<li class="#{html_class}">) : '<li>'
    end_tag   = '</li>'

    start_tag + content + end_tag
  end

end

module NavLinkHelper

  def nav_link(item)
    NavLinker.new(@item).nav_link(item)
  end

end

include NavLinkHelper
