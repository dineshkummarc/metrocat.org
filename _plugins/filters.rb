module Jekyll

  module Filters

    def keys(hash)
      hash.keys
    end
    
    # Fix broken date_to_long_string format.
    def date_to_long_string(date)
      date.strftime("%e %B %Y")
    end
    
  end
  
end
