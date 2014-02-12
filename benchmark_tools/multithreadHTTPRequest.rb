require 'net/http'
require 'pp'

numChildren = ARGV[1]

numChildren.to_i.times do |i|
    pid = fork do
        puts "Process #{i} started"
        begin
            url = URI.parse(ARGV[0])
            req = Net::HTTP::Get.new(url.to_s)
            res = Net::HTTP::start(url.host, url.port) {|http|
                http.request(req)
            }
            puts "Child #{i} got response #{res.body}"
        end while res.code == "200"
        puts "Process #{i} ended"
        exit
    end
end
puts "All done"
exit
