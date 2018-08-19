# frozen_string_literal: true

Class.new(Nanoc::DataSource) do
  identifier :cli

  def items
    items = []

    Nanoc::CLI.setup if Nanoc::CLI.root_command.nil?
    root_cmd = Nanoc::CLI.root_command
    items << cmd_to_item(root_cmd)

    subcommands = root_cmd.subcommands.reject(&:hidden).reject { |c| c.name == 'live' }
    subcommands.each do |subcmd|
      items << cmd_to_item(subcmd)
    end

    items
  end

  protected

  def cmd_to_item(cmd)
    slug = cmd.name.downcase.gsub(/[^a-z0-9]+/, '-')

    new_item(
      '-',
      {
        type: 'command',
        name: cmd.name,
        summary: cmd.summary,
        description: cmd.description,
        aliases: cmd.aliases,
        option_definitions: cmd.option_definitions,
        usage: cmd.usage,
      },
      Nanoc::Identifier.new("/_#{slug}"),
    )
  end
end
