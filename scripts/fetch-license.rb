require 'octokit'
require 'json'

file = File.expand_path File.dirname(__FILE__) + '/info.json'
info = JSON.parse IO.read file

client = Octokit::Client.new(:access_token => ARGV[0])

info.each do |formula|
    name = formula['name']
    homepage = formula['homepage']
    url = formula['stable']['url']
    
    if !(homepage.nil?) && (homepage.include? 'github.com')
        hp_parts = homepage.split('/')
        
        begin
            license = client.repository_license_contents "#{hp_parts[hp_parts.length - 2]}/#{hp_parts[hp_parts.length - 1]}", :accept => 'application/vnd.github.json'
            puts "\"#{name}\": \"#{license['license']['spdx_id']}\","
        rescue
            puts "\"#{name}\": \"\","
        end
    elsif !(url.nil?) && (url.include? 'github.com')
        url_parts = url.split('/')

        begin
            license = client.repository_license_contents "#{url_parts[3]}/#{url_parts[4]}", :accept => 'application/vnd.github.json'
            puts "\"#{name}\": \"#{license['license']['spdx_id']}\","
        rescue
            puts "\"#{name}\": \"\","
        end
    else
        puts "\"#{name}\": \"\","
    end
end
