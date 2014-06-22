
class NatSortArray < Array
  def sort_by_natcmp(options = {})
    self.sort_by do |value|
      sortable_value = if block_given?
        yield value
      else
        value
      end

      to_natcmp(sortable_value, options)
    end
  end

  private
    def to_natcmp(value, options = {})
      if value.respond_to?(:to_natcmp)
        value.to_natcmp
      else
        value = value.dup.to_s
        value.downcase! if options[:no_case]
        value.gsub!(/^the\s+/i, '') if options[:ignore_leading_the]

        i = true
        value.split(/(\d+)/).collect { |z| (i = !i) ? z.to_i : z }
      end
    end
end
