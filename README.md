[![Build Status](https://travis-ci.org/timbuchwaldt/elixir-redis.png?branch=master)](https://travis-ci.org/timbuchwaldt/elixir-redis)
# Elixir Redis

A easy Elixir client for Redis, based on the awesome [eredis](https://github.com/wooga/eredis).

# Usage

Add this line to your mix.exs-file:


    { :redis, "1.1.0", [ github: "timbuchwaldt/elixir-redis"]}

In your code you have to set up a redis connection: ```Redis.start```
The client saves its connection to the process registry, for simple calls you don't have to do anything else. You can now use the form Redis.$command($variables):


    Redis.set(:a, 3)
    Redis.get(:a)
