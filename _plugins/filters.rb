class String
  def linkify
    self.downcase.gsub(/\s+/, '-').gsub(/--+/, '-').gsub(/[^a-z0-9\-]+/, '')
  end
end

module Jekyll

  module Filters

    def keys(hash)
      hash.keys
    end
    
    # Fix broken date_to_long_string format.
    def date_to_long_string(date)
      date.strftime("%e %B %Y")
    end
    
    def to_month(string)
      month = "#{string}".to_i - 1
      ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"][month]
    end
    
    def linkify(string)
      string.linkify
    end
    
    def hostname(string)
      uri = URI::parse(string) rescue nil
      return uri ? uri.host : string
    end
    
  end
  
end
