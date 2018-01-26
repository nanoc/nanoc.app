# frozen_string_literal: true

# Default
use_helper Nanoc::Helpers::LinkTo
use_helper Nanoc::Helpers::Filtering
use_helper Nanoc::Helpers::XMLSitemap
use_helper Nanoc::Helpers::Rendering

# Custom
use_helper NanocSite::ReleaseNotes
use_helper NanocSite::LinkToId
use_helper NanocSite::Commands
