# encoding: utf-8

class AdmonitionFilter < Nanoc::Filter

  SUDO_GEM_CONTENT = 'If the <span class="command">{cmd}</span> command fails with a permission error, you likely have to prefix the command with <kbd>sudo</kbd>. Do not use <span class="command">sudo</span> until you have tried the command without it; using <span class="command">sudo</span> when not appropriate will damage your RubyGems installation.'

  identifier :admonition

  def run(content, params = {})
    doc = Nokogiri::HTML.fragment(content)
    doc.css('p').each do |para|
      content = para.inner_html
      next if content !~ /^(TIP|NOTE|CAUTION|TODO|DONE): (.*)$/
      new_content = case $2
      when '{sudo-gem-install}'
        generate($1.downcase, sudo_gem_install_content)
      when '{sudo-gem-update-system}'
        generate($1.downcase, sudo_gem_update_system_content)
      when '{nanoc-4}'
        generate('done', 'This section is up-to-date with nanoc 4.')
      else
        generate($1.downcase, $2)
      end
      para.replace(new_content)
    end
    doc.to_s
  end

  def generate(kind, content)
    %[<div class="admonition-wrapper #{kind}"><div class="admonition">#{content}</div></div>]
  end

  def sudo_gem_install_content
    SUDO_GEM_CONTENT.gsub('{cmd}', 'gem install')
  end

  def sudo_gem_update_system_content
    SUDO_GEM_CONTENT.gsub('{cmd}', 'gem update --system')
  end

end
