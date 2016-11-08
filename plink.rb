require 'open-uri'
require 'nokogiri'
require 'optparse'


options = {}
parser = OptionParser.new do|opts|
  opts.on('-n', '--website website', 'website') do |website|
   options[:website] = website
  end   
  opts.on('-h', '--help', 'Displays Help') do
   puts opts
   exit
  end
end
parser.parse!

if options[:website].nil?
  print 'Enter site: '
  options[:website] = gets.chomp
end
url = options[:website]
content = Nokogiri::HTML(open(url))
puts "title: " +content.css('title').text
['h1','h2','h3','h4'].each{|tag| puts tag +":\n"+content.css(tag).map(&:text).join("\n")}
links = content.css('a').map do |link| 
	URI::join(url, links) if (links = link.attr("href")) && !links.empty?
end.compact.uniq
puts "Links:\nInternal:"+"\n" 
internal=links.select {|n| n.to_s.include?(url)}
puts internal
puts "\nexternal:\n"
external=links.reject {|n| n.to_s.include?(url)}
puts external
