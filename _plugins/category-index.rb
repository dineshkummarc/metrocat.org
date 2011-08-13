module Jekyll
  
  class CategogyIndexGenerator < Generator
    safe true
    priority :low
    
    def generate(site)
      if site.layouts.key? 'category_index'
        dir = site.config['category_dir']
        site.categories.keys.each do |category|
          category_folder_name = category.linkify
          path= dir ? File.join(dir, category_folder_name) : category_folder_name
          write_category_index(site, path, category)
        end
      end
    end

    def write_category_index(site, dir, category)
      index = CategoryIndexPage.new(site, site.source, dir, category)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.static_files << index
    end

  end
  
    
  class CategoryIndexPage < Page
    
    # Initialize a new CategoryIndex.
    #   +base+ is the String path to the <source>
    #   +dir+ is the String path between <source> and the file
    #
    # Returns <CategoryIndex>
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['category'] = category
      category_title_prefix = site.config['category_title_prefix'] || 'Category: '
      self.data['title'] = "#{category_title_prefix}#{category}"
    end
  end
  
end