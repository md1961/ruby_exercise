class IPAddressFilter

  def initialize(condition)
    @octet_filters = condition.split('.')
  end

  def pass?(ip_address)
    octets = ip_address.split('.')
    octets.zip(@octet_filters).each do |octet, filter|
      return false unless octet_pass?(octet, filter)
    end
    true
  end
  
  private
    
    def octet_pass?(octet, filter)
      return true if filter == '*'
      return true if filter =~ /\A\d+\z/ && octet == filter
      if filter =~ /\A\[(\d+)-(\d+)\]\z/
        octet_from = Regexp.last_match[1].to_i
        octet_to   = Regexp.last_match[2].to_i
        return octet.to_i.between?(octet_from, octet_to)
      end
      false
    end
end


if __FILE__ == $0
  ip_address_filter = IPAddressFilter.new(gets.chomp)
  
  n_logs = gets.to_i
  
  n_logs.times.each do
    log_items = gets.split
    ip_address = log_items.first
    if ip_address_filter.pass?(ip_address)
      raw_date = log_items[3]
      date = raw_date[1, raw_date.size]
      file_name = log_items[6]
      
      puts [ip_address, date, file_name].join(' ')
    end
  end
end
