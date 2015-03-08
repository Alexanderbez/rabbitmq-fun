require 'bunny'

# Part 3: This exercise will make use of non-default exchanges. In otherwords,
# the producer in this case will not know about any queues. Rather, it will
# provide messages to an exchange and the exchange will know where/how to deal
# deal with the messages. This represents more of a real-world use
# case/situation.

# Create our Bunny instance and start the connection
conn = Bunny.new()
puts 'Starting connection...'
conn.start

# Nothing new, just create our channel
channel = conn.create_channel

# Create our non-default exchange. We will use a fanout exchange.
exchange = channel.fanout('bunny_logger')

# Lets simulate some logging
5.times do
  # Create some fake logging event
  t = Time.now.to_s
  log = "[#{t}]: Logging some event..."
  sleep(5)

  # Publish the log to our exchange. Notice, we're not telling it what queue
  # to use.
  exchange.publish(log)
end

puts 'Closing connection...'
conn.close
