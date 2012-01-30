# require 'digest/md5'
# include Liquid::StandardFilters
# require "#{File.dirname(__FILE__)}/rubypants.rb"
# 
# module Jekyll
#   class MarkdownConverter
#     alias original_convert convert
# 
#     CODE_REGEX = /<pre><code>(.*)<\/code><\/pre>/m
#     
#     def convert(content)
#       content= gfm(content)
#       content= original_convert(content).gsub(CODE_REGEX) { |match|
#         info= $1.match(/^([!#])(\w+)\n(.*)/m)
#         if (info)
#           lang= info[2] ? info[2].to_sym : :text
#           options= 'encoding=utf-8'
#           options << ",linenos=inline" if '#'==info[1]
#           options= {:O => options}
#           text= Albino.new(info[3], lang).to_s(options)
#         else
#           text= match
#         end
#         text
#       }
#       RubyPants.new(content).to_html
#     end
# 
#     def gfm(text)
#       # Extract pre blocks
#       extractions = {}
#       text.gsub!(%r{<pre>.*?</pre>}m) do |match|
#         md5 = Digest::MD5.hexdigest(match)
#         extractions[md5] = match
#         "{gfm-extraction-#{md5}}"
#       end
# 
#       # prevent foo_bar_baz from ending up with an italic word in the middle
#       text.gsub!(/(^(?! {4}|\t)\w+_\w+_\w[\w_]*)/) do |x|
#         x.gsub('_', '\_') if x.split('').sort.to_s[0..1] == '__'
#       end
# 
#       # in very clear cases, let newlines become <br> tags
#       # text.gsub!(/^[\w\<][^\n]*\n+/) do |x|
#       #   x =~ /\n{2}/ ? x : (x.strip!; x << "  \n")
#       # end
# 
#       # Insert pre block extractions
#       text.gsub!(/\{gfm-extraction-([0-9a-f]{32})\}/) do
#         "\n\n" + extractions[$1]
#       end
# 
#       text
#     end
#     
#   end
# end
# 
