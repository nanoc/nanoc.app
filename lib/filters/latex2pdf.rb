Class.new(Nanoc::Filter) do
  identifier :latex2pdf
  type :text => :binary

  def run(content, params = {})
    unless system('which', 'xelatex', out: '/dev/null')
      $stderr.puts "Warning: `xelatex` not found; PDF generation disabled."
      File.write(output_filename, '')
      return
    end

    Tempfile.open(['nanoc-latex', '.tex']) do |f|
      f.write(content)
      f.flush

      3.times do
        system('xelatex', '-halt-on-error', '-output-directory', File.dirname(f.path), f.path)
      end

      system('mv', f.path.sub('.tex', '.pdf'), output_filename)
    end
  end
end
