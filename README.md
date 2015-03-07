# Fun with RabbitMQ

Learning the basics of how to use RabbitMQ in a Ruby environment by following the tutorials found on [RabbitMQ's site](http://www.rabbitmq.com/).

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

Let's have the producer exchange the messages:

```shell
$ bundle exec ruby producer.rb
```

Now let's have the consumer consume these messsages(work):

```shell
$ bundle exec ruby consumer.rb
```

## Part 2