require 'elasticsearch'

DEBUG = false
failed_opens = 0
id = 0

client = Elasticsearch::Client.new

users = Dir.entries('./enron_email').delete_if {|n| n == '.' or n == '..' }
  .map {|u| {id: u, name: u.split('-').map {|w| w.capitalize }.join(' ') } }

users.each do |user|
  user[:folders] = Dir.entries("./enron_email/#{user[:id]}").delete_if {|n| n == '.' or n == '..' }
    .map {|f| {id: f, name: f.split(/[-|_]/).map {|w| w.capitalize }.join(' ') } }
end

users.each do |user|
  user[:folders].each do |folder|
    if Dir.exists?("./enron_email/#{user[:id]}/#{folder[:id]}")
      Dir.entries("./enron_email/#{user[:id]}/#{folder[:id]}").delete_if {|n| n == '.' or n == '..' }.each do |file|
        puts "./enron_email/#{user[:id]}/#{folder[:id]}" if DEBUG
        begin
          content = File.open("./enron_email/#{user[:id]}/#{folder[:id]}/#{file}").read
          client.index index: 'enron_emails', type: 'message', id: id, body: { user: user[:name], folder: folder[:name], message: content }
          id = id + 1
          puts "#{(id / 1000).floor} K" if id % 1000 == 0
        rescue
          failed_opens = failed_opens + 1
        end
      end
    end
  end
end