require 'net/http'
require 'pp'

num_children = ARGV[0]

log_file = File.new('multithreadHTTP_output.txt','w');

log_file.puts "---------------------"
log_file.puts "|       Start       |"
log_file.puts "---------------------"

emails = Array.new()

File.open('emails.csv','r').each_line do |line|
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
            url = URI.parse(ARGV[1])
            log_file.puts "Child #{i} [#{pid}] sending request: #{url.host}"
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
