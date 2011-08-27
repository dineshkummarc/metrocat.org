require 'jekyll/page'

module Jekyll
  
  class Post

    alias old_to_liquid to_liquid

    def to_liquid
      payload = old_to_liquid
      
      if payload.has_key?('summary')
        summary = payload['summary'] || ''
        payload['summary']= converter.convert(summary)
      end

      payload
    end
    
  end
  
end
