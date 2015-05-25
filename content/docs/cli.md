---
title:      "The command-line interface"
is_dynamic: true
up_to_date_with_nanoc_4: true
---

Interacting with nanoc happens through a command-line tool named <span class="command">nanoc</span>. This tool has sub-commands, which you can invoke like this:

<pre><span class="prompt">%</span> <kbd>nanoc</kbd> <var>command</var></pre>

Here, <var>command</var> is the name of the command you’re invoking.

Getting help
------------

To get help on a command, invoke the <span class="command">help</span> command with the command you’re interested in as the argument. For example, this is the help for the <span class="command">create-site</span> command:

<pre><span class="prompt">%</span> <kbd>nanoc help create-site</kbd>
nanoc create-site [path]

aliases: cs

create a site

    Create a new site at the given path. The site will use the compact
    filesystem data source by default, but this can be changed by
    using the --datasource commandline option.

options:

   -d --datasource specify the data source for the new site</pre>

To get a list of all commands and global options, invoke the <span class="command">help</span> command without arguments:

<pre><span class="prompt">%</span> <kbd>nanoc help</kbd></pre>

A reference of all commands is available on the <%= link_to_id('/docs/reference/commands.*') %> reference page, as well as the command line itself.

Writing commands
----------------

Custom commands live inside the <span class="filename">commands/</span> directory in the site directory. Commands are Ruby source files, where the filename corresponds to the command name.

Here is an example command:

	#!ruby
	usage       'dostuff [options]'
	aliases     :ds, :stuff
	summary     'does stuff'
	description 'This command does a lot of stuff. I really mean a lot.'

	flag   :h, :help,  'show help for this command' do |value, cmd|
	  puts cmd.help
	  exit 0
	end
	flag   :m, :more,  'do even more stuff'
	option :s, :stuff, 'specify stuff to do', :argument => :optional

	run do |opts, args, cmd|
	  stuff = opts[:stuff] || 'generic stuff'
	  puts "Doing #{stuff}!"

	  if opts[:more]
	    puts 'Doing it even more!'
	  end
	end

The name of the command is derived from the filename. For example, a command defined in <span class="filename">commands/dostuff.rb</span> will have the name `dostuff`, and it can thus be invoked as <kbd>nanoc dostuff</kbd>.

Commands can be nested; for example, the command at <span class="filename">commands/foo/bar.rb</span> will be a subcommand of the command at <span class="filename">commands/foo.rb</span>, and can be invoked as <kbd>nanoc foo bar</kbd>.

For details on how to create commands, check out the documentation for [Cri](http://rubydoc.info/gems/cri), the framework used by nanoc for generating commands.
