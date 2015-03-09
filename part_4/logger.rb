require 'bunny'

# Part 4: Learning more about different types of exchanges. Unlike Part 3, here
# we do not want each queue to recieve each message. Rather, we assign a
# 'routing_key' to both the exchange and queue (per message basis) that will
# determine what queue(s) pick up the messages.

# Create our Bunny instance and start the connection
conn = Bunny.new()
puts 'Starting connection...'
conn.start

# Nothing new, just create our channel
channel = conn.create_channel
channel.prefetch(1)

# Create a direct exchange
exchange = channel.direct('bunny_logger_direct')

levels = ['debug', 'info', 'warn', 'error']

5.times do
  t     = Time.now.to_s
  # Pick a random logging level
  level = levels.sample
  log   = "[#{level}] - [#{t}]: Some log event"

  # Publish the log via the exchange and provide a routing key so the
  # appropriate queue(s) can pick it up.
  exchange.publish(log, routing_key: level)
end

puts 'Closing connection...'
conn.close
