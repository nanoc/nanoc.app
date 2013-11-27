# encoding: utf-8

require 'nanoc/cli'
Nanoc::CLI.setup

class CLIDataSource < Nanoc::DataSource

  identifier :cli

  def items
    items = []

    root_cmd = Nanoc::CLI.root_command
    #items << cmd_to_item(root_cmd)

    root_cmd.subcommands.select { |c| !c.hidden? }.each do |subcmd|
      items << cmd_to_item(subcmd)
    end

    items
  end

  protected

  def cmd_to_item(cmd)
    slug = cmd.name.downcase.gsub(/[^a-z0-9]+/, '-')
    opt_defs = cmd.option_definitions.map do |od|
      od.reject { |k,v| k == :block }
    end

    Nanoc::Item.new(
      '-',
      {
        :type               => 'command',
        :name               => cmd.name,
        :summary            => cmd.summary,
        :description        => cmd.description,
        :aliases            => cmd.aliases,
        :option_definitions => opt_defs,
        :usage              => cmd.usage
      },
      "/#{slug}/")
  end

end
