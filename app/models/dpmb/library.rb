
class Dpmb::Library
  extend Memoist

  class Settings < Hashie::Mash
    extend Memoist

    def initialize(*)
      super

      self.include_paths ||= []
      self.exclude_paths ||= []
      self.include_file_types ||= []
      self.exclude_file_types ||= []
    end
  end

  attr_accessor :settings

  def initialize(settings = {})
    self.settings = Dpmb::Library::Settings.new(settings)
  end

  memoize def local_path_regexp
    %r{^#{settings.path}}
  end

  memoize def include_regexp
    %r{^#{settings.path}/(#{settings.include_paths.join('|')})}
  end

  memoize def include_file_types_regexp
    %r{\.(#{settings.include_file_types.join('|')})$}
  end

  memoize def exclude_regexp
    %r{^#{settings.path}/(#{settings.exclude_paths.join('|')})}
  end

  memoize def exclude_file_types_regexp
    %r{\.(#{settings.exclude_file_types.join('|')})$}
  end

  def path_included?(path)
    return true if settings.include_paths.blank?
    path =~ include_regexp
  end

  def file_type_included?(path)
    return true if settings.include_file_types.blank?
    path =~ include_file_types_regexp
  end

  def path_excluded?(path)
    return false if settings.exclude_paths.blank?
    path =~ exclude_regexp
  end

  def file_type_excluded?(path)
    return false if settings.exclude_file_types.blank?
    path =~ exclude_file_types_regexp
  end

  def public_file?(path)
    file?(local_path(path))
  end

  def local_path(path)
    File.join(settings.path, path.to_s)
  end

  def file?(path)
    begin
      path = File.realpath(path)
      File.file?(path)
    rescue Errno::ENOENT
      false
    end
  end

  def zip(*files)
    files = files.flatten
    glob = Dir.glob(File.join(settings.path, "{#{files.join(',')}}"))

    stream = Zip::OutputStream.write_buffer do |out|
      glob.each do |file|
        out.put_next_entry(File.basename(file), nil, nil, nil, 0)
        out.write(File.read(file))
      end
    end

    stream.rewind
    stream
  end

  def file(path)
    realpath = File.realpath(local_path(path))

    return nil if realpath !~ local_path_regexp

    collect_files(realpath)[0]
  end

  def glob(path)
    realpath = File.realpath(local_path(path))

    return [] if realpath !~ local_path_regexp

    collect_files(realpath, '*')
  end

  private

    def collect_files(*path_components)
      Dir.glob(File.join(*path_components)).select { |path|
        check_real_path(path)
      }.collect { |path|
        if file?(path)
          Dpmb::File.new(path)
        else
          Dpmb::Path.new(path)
        end
      }
    end

    def check_real_path(path)
      retval = false

      if path_included?(path) && !path_excluded?(path)
        retval = true
        retval = file_type_included?(path) && !file_type_excluded?(path) if file?(path)
      end

      retval
    end
end
