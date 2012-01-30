require 'jekyll/site'

module Jekyll
  
  class Site
    attr_reader :page_children
    
    def add_child_page_to_dir(page, dir)
      if (@page_children.nil?)
        @page_children = {}
      end
      
      children = @page_children[dir]
      if (!children)
        children = @page_children[dir] = []
      end


      page.categories.each { |c| self.categories[c] << page }
      page.tags.each { |c| self.tags[c] << page }
      
      children << page
    end

    # alias old_read_layouts read_layouts
    
    # def read_layouts(dir='..')
    #   old_read_layouts(dir)
    # end
    
    alias old_site_payload site_payload
    
    def site_payload
      payload= old_site_payload
      categories= self.categories
      payload["site"]["categories"] = categories
      payload["site"]["categories_sorted"]= categories.sort { |a,b| a[0].downcase<=>b[0].downcase }
      dated_pages = self.pages.select { |p| p.date }
      payload["site"]["pages"] = dated_pages.sort { |a, b| b <=> a }
      
      payload
    end
    
    # alias old_site_payload site_payload
    # 
    # def site_payload
    #   payload= old_site_payload
    #   categories= payload["site"]["categories"]
    #   payload["site"]["categories_sorted"]= categories.sort { |a,b| a[0].downcase<=>b[0].downcase }
    #   payload
    # end
  end
  
end

