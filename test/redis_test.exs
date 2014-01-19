defmodule RedisTest do
  use ExUnit.Case, async: true
  alias Redis, as: R

  setup_all do
    R.start
    :ok
  end

  setup do
    R.flushall
    :ok
  end

  test "get and set works" do
    assert R.set(:a, 3) == :ok
    assert R.get(:a) == "3"
  end

  test "sadd and smembers works" do
    assert R.sadd("testset", "a") == 1

    members = R.smembers("testset")
    assert length(members) == 1

    assert R.sadd("testset", "b") == 1

    members = R.smembers("testset")
    assert length(members) == 2
  end

  test "scard works" do
    assert R.sadd("testset", "a") == 1

    assert R.scard("testset") == 1

    assert R.sadd("testset", "b") == 1

    assert R.scard("testset") == 2
  end

  test "sismember works" do
    assert R.sadd("testset", "a") == 1
    assert R.sadd("testset", "b") == 1

    assert R.sismember("testset", "a") == 1
    assert R.sismember("testset", "c") == 0
  end

  test "spop removes and returns the element" do
    assert R.sadd("testset", "a") == 1

    value = R.spop("testset")

    assert value == "a"
    assert R.scard("testset") == 0
  end

  test "srandmember does not remove the element" do
    assert R.sadd("testset", "a") == 1

    value = R.srandmember("testset")

    assert value == "a"
    assert R.scard("testset") == 1
  end

  test "srem removes members properly" do
    assert R.sadd("testset", "a") == 1
    assert R.sadd("testset", "b") == 1

    assert R.srem("testset", "a") == 1
    assert R.sismember("testset", "a") == 0
    assert R.scard("testset") == 1
  end

  test "srem returns 0 if the member doesn't exist" do
    assert R.sadd("testset", "a") == 1
    assert R.sadd("testset", "b") == 1

    assert R.srem("testset", "c") == 0
    assert R.scard("testset") == 2
  end

  test "ttl works" do
    assert R.set(:pi, "asd") == :ok
    assert R.ttl(:pi) == -1
  end

  test "expire works" do
    R.set(:expire, 3)
    assert R.expire(:expire, 3) == 1
    assert R.ttl(:expire) >= 1
  end

  test "flushall works" do
    assert R.flushall == :ok
  end
end
