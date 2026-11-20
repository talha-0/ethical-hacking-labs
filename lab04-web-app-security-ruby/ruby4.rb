if ARGV.empty?
  puts "Usage: ruby ./ruby4.rb <filename>"
  exit
end

filename = ARGV[0]
content = File.read(filename)

# Regex matches opening (<) or closing (</) angle brackets followed by word characters
# It downcases just the tag name, preserving case-sensitive URLs or attributes inside the tag
modified_content = content.gsub(/<\/?\w+/) do |match|
  match.downcase
end

puts modified_content