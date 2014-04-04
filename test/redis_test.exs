defmodule RedisTest do
  use ExUnit.Case, async: false
  alias Redis, as: R

  test "start with arguments" do
    {:ok, pid} = R.connect(host: '127.0.0.1',
            port: 6379,
            db: 2,
            password: '')
    assert R.set(pid, :a, 3) == :ok
    assert R.get(pid, :a) == "3"
    assert R.stop(pid) == :ok
  end

  test "stop" do
    {:ok, pid} = R.connect()
    assert R.stop(pid) == :ok
  end

  test "multiple databases" do
    {:ok, db1} = R.connect(db: 1)
    {:ok, db2} = R.connect(db: 2)
    db1 |> R.set(:key, "val1")
    db2 |> R.set(:key, "val2")
    assert db1 |>R.get(:key) == "val1"
    assert db2 |>R.get(:key) == "val2"
    R.stop(db1)
    R.stop(db2)
  end

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

  test "del works" do
    R.set(:a, 3)
    assert R.del(:a) == 1
    assert R.get(:a) == :undefined
  end

  test "rpush works" do
    assert R.rpush(:a, "Hello") == 1
    assert R.rpush(:a, "world!") == 2
  end

  test "lrange works" do
    R.rpush(:a, "Hello")
    R.rpush(:a, "world!")
    assert R.lrange(:a, "0", "-1") == ["Hello", "world!"]
  end

  test "zadd works" do
    assert R.zadd(:a, 1, "foo") == 1
    assert R.zadd(:a, 2, "bar") == 1
    assert R.zadd(:a, 1, "foo") == 0
  end

  test "zrem works" do
    R.zadd(:a, 1, "foo")
    assert R.zrem(:a, "foo") == 1
    R.zadd(:a, 1, "bar")
    R.zadd(:a, 1, "bar")
    assert R.zrem(:a, "bar") == 1
    assert R.zrem(:a, "mumble") == 0
  end

  test "incr works" do
    assert R.incr(:a) == 1
    assert R.incr(:a) == 2
    assert R.incr(:a) == 3
  end

  test "publish works" do
    assert R.publish(:a, "foo") == 0
  end

  #test "subscribe works" do
  #  R.subscribe(:a)
  #end

  #test "unsubscribe works" do
  #end

  test "multi works" do
    result = R.multi fn ->
      R.set(:a, "foo")
      R.get(:a)
    end
    assert result == [:ok, "foo"]
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

  test "setex works" do
    assert R.setex(:a, 3, 3) == :ok
    assert R.get(:a) == "3"
  end

  test "setex expire works" do
    R.setex(:expire, 3, 3)
    assert R.ttl(:expire) >= 1
  end

  test "flushall works" do
    assert R.flushall == :ok
  end

  test "hset works" do
    R.hset(:set, :foo, 1)
    assert R.hget(:set, :foo) == "1"
  end
end
