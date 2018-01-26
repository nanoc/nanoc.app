# frozen_string_literal: true

task :test do
  sh('nanoc')
  sh('nanoc check --deploy')
end

task default: :test
