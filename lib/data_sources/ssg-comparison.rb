# encoding: utf-8

class StaticSiteGeneratorComparisonDataSource < Nanoc::DataSource

  identifier :ssg_comparison

  def items
    unless File.file?('content-ssg-comparison/list.yaml')
      raise "content-ssg-comparison/list.yaml not found. Did you forget to clone the content-ssg-comparison submodule?"
    end

    YAML.load_file('content-ssg-comparison/list.yaml').map do |e|
      Nanoc::Item.new(
        '',
        e,
        "/#{e['name'].downcase.gsub(/[^a-z0-9]+/, '-')}/")
    end
  end

end
