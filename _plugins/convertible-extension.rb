require 'jekyll/convertible'
require 'active_support'

module Jekyll
  
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
      self.data
    end
    
    def path
      @path
    end
    
  end
  
end