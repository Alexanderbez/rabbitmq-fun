require 'bunny'
require 'json'

# Part 2: This exercise will simulate actual work using 'worker' queues. A
# producer will pass various messages that represent resource/time intensive
# work to a 'worker' queue and various 'workers' will poll this queue to
# perform the work.
#
# In addition, durability of messages will be used.

conn = Bunny.new()
puts 'Starting connection...'
conn.start

channel = conn.create_channel

queue = channel.queue('worker_queue')

# Our blob of work to be done
work = JSON.parse(File.read('work.json'))

work.each do |job|
  puts "Publishing message: #{job}"
  channel.default_exchange.publish(
    job.to_json,
    routing_key: queue.name,
    persistent: true,
    content_type: 'application/json',
    timestamp: Time.now.to_i
  )
end

puts 'Closing connection...'
conn.close
