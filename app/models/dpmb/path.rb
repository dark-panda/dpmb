
class Dpmb::Path
  extend Memoist

  attr_reader :path

  def initialize(path)
    @path = path
  end

  memoize def exist?
    File.exist?(path)
  end

  memoize def file?
    File.file?(path)
  end

  memoize def to_s
    path
  end

  memoize def to_str
    to_s
  end
end
