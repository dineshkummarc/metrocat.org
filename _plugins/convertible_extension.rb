require 'jekyll/convertible'
require 'active_support/inflector'

module Jekyll
  MORE_REGEX = /<!--\s*more\s*-->/i
  
  module Convertible
    alias old_read_yaml read_yaml

    def read_yaml(base, name)
      old_read_yaml(base, name)
      if Layout!=self.class
        self.data["path"]= File.join(base, name)
      end
      yaml_section= self.class.to_s.demodulize.underscore
      if @site.config[yaml_section]
        self.data.merge!(@site.config[yaml_section])
      end

      if self.data.has_key?('date')
        # ensure Time via to_s and reparse
        self.date = Time.parse(self.data["date"].to_s)
      end

      summary = self.data['summary']
      body = (self.content || '')
      
      if !self.data.has_key?('summary') && body[MORE_REGEX]
        self.data['summary'] = body.split(MORE_REGEX)[0] || ''
      end
      
      self.after_read_yaml
      
      self.data
    end
    
    def after_read_yaml
    end
    
    def path
      @path
    end
    
  end
  
end
