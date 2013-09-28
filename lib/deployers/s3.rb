# encoding: utf-8

class S3Deployer < ::Nanoc::Extra::Deployer

  identifier :s3

  def run
    src = self.source_path + '/'
    dst = self.config[:dst]

    FileUtils.cd(src) do
      opts = [
        '--reduced-redundancy',
        '--acl-public',
        '--delete-removed'
      ]
      system('s3cmd', 'sync', *opts, '.', dst)
    end
  end

end
