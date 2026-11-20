# Initialize the array from 1 to 1000
arr = (1..1000).to_a

puts "--- For Loop ---"
for num in arr
  puts num
end

puts "--- While Loop ---"
i = 0
while i < arr.length
  puts arr[i]
  i += 1
end

puts "--- Iterator ---"
arr.each do |num|
  puts num
end