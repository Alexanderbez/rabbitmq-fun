# Fun with RabbitMQ

Learning the basics of how to use RabbitMQ in a Ruby environment by following the tutorials found on [RabbitMQ's site](http://www.rabbitmq.com/).

## Prerequisites

Prior to each example, make sure RabbitMQ is running locally:

```shell
$ rabbitmq-server
```

This will have RabbitMQ run on `127.0.0.1:5672`. RabbitMQ also comes with a pretty cool web interface to see all the nitty-gritty details! Visit `http://lvh.me:15672`

Also, make sure the dependencies are installed:

```shell
$ bundle install
```

## Part 1

Here, we're just reading some 'work' from a file and putting it on a queue called `bunny_queue_1`.

Lets have the consumer wait to consume messsages(work):

```shell
$ bundle exec ruby consumer.rb
```

Lets have the producer exchange the messages:

```shell
$ bundle exec ruby producer.rb
```

## Part 2

Similar to Part 1, except now we have multiple 'workers' to handle messages. In addition, messages are 'durable', we're using acknowledgements and we're not allowing a worker to have more than one message at a time. In otherwords, they are written to disk if something goes wrong.

Lets have __two__ workers waiting for messages. So in __two__ consoles:

```shell
$ bundle exec ruby worker.rb
```

And, lets have our producer throw some 'work' onto the queue:

```shell
$ bundle exec ruby producer.rb
```

## Part 3

Here we learn about exchanges. Opposed to having a producer directly put messages onto a queue, we're using an exchange protocol that will be responsible for telling where the messages to go and what to do. This allows use to have the messages goto multiple consumers at the same time. This simulates more of a real-world use case.

We're going to simulate logging events here.

Lets have __two__ consumers running to recieve these logs:

```shell
$ bundle exec ruby log_gobbler.rb
```

Now lets have some logging events emitted:

```shell
$ bundle exec ruby logger.rb
```

You'll notice both log consumers (gobblers) will recieve the same events. That's because we're using a `fanout` exchange. The exchange protocol tells each queue that has a `binding` to the exchange to consume the message.

## Part 4

Learning more about different types of exchanges. Unlike Part 3, here we do not want each queue to recieve each message. Rather, we assign a 'routing_key' to both the exchange and queue (per message basis) that will determine what queue(s) pick up the messages.


Lets have __two__ consumers running to recieve logs. However, each reciever will only listen for messages that pertain to a specific level:

```shell
$ LOG=info,debug bundle exec ruby log_gobbler.rb
```

```shell
$ LOG=warn,error bundle exec ruby log_gobbler.rb
```

Now lets have some logging events emitted:

```shell
$ bundle exec ruby logger.rb
```