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