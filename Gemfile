# frozen_string_literal: true

source 'https://rubygems.org'

use_local_nanoc = false
local_nanoc_path = Pathname.new('~/Documents/2 Software development/21 Mine/2 Active/Nanoc/Repos/nanoc')

if use_local_nanoc
  gem 'nanoc', path: local_nanoc_path.join('nanoc')
  gem 'nanoc-cli', path: local_nanoc_path.join('nanoc-cli')
  gem 'nanoc-core', path: local_nanoc_path.join('nanoc-core')

  group 'nanoc' do # automatically required by Nanoc
    gem 'nanoc-live', path: local_nanoc_path.join('nanoc-live')
  end
else
  gem 'nanoc', '~> 4.12', '>= 4.12.14'

  group 'nanoc' do # automatically required by Nanoc
    gem 'nanoc-live', '~> 1.0'
  end
end

group :nanoc do
  gem 'nanoc-dart-sass', '~> 1.0'
end

gem 'adsf'
gem 'builder'
gem 'coderay'
gem 'd-mark', '~> 1.0.0b'
gem 'ffi-aspell'
gem 'kramdown'
gem 'nokogiri'
gem 'perfect_toml', '~> 0.9.0'
gem 'psych', '~> 4.0'
gem 'rake'
gem 'rubocop'
gem 'terminal-notifier'
gem 'terminal-notifier-guard'
gem 'w3c_validators'
gem 'webrick'
