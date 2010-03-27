require 'sass'

class Sass::Tree::ImportNode < Sass::Tree::Node

  # Modified version of {Sass::Tree::ImportNode#perform!} that causes nanoc dependencies to ensure correct compilation.
  def perform!(environment)
    return unless full_filename = import

    # Find site
    # FIXME ugly
    site = ObjectSpace.each_object(Nanoc3::Site) { |s| break s }

    # Find item
    normalized_full_filename = Pathname.new(full_filename).realpath
    item = site.items.find { |i| Pathname.new(i[:filename]).realpath == normalized_full_filename }
    item_rep = item.rep_named(:default)

    # Require compilation
    raise Nanoc3::Errors::UnmetDependency.new(item_rep) unless item_rep.compiled?

    self.children = Sass::Files.tree_for(full_filename, @options).children
    self.children = perform_children(environment)
  rescue Sass::SyntaxError => e
    e.add_backtrace_entry(@filename)
    raise e
  end

end
