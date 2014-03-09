# encoding: utf-8

require 'nanoc-linking'
require 'nanoc-escaping'
require 'nanoc-filtering'
require 'nanoc-xml_sitemap'
require 'nanoc-rendering'
require 'nanoc-breadcrumbs'
require 'nanoc-capturing'

# Default
include Nanoc::Linking::Helper
include Nanoc::Filtering::Helper
include Nanoc::XMLSitemap::Helper
include Nanoc::Rendering::Helper
include Nanoc::Breadcrumbs::Helper

# Custom
include NanocSite::ReleaseNotes
include NanocSite::LinkToId
