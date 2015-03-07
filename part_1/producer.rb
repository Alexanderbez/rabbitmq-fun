require 'bunny'
require 'json'

# Part 1: Getting familiar with RabbitMQ. This exerise will simply attempt
# to establish a connection to a running RabbitMQ server and produce and
# consume messages of some generic queue. To spice things up a bit, we'll
# read from a file rather than STDIN or using just Strings.

# Create our Bunny client
conn = Bunny.new()

# Start our connection
puts 'Connecting to RabbitMQ...'
conn.start

# Create our channel
channel = conn.create_channel

# Define our queue on our channel
queue = channel.queue('bunny_queue_1')

work = JSON.parse(File.read('work.json'))

# 'Publish' each bit of work to the queue
work.each do |part|
  puts "Publishing message: #{part}..."
  channel.default_exchange.publish(work.to_json, routing_key: queue.name)
end

# Close our RabbitMQ connection
puts 'Closing connection...'
conn.close
