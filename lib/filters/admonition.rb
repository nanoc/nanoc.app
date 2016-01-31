require 'kramdown'

SUDO_GEM_CONTENT_DMARK = 'If the %command{<cmd>} command fails with a permission error, you likely have to prefix the command with %kbd{sudo}. Do not use %command{sudo} until you have tried the command without it; using %command{sudo} when not appropriate will damage your RubyGems installation.'

SUDO_GEM_INSTALL_CONTENT_DMARK = SUDO_GEM_CONTENT_DMARK.gsub('<cmd>', 'gem install')

SUDO_GEM_UPDATE_SYSTEM_CONTENT_DMARK = SUDO_GEM_CONTENT_DMARK.gsub('<cmd>', 'gem update --system')

Class.new(Nanoc::Filter) do
  SUDO_GEM_CONTENT = 'If the <span class="command">{cmd}</span> command fails with a permission error, you likely have to prefix the command with <kbd>sudo</kbd>. Do not use <span class="command">sudo</span> until you have tried the command without it; using <span class="command">sudo</span> when not appropriate will damage your RubyGems installation.'

  identifier :admonition

  def run(content, params = {})
    if params[:dmark]
      content
        .gsub('<sudo-gem-install>', SUDO_GEM_INSTALL_CONTENT_DMARK)
        .gsub('<sudo-gem-update-system>', SUDO_GEM_UPDATE_SYSTEM_CONTENT_DMARK)
    else
      content.lines.map { |l| handle_line(l) }.join
    end
  end

  def handle_line(line)
    if line =~ /^(TIP|NOTE|CAUTION): (.*)$/
      new_content = case $2
      when '{sudo-gem-install}'
        generate($1.downcase, sudo_gem_install_content)
      when '{sudo-gem-update-system}'
        generate($1.downcase, sudo_gem_update_system_content)
      else
        generate($1.downcase, $2)
      end
    else
      line
    end
  end

  def generate(kind, content)
    content = ::Kramdown::Document.new(content, {}).to_html.gsub(/^<p>|<\/p>$/, '')

    %[<div class="admonition-wrapper #{kind}"><div class="admonition">#{content}</div></div>] + "\n"
  end

  def sudo_gem_install_content
    SUDO_GEM_CONTENT.gsub('{cmd}', 'gem install')
  end

  def sudo_gem_update_system_content
    SUDO_GEM_CONTENT.gsub('{cmd}', 'gem update --system')
  end
end
