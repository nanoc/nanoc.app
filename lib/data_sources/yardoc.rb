Class.new(Nanoc::DataSource) do
  identifier :yard

  def up
    require 'yard'
    YARD::Registry.load!('yardoc')
  end

  def items
    [].tap { |items| add_helpers_to(items) }
  end

  protected

  def add_helpers_to(items)
    YARD::Registry.at('Nanoc::Helpers').children.each do |helper|
      slug    = helper.name.to_s.downcase.gsub(/^a-z0-9/, '')

      items << new_item(
        '-',
        {
          :type        => 'helper',
          :name        => helper.name,
          :full_name   => helper.path,
          :summary     => helper.docstring.summary,
          :functions   => helper.meths(:visibility => :public, :included => false).map do |m|
            signature = "#{m.name}(#{m.parameters.map { |n,v| n }.join(", ")})"
            if m.tag(:return) && !m.tag(:return).types.empty?
              signature << " &rarr; #{m.tag(:return).types.first}"
            end
            {
              :name        => m.name,
              :summary     => m.docstring.summary,
              :examples    => m.tags('example').map { |e| { :title => e.name, :code => e.text } },
              :signature   => signature
            }
          end,
        },
        Nanoc::Identifier.new("/helpers/_#{slug}"))
    end
  end
end
