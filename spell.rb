require 'ffi/aspell'
require 'nokogiri'
require 'set'

class NanocSpellChecker
  class Visitor
    attr_reader :string

    def initialize
      @string = ''
    end

    def visit(node)
      if node.text?
        @string << node.content
      else
        @string << ' '
      end

      if %w( pre code kbd samp var ).include?(node.name)
        return
      end

      if node.name == 'span'
        if %w( filename identifier glob uri command prompt productname ).include?(node['class'])
          return
        end
      end

      node.children.each do |child|
        child.accept(self)
      end
    end
  end

  def initialize(acceptable_words, filenames)
    @acceptable_words = acceptable_words
    @filenames = filenames
  end

  def run
    speller = FFI::Aspell::Speller.new('en_US')

    misspelled_words = {}

    @filenames.each do |filename|
      doc = Nokogiri::HTML(File.read(filename))

      visitor = Visitor.new
      doc.accept(visitor)

      words = visitor.string.gsub(/‘|’/, '\'').scan(/(([[:word:]]|')+)/).map(&:first)

      # build alternatives
      word_sets = words.map do |word|
        [word, word.sub(/'$/, ''), word.sub(/'s$/, '')].uniq
      end

      word_sets.each do |words|
        # Skip non-words
        next unless words.first.match?(/\w/)

        # Skip numbers
        next if words.first.match?(/\A(0x)?\d*\z/)

        # Skip version numbers
        next if words.first.match?(/\A\d+(a|b|rc)\d+\z/)

        # Skip words that we know are fine
        next if words.any? { |w| @acceptable_words.include?(w) }

        # Skip cardinal numbers
        next if words.first.match(/\A\d*(1st|2nd,3rd)|\d+th\z/)

        # Skip correct words
        next if words.any? { |w| speller.correct?(w) }

        # Record
        misspelled_words[filename] ||= Set.new
        misspelled_words[filename] << words.first
      end
    end

    misspelled_words
  end
end
