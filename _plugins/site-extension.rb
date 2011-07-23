require 'jekyll/site'

module Jekyll
  
  class Site
    alias old_site_payload site_payload
    
    def site_payload
      payload= old_site_payload
      categories= payload["site"]["categories"]
      payload["site"]["categories_sorted"]= categories.sort { |a,b| a[0].downcase<=>b[0].downcase }
      payload
    end
  end
  
end

