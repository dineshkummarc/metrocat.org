require 'jekyll/convertible'
require 'active_support/inflector'

module Jekyll

  class Page
    attr_accessor :date
    attr_accessor :categories, :tags
    
    def after_read_yaml
      self.tags = self.data.pluralized_array("tag", "tags")
      self.categories = self.data.pluralized_array('category', 'categories')

      @site.add_child_page_to_dir(self, @dir)
    end
    
    def template
      if self.site.permalink_style == :pretty && !index? && html?
        "/:basename"
      else
        "/:basename:output_ext"
      end
    end

    # Spaceship is based on Post#date, slug
    #
    # Returns -1, 0, 1
    def <=>(other)
      cmp = self.date <=> other.date
      if 0 == cmp
       cmp = self.basename <=> other.basename
      end
      return cmp
    end

    alias old_url url
    
    def url
      return @url if @url

      url = if permalink
        permalink
      else
        {
          "basename"   => self.basename,
          "output_ext" => self.output_ext,
        }.inject(template) { |result, token|
          result.gsub(/:#{token.first}/, token.last)
        }.gsub(/\/\//, "/")
      end

      # sanitize url
      @url = url.split('/').reject{ |part| part =~ /^\.+$/ }.join('/')
      # @url += "/" if url =~ /\/$/
      @url
    end
    
    def destination(dest)
      # The url needs to be unescaped in order to preserve the correct
      # filename.
      path = File.join(dest, @dir, CGI.unescape(self.url))
      ext = path[-output_ext.length..-1]
      if (ext!=output_ext)
        path = "#{path}#{output_ext}"
      end
      # path = File.join(path, "index.html") if self.url =~ /\/$/
      path
    end

    def children
      @site.page_children[File.join(@dir, self.url)] || []
    end

    alias old_to_liquid to_liquid

    def to_liquid
      payload = old_to_liquid
      
      payload['children']= children
      if (self.date)
        payload['year'] = self.date.year
        payload['month'] = self.date.month
        payload['day'] = self.date.day
      end

      payload
    end
    
  end
end