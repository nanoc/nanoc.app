#!/usr/bin/env ruby
# frozen_string_literal: true

begin
  require 'ffi/aspell'
rescue LoadError
  warn 'WARNING: aspell is not available. Checks will not pass.'
end

require 'json'
require 'nokogiri'
require 'open3'
require 'set'

class NanocSpellChecker
  class Visitor
    attr_reader :string

    def initialize
      @string = +''
    end

    def visit(node)
      candidate =
        if node.text?
          node.content
        else
          ' '
        end

      # Remove URLs and email addresses (crude but it works)
      candidate =
        candidate
          .gsub(/https?:\/\/[\w\d\/\._-]+[\w\d\/]/, '')
          .gsub(/[\w\d]+@[\w\d]+\.[\w\d]+/, '')

      @string << candidate

      return if %w[pre code kbd samp var].include?(node.name)

      if node.name == 'span' && %w[filename identifier glob uri command prompt productname].include?(node['class'])
        return
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
      word_tuples = words.map do |word|
        [word, word.sub(/'$/, ''), word.sub(/'s$/, '')].uniq
      end

      word_tuples.each do |tuple|
        # Skip non-words
        next unless tuple.first.match?(/\w/)

        # Skip numbers
        next if tuple.first.match?(/\A(0x)?\d*\z/)

        # Skip version numbers
        next if tuple.first.match?(/\A\d+(a|b|rc)\d+\z/)

        # Skip words that we know are fine
        next if tuple.any? { |w| @acceptable_words.include?(w) }

        # Skip cardinal numbers
        next if tuple.first.match?(/\A\d*(1st|2nd,3rd)|\d+th\z/)

        # Skip correct words
        next if tuple.any? { |w| speller.correct?(w) }

        # Record
        misspelled_words[filename] ||= Set.new
        misspelled_words[filename] << tuple.first
      end
    end

    misspelled_words
  end
end

Nanoc::Check.define(:html5) do
  cmd = 'java -jar vendor/vnu.jar --format json --skip-non-html output/'
  res = Open3.popen3(cmd) { |_stdin, _stdout, stderr| stderr.read }

  JSON.parse(res).fetch('messages', []).each do |err|
    subject = err['url'].sub(%r{^file:#{Regexp.escape File.dirname(__FILE__)}/}, '')
    add_issue("#{err['message']} (line #{err['lastLine']}, column #{err['firstColumn']})", subject: subject)
  end
end

Nanoc::Check.define(:no_unprocessed_erb) do
  output_filenames.each do |fn|
    if fn =~ /html$/ && File.read(fn).match(/<%/)
      add_issue('erb detected', subject: fn)
    end
  end
end

Nanoc::Check.define(:no_markdown_links_in_output) do
  output_filenames.each do |fn|
    if fn =~ /html$/ && File.read(fn).match(/]\(/)
      add_issue('unprocessed Markdown detected', subject: fn)
    end
  end
end

Nanoc::Check.define(:valid_sitemap) do
  xsd = Nokogiri::XML::Schema(File.read('misc/sitemap.xsd'))
  doc = Nokogiri::XML(File.read('output/sitemap.xml'))

  unless xsd.valid?(doc)
    add_issue('sitemap does not adhere to XML schema', subject: 'output/sitemap.xml')
  end
end

Nanoc::Check.define(:no_smartness_in_kbd) do
  output_filenames.each do |fn|
    if fn =~ /html$/ && File.read(fn).match(%r{<kbd>[^<]*[–—][^<]*</kbd>})
      add_issue('smartness in kbd elem detected', subject: fn)
    end
  end
end

Nanoc::Check.define(:spelling) do
  acceptable_words = Set.new(File.readlines("#{__dir__}/../misc/acceptable_words.txt").map(&:strip))

  acceptable_files = [
    # These are auto-generated from Nanoc’s API documentation. Fixing these is a task for later.
    'output/doc/reference/commands/index.html',

    # The release notes contain lots of old, write-once, unmaintained content. Fixing these is a task for later.
    'output/release-notes/index.html',

    # The style guide uses nonsensical text.
    'output/style-guide/index.html',
  ]

  checker = NanocSpellChecker.new(acceptable_words, Dir.glob('output/**/*.html') - acceptable_files)

  misspelled_words = checker.run

  misspelled_words.keys.sort.each do |key|
    next if acceptable_files.include?(key)

    misspelled_words[key].each do |value|
      add_issue("misspelled word: #{value}", subject: key)
    end
  end
end
