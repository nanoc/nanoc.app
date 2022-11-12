# frozen_string_literal: true

source 'https://rubygems.org'

use_local_nanoc = false
local_nanoc_path = Pathname.new('~/Documents/Projects/Nanoc/Repos/nanoc')

if use_local_nanoc
  gem 'nanoc', path: local_nanoc_path.join('nanoc')
  gem 'nanoc-cli', path: local_nanoc_path.join('nanoc-cli')
  gem 'nanoc-core', path: local_nanoc_path.join('nanoc-core')

  group 'nanoc' do # automatically required by Nanoc
    gem 'nanoc-live', path: local_nanoc_path.join('nanoc-live')
  end
else
  gem 'nanoc', '~> 4.12', '>= 4.12.11'

  group 'nanoc' do # automatically required by Nanoc
    gem 'nanoc-live', '~> 1.0'
  end
end

gem 'adsf'
gem 'builder'
gem 'coderay'
gem 'd-mark', '~> 1.0.0b'
gem 'ffi-aspell'
gem 'htmlcompressor'
gem 'kramdown'
gem 'nokogiri'
gem 'psych', '~> 4.0'
gem 'rainpress'
gem 'rake'
gem 'rubocop'
gem 'sass', '~> 3.4'
gem 'terminal-notifier'
gem 'terminal-notifier-guard'
gem 'w3c_validators'
gem 'webrick'
