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

  test "ttl works" do
    assert R.set(:pi, "asd") == :ok
    assert R.ttl(:pi) == -1
  end

  test "flushall works" do
    assert R.flushall == :ok
  end
end
