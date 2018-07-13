require 'fileutils'
# Run this with: rails runner "eval(File.read 'db/insert-images.rb')"

Dir.entries("project/graphics/insert").each do |file_name|
  found = false
  name = file_name.sub('.png','').parameterize
  players = Player.where(parameterized_name: name)
  if players.size == 1
    player = players.first  
    found = true
    player.player_photo = File.new("project/graphics/insert/#{file_name}")
    player.save
  end
  
  if !found
    players = Player.named(name)
    if players.size == 1
      player = players.first
      found = true
      player.player_photo = File.new("project/graphics/insert/#{file_name}")
      player.save              
    end
  end
  
  if !found
    puts("Did not find #{file_name}")
  else
    FileUtils.mv("project/graphics/insert/#{file_name}", "project/graphics/moved/#{file_name}")
  end
end

=begin
Dir.entries("project/graphics/insert").each do |file_name|
  code = file_name.sub('.png','')
  team = Team.where(code: code).first
  if !team.nil?
    team.club_crest = File.new("project/graphics/insert/#{file_name}")
    team.save
  end  
end

Dir.entries("project/graphics/insert").each do |file_name|
  name = file_name.sub('.png','')
  stadium = Stadium.where(name: name).first
  if !stadium.nil?
    stadium.photo = File.new("project/graphics/insert/#{file_name}")
    stadium.save
  else
    puts("Did not find stadium #{name}.")
  end  
end
=end
