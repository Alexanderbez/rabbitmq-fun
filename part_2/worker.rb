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

# Do NOT allow a worker to have more than one message at a time. This allows
# fair dispatch of messages from the queue.
channel.prefetch(1)

queue = channel.queue('worker_queue')

begin
  puts "Waiting for work to perform on queue: #{queue.name}..."
  queue.subscribe(manual_ack: true, block: true) do |dev_info, props, data|
    work = JSON.parse(data)['job']
    puts "Performing work: #{work}"
    sleep(work.count('*'))

    # Acknowledge delivery
    channel.ack(dev_info.delivery_tag)
    puts "Done performing work: #{work}"
  end
rescue Exception, Interupt => _
  puts 'Closing connection...'
  conn.close
end
