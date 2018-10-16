# frozen_string_literal: true

require 'coderay'

class GenericHTMLTranslator < NanocWsCommonTranslator
  # TODO: replace
  include Nanoc::Helpers::HTMLEscape

  def handle_string(string, _context)
    [h(string)]
  end

  def handle_element(element, context)
    case element.name
    when 'abbr'
      handle_element_abbr(element, context)
    when 'dd'
      handle_element_dd(element, context)
    when 'emph'
      handle_element_emph(element, context)
    when 'dl'
      handle_element_dl(element, context)
    when 'dt'
      handle_element_dt(element, context)
    when 'h'
      handle_element_h(element, context)
    when 'img'
      handle_element_img(element, context)
    when 'li'
      handle_element_li(element, context)
    when 'mark'
      handle_element_mark(element, context)
    when 'ol'
      handle_element_ol(element, context)
    when 'p'
      handle_element_p(element, context)
    when 'section'
      handle_element_section(element, context)
    when 'ul'
      handle_element_ul(element, context)
    else
      unsupported_element(element, context)
    end
  end

  ###

  def handle_element_abbr(element, context)
    attributes = element.attributes['title'] ? { title: element.attributes['title'] } : {}

    wrap('abbr', attributes.merge(extra_attributes_for_element(element, context))) do
      handle_children(element, context)
    end
  end

  def handle_element_dd(element, context)
    handle_generic_element(element, context)
  end

  def handle_element_dl(element, context)
    handle_generic_element(element, context)
  end

  def handle_element_dt(element, context)
    handle_generic_element(element, context)
  end

  def handle_element_emph(element, context)
    wrap('em', extra_attributes_for_element(element, context)) do
      handle_children(element, context)
    end
  end

  def id_for(element)
    @_id_for_cache ||= {}
    @_id_for_ids ||= Set.new

    @_id_for_cache.fetch(element) do
      id = to_id(text_content_of(element))
      id << '-' while @_id_for_ids.include?(id)
      @_id_for_ids << id
      @_id_for_cache[element] = id
    end
  end

  def handle_element_h(element, context)
    depth = context.fetch(:depth, 1)
    id = id_for(element)

    attributes = { id: id }.merge(extra_attributes_for_element(element, context))
    wrap("h#{depth}", attributes) { handle_children(element, context) }
  end

  def handle_element_img(element, context)
    attributes = { src: text_content_of(element) }
    wrap_empty('img', attributes.merge(extra_attributes_for_element(element, context)))
  end

  def handle_element_li(element, context)
    handle_generic_element(element, context)
  end

  def handle_element_mark(element, context)
    handle_generic_element(element, context)
  end

  def handle_element_ol(element, context)
    handle_generic_element(element, context)
  end

  def handle_element_p(element, context)
    handle_generic_element(element, context)
  end

  def handle_element_section(element, context)
    depth = context.fetch(:depth, 1) + 1
    handle_children(element, context.merge(depth: depth))
  end

  def handle_element_ul(element, context)
    handle_generic_element(element, context)
  end

  ###

  def handle_generic_element(element, context)
    wrap(element.name, extra_attributes_for_element(element, context)) do
      handle_children(element, context)
    end
  end

  def extra_attributes_for_element(_element, _context)
    {}
  end

  ###

  def wrap(name, params = {})
    [
      start_tag(name, params),
      yield,
      end_tag(name),
    ]
  end

  def wrap_empty(name, params = {})
    [start_tag(name, params)]
  end

  def start_tag(name, params)
    '<' + name + params.map { |k, v| ' ' + k.to_s + '="' + html_escape(v) + '"' }.join('') + '>'
  end

  def end_tag(name)
    '</' + name + '>'
  end

  def unsupported_element(element, _context)
    raise "Cannot translate #{element.name}"
  end
end

###############################################################################
###############################################################################
###############################################################################

class NanocWsHTMLTranslator < GenericHTMLTranslator
  SUDO_GEM_CONTENT_DMARK =
    'If the %command{<cmd>} command fails with a permission error, you likely have to prefix ' \
    'the command with %kbd{sudo}. Do not use %command{sudo} until you have tried the command ' \
    'without it; using %command{sudo} when not appropriate will damage your RubyGems installation.'

  SUDO_GEM_INSTALL_CONTENT_DMARK =
    SUDO_GEM_CONTENT_DMARK.gsub('<cmd>', 'gem install')

  SUDO_GEM_UPDATE_SYSTEM_CONTENT_DMARK =
    SUDO_GEM_CONTENT_DMARK.gsub('<cmd>', 'gem update --system')

  # Overridden methods

  def handle_string(string, context)
    if context.fetch(:html_escape, true)
      [h(string)]
    else
      [string]
    end
  end

  def extra_attributes_for_element(element, _context)
    attributes = {}

    # dt, section, h
    attributes[:id] = element.attributes['id'] if element.attributes['id']

    attributes[:class] = 'legacy' if element.attributes['legacy']
    attributes[:class] = 'errors' if element.attributes['errors']
    attributes[:class] = 'legacy-intermediate' if element.attributes['legacy-intermediate']
    attributes[:class] = 'new' if element.attributes['new']

    case element.name
    when 'h'
      attributes['data-nav-title'] = element.attributes['nav-title'] if element.attributes['nav-title']
    when 'dl', 'figure'
      attributes[:class] = 'compact' if element.attributes['compact']
    when 'ol', 'ul'
      attributes[:class] = 'spacious' if element.attributes['spacious']
    end

    attributes
  end

  # Abstract methods

  def handle_element(element, context)
    case element.name
    when 'ref'
      handle_ref(element, context)
    when 'entity'
      handle_entity(element, context)
    when 'erb'
      handle_erb(element, context)
    when 'listing'
      handle_listing(element, context)
    when 'caption'
      wrap('figcaption') { handle_children(element, context) }
    when 'firstterm', 'identifier', 'glob', 'filename', 'class', 'command', 'prompt', 'productname', 'see', 'log-create', 'log-check-ok', 'log-check-error', 'log-update', 'uri', 'attribute', 'output'
      wrap('span', class: element.name) { handle_children(element, context) }
    when 'note', 'tip', 'caution', 'todo'
      wrap('div', class: "admonition-wrapper #{element.name}") do
        wrap('div', class: 'admonition') do
          handle_children(element, context)
        end
      end
    when 'code', 'kbd', 'figure', 'blockquote', 'var', 'strong'
      attributes = {}

      attributes[:class] = 'compact' if element.attributes['compact'] # figure

      wrap(element.name, attributes) { handle_children(element, context) }
    else
      super
    end
  end

  # Specific elements

  def handle_entity(node, context)
    entity = text_content_of(node)

    content =
      case entity
      when 'sudo-gem-install'
        SUDO_GEM_INSTALL_CONTENT_DMARK
      when 'sudo-gem-update-system'
        SUDO_GEM_UPDATE_SYSTEM_CONTENT_DMARK
      end

    nodes = DMark::Parser.new(content).read_inline_content
    [NanocWsHTMLTranslator.translate(nodes, context)]
  end

  def handle_erb(node, context)
    ctx = Nanoc::Int::Context.new(context)
    [eval(text_content_of(node), ctx.get_binding)] # rubocop:disable Security/Eval
  end

  def handle_listing(element, context)
    pre_classes = []
    pre_classes << 'template' if element.attributes['template']
    pre_classes << 'errors' if element.attributes['errors']
    pre_classes << 'legacy' if element.attributes['legacy']
    pre_classes << 'legacy-49' if element.attributes['legacy-49']
    pre_classes << 'legacy-intermediate' if element.attributes['legacy-intermediate']
    pre_classes << 'new' if element.attributes['new']
    pre_classes << 'new-49' if element.attributes['new-49']
    pre_attrs =
      if pre_classes.any?
        { class: pre_classes.join(' ') }
      else
        {}
      end

    code_attrs =
      if element.attributes['lang']
        { class: 'language-' + element.attributes['lang'] }
      else
        {}
      end

    wrap('pre', pre_attrs) do
      wrap('code', code_attrs) do
        if element.attributes['lang']
          addition = translate(element.children, context.merge(html_escape: false))
          CodeRay.scan(addition, element.attributes['lang']).html
        else
          translate(element.children, context)
        end
      end
    end
  end

  def handle_ref_with_url(node, context, url)
    wrap('a', href: url) { handle_children(node, context) }
  end

  def handle_ref_with_content(node, context, target_item, frag)
    href = href_for(target_item, frag)
    wrap('a', href: href) { handle_children(node, context) }
  end

  def handle_ref_bare(_node, _context, target_item, frag, target_node)
    href = href_for(target_item, frag)
    wrap('a', href: href) do
      if frag
        text_content_of(target_node)
      else
        target_item[:title]
      end
    end
  end

  def handle_ref_insert_section_ref(_node, _context, target_item, frag, target_node)
    href = href_for(target_item, frag)
    header_content =
      header_content_of(target_node).sub(/^The /, '').sub(/^./, &:upcase)

    [
      'the ',
      wrap('a', href: href) { header_content },
      ' section',
    ]
  end

  def handle_ref_insert_inside_ref(_node, _context, _target_item, _frag, _target_node)
    [
      ' on ',
    ]
  end

  def handle_ref_insert_chapter_ref(_node, _context, target_item, _frag)
    [
      'the ',
      wrap('a', href: target_item.path) { target_item[:title] },
      ' page',
    ]
  end

  def handle_ref_insert_end(_node, _context, _target_item, _frag, _target_node)
    []
  end

  def href_for(target_item, frag)
    if frag
      target_item.path + '#' + frag
    else
      target_item.path
    end
  end
end
