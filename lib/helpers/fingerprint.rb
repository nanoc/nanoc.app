def fingerprint(pattern)
  if ENV['NANOC_ENV'] == 'dev'
    'dev'
  else
    contents = @items.find_all(pattern).map do |i|
      i.binary? ? File.read(i[:filename]) : i.raw_content
    end
    Digest::SHA1.hexdigest(contents.join(''))[0..15]
  end
end
