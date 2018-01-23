
class FileMetaDecorator < Draper::Decorator
  delegate_all

  def each
    keys.sort.each do |k|
      yield k.humanize, self[k]
    end
  end

  def [](key)
    case key.to_s
      when 'duration', 'audio_duration', 'video_duration'
        "#{seconds_to_minutes(object[key].to_i / 1000)} (#{object[key]} ms)"
      when 'size'
        h.number_to_human_size(object[key])
      else
        object[key]
    end
  end

  private

    def seconds_to_minutes(seconds)
      minutes, seconds = seconds.divmod(60)
      seconds = seconds.to_s.rjust(2, '0')
      "#{minutes}:#{seconds}"
    end
end
