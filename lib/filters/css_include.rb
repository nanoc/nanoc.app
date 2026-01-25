# frozen_string_literal: true

class CssIncludeFilter < Nanoc::Filter
  identifier :css_include

  def run(content, _params = {})
    handle_hashlike(@item) + content
  end

  private

  def handle_string(pattern_string)
    @items[pattern_string].compiled_content(snapshot: :for_inclusion) + "\n\n"
  end

  def handle_hashlike(hash)
    hash.fetch(:include, []).map do |thing|
      case thing
      when String
        handle_string(thing)
      when Hash
        pre = nil
        post = nil

        if thing[:layer]
          pre = "@layer #{thing[:layer]} {\n\n"
          post = "\n\n} /* @layer #{thing[:layer]} */ \n\n"
        end

        [pre, handle_hashlike(thing), post].compact.join
       else
        raise "???"
      end
    end.join("")
  end
end
