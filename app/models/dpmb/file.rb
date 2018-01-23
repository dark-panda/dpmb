
class Dpmb::File < Dpmb::Path
  extend Memoist

  memoize def file_type
    MimeMagic.by_path(path).type if exist?
  end

  memoize def file_size
    File.size(path) if exist?
  end

  memoize def file_meta
    Hashie::Mash.new.tap do |retval|
      retval[:size] = file_size
      retval[:type] = file_type

      next unless exist?

      meta = Mediainfo.new(path)
      Mediainfo.supported_attributes.each do |attribute|
        value = meta.send(attribute) rescue nil
        retval[attribute] = value if value.present?
      end
    end
  end
end
