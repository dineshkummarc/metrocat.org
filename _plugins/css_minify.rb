module Jekyll
  MINIFIED_FILENAME = Time.new.strftime("%Y%m%d%H%M") + '.min.css'

  # use this as a workaround for getting cleaned up
  # reference: https://gist.github.com/920651
  class CssMinifyFile < StaticFile
    def write(dest)
      # do nothing
    end
  end

  # minify css files
  class CssMinifyGenerator < Generator
    safe true

    def generate(site)
      config = Jekyll::CssMinifyGenerator.get_config(site)
      
      files_to_minify = config['files'] || get_css_files(site, config['css_source'])

      output_dir = File.join(site.config['destination'], config['css_destination'])
      output_file = File.join(output_dir, MINIFIED_FILENAME)
      # need to create destination dir if it doesn't exist
      FileUtils.mkdir_p(output_dir)
      minify_css(files_to_minify, output_file)
      site.static_files << CssMinifyFile.new(site, site.source, config['css_destination'], MINIFIED_FILENAME)
    end

    # read the css dir for the css files to compile
    def get_css_files(site, relative_dir)
      # not sure if we need to do this, but keep track of the current dir
      pwd = Dir.pwd
      Dir.chdir(File.join(site.config['source'], relative_dir))
      # read css files
      css_files = Dir.glob('*.css').map{ |f| File.join(relative_dir, f) }
      Dir.chdir(pwd)

      return css_files
    end

    def minify_css(css_files, output_file)
      css_files = css_files.join(' ')
      juice_cmd = "juicer merge -f #{css_files} -o #{output_file}"
      puts juice_cmd
      system(juice_cmd)
    end

    # Load configuration from CssMinify.yml
    def self.get_config(site)
      return @config if @config
      
      @config = {
        'css_source' => 'css', # relative to the route
        'css_destination' => '/css' # relative to site.config['destination']
      }
      config = site.config["css_minify"]
      if config.is_a?(Hash)
        @config = @config.merge(config)
      end
      return @config
    end
  end

  class CssMinifyLinkTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      site = context.registers[:site]
      config = Jekyll::CssMinifyGenerator.get_config(site)
      File.join(config['css_destination'], MINIFIED_FILENAME)
    end
  end
end

Liquid::Template.register_tag('minified_css_file', Jekyll::CssMinifyLinkTag)