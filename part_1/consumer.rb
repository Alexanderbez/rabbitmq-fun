require 'bunny'
require 'json'

# Part 1: Getting familiar with RabbitMQ. This exerise will simply attempt
# to establish a connection to a running RabbitMQ server and produce and
# consume messages of some generic queue. To spice things up a bit, we'll
# read from a file rather than STDIN or using just Strings.

# Create our RabbitMQ connection
conn = Bunny.new()

# Start our connection
puts 'Connecting to RabbitMQ...'
conn.start

# Create our channel
channel = conn.create_channel

# Create (or get) our queue
# NOTE: The queue can be defined/created before any messages are
# actually published
queue = channel.queue('bunny_queue_1')

puts "Waiting for messages to be published in queue: #{queue.name}..."

# Subscribe to our queue (while blocking)
queue.subscribe(block: true) do |delivery_info, props, data|
  puts "Consuming work: #{JSON.parse(data)}"

  # Cancel the consumer to exit
  delivery_info.consumer.cancel
end

# Close our connection
puts 'Closing connection...'
conn.close
