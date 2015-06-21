# encoding: utf-8

module NanocSite

  class CLIDataSource < Nanoc::DataSource

    identifier :cli

    def items
      items = []

      if Nanoc::CLI.root_command.nil?
        Nanoc::CLI.setup
      end
      root_cmd = Nanoc::CLI.root_command

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

      new_item(
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
        Nanoc::Identifier.new("/_#{slug}", style: :full))
    end

  end

end
