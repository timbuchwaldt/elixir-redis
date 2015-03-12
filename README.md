# Discontinued
As there are way better implementations this repo ist discontinued. Use [artemeffs awesome implementation](https://github.com/artemeff/exredis)!

[![Build Status](https://travis-ci.org/timbuchwaldt/elixir-redis.png?branch=master)](https://travis-ci.org/timbuchwaldt/elixir-redis)
# Elixir Redis

A easy Elixir client for Redis, based on the awesome [eredis](https://github.com/wooga/eredis).

As this is more of a alpha-playground (and my first real elixir project), I suggest you use [artemeffs awesome implementation](https://github.com/artemeff/exredis)!

# Usage

Add this line to your mix.exs-file:


    { :redis, "1.2.0", github: "timbuchwaldt/elixir-redis", tag: '1.2.0'}

In your code you have to set up a redis connection: ```Redis.start```
The client saves its connection to the process registry, for simple calls you don't have to do anything else. You can now use the form Redis.$command($variables):


    Redis.set(:a, 3)
    Redis.get(:a)
