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
        if %w( filename uri command prompt productname ).include?(node['class'])
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
      words.each_with_index do |word, index|
        # Skip non-words
        next if word !~ /\w/

        # Skip numbers
        next if word =~ /\A(0x)?\d*\z/

        # Skip version numbers
        next if word =~ /\A\d+(a|b|rc)\d+\z/

        # Skip words that we know are fine
        next if @acceptable_words.include?(word)

        # Skip cardinal numbers
        next if word =~ /\A\d*(1st|2nd,3rd)|\d+th\z/

        # Skip correct words
        next if speller.correct?(word)

        # Record
        misspelled_words[filename] ||= []
        misspelled_words[filename] << word
      end
    end

    misspelled_words
  end
end
