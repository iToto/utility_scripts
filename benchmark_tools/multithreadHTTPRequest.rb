require 'net/http'
require 'pp'

email_list_file = 'emails.csv'
url_list_file = 'urls.txt'


unless ARGV[0]
    puts "Invalid Arguments"
    puts "Usage: multithreadHTTP [num_children] [url_index]"
    exit
end

unless ARGV[1]
    puts "Invalid Arguments"
    puts "Usage: multithreadHTTP [num_children] [url_index]"
    exit
end

num_children = ARGV[0]
url_index = ARGV[1]

unless File.exists?(url_list_file)
    puts "Could not find url file #{url_list_file}"
    exit
end

unless File.exists?(email_list_file)
    puts "Could not find email file #{email_list_file}"
    exit
end

log_file = File.new('multithreadHTTP_output.txt','w');

log_file.puts "---------------------"
log_file.puts "|       Start       |"
log_file.puts "---------------------"

urls = Array.new()
File.open('urls.txt','r').each_line do |line|
    urls.push(line)
end

emails = Array.new()

File.open(email_list_file,'r').each_line do |line|
    line = line.strip.split ','
    email = {
        :messageKey => line.first.to_s,
        :email => line.last.to_s
    }
    emails.push(email)
end

num_children.to_i.times do |i|
    pid = fork do
        log_file.puts "Process #{i} started with pid: #{pid}"
        max_requests    = 10
        current_request = 0

        begin
            email = emails[0][:email]
            mkey  = emails[0][:messageKey]
            url = URI.parse(urls[url_index.to_i])
            log_file.puts "Child #{i} [#{pid}] sending to server: #{urls[url_index.to_i]}"
            req = Net::HTTP::Get.new(url.to_s)
            res = Net::HTTP::start(url.host, url.port) {|http|
                http.request(req)
            }
            log_file.puts "Child #{i} [#{pid}] got response #{res.body}"
            current_request += 1

        end while res.code == "200" && current_request < max_requests
        log_file.puts "Process #{i} [#{pid}] ended"
        log_file.puts "---------------------"
        log_file.puts "|        END        |"
        log_file.puts "---------------------"
        exit
    end
end
puts "All done"
exit
