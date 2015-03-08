require 'bunny'

# Part 3: This exercise will make use of non-default exchanges. In otherwords,
# the producer in this case will not know about any queues. Rather, it will
# provide messages to an exchange and the exchange will know where/how to deal
# deal with the messages. This represents more of a real-world use
# case/situation.

conn = Bunny.new()
puts 'Starting connection...'
conn.start

channel = conn.create_channel
channel.prefetch(1)

# Create a queue with a random name. Also, make sure the queue will be unique
# for this connection only and be destroyed after connection is closed.
queue = channel.queue('', exclusive: true)

# Grab our fanout exchange
exchange = channel.fanout('bunny_logger')

# We must create a binding between the fanout exchange and our random queue
queue.bind(exchange)

begin
  puts 'Waiting for logs...'
  queue.subscribe(block: true, manual_ack: true) do |delvry_info, props, body|
    puts "#{body}"

    # Acknowledge delivery
    channel.ack(delvry_info.delivery_tag)
  end
rescue Exception, Interupt => _
  puts 'Closing channel...'
  channel.close
  puts 'Closing connection...'
  conn.close
end
