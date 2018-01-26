# frozen_string_literal: true

Class.new(Nanoc::Filter) do
  identifier :latex2pdf
  type text: :binary

  TMP_BASENAME = 'nanoc-latex'
  TMP_EXTENSION = '.tex'

  def run(content, _params = {})
    unless system('which', 'xelatex', out: '/dev/null')
      warn 'Warning: `xelatex` not found; PDF generation disabled.'
      File.write(output_filename, '')
      return
    end

    Tempfile.open([TMP_BASENAME, TMP_EXTENSION]) do |f|
      f.write(content)
      f.flush

      run_latex(f)
      FileUtils.cd(File.dirname(f.path)) { run_makeindex(f) }
      run_latex(f)
      run_latex(f)

      system('mv', f.path.sub('.tex', '.pdf'), output_filename)
    end
  end

  def run_latex(f)
    system('xelatex', '-halt-on-error', '-output-directory', File.dirname(f.path), f.path)
  end

  def run_makeindex(f)
    basename = File.basename(f.path, TMP_EXTENSION)
    system('makeindex', basename)
  end
end
