# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts '###################'
puts '#     GROUPS      #'
puts '###################'

VK_GROUPS.each do |vk_group_url|
  g = Group.create url: vk_group_url
  puts "#{g.url} => #{g.screen_name}"
end