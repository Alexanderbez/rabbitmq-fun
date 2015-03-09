require 'bunny'

# Part 4: Learning more about different types of exchanges. Unlike Part 3, here
# we do not want each queue to recieve each message. Rather, we assign a
# 'routing_key' to both the exchange and queue (per message basis) that will
# determine what queue(s) pick up the messages.

abort 'Must provide at least one logging level' if ENV['LOG'].nil?

# Create our Bunny instance and start the connection
conn = Bunny.new()
puts 'Starting connection...'
conn.start

# Nothing new, just create our channel
channel = conn.create_channel

# Create a direct exchange
exchange = channel.direct('bunny_logger_direct')

# Create random queue and destroy queue after connection is closed
queue = channel.queue('', exclusive: true)

# Get desired logging levels and bind them
ENV['LOG'].split(',').each do |level|
  # Bind the queue to the direct exchange and only accept messages with
  # logs of a certain level
  queue.bind(exchange, routing_key: level)
end

begin
  puts 'Waiting for logs...'
  queue.subscribe(block: true, manual_ack: true) do |delv_info, props, body|
    puts "#{body}"

    channel.ack(delv_info.delivery_tag)
  end
rescue Exception, Interupt => _
  puts 'Closing channel...'
  channel.close
  puts 'Closing connection...'
  conn.close
end
