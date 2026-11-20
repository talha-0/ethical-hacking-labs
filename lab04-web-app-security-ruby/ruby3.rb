if ARGV.empty?
    puts "Usage: ruby ./ruby3.rb <filename>"
    exit
  end
  
  filename = ARGV[0]
  frequencies = Hash.new(0)
  
  # Read file, split into words by whitespace, and increment the hash counter
  File.read(filename).split.each do |word|
    frequencies[word] += 1
  end
  
  puts "Word frequency:"
  frequencies.each do |word, count|
    puts "#{word} #{count}"
  end