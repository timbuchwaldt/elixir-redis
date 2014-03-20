defmodule Redis do
  # defined basic types
  @type key :: binary | atom
  @type value :: binary | atom | integer
  @type sts_reply :: :ok | binary
  @type int_reply :: integer
  @type name :: atom | []
  @type secs :: integer

  def start() do
    :gen_server.start( {:local, :redis}, Redis.Server, [], [])
  end

  @spec connect([Keyword.t] | []) :: {:ok, pid} | {:error, Reason::term()}
  def connect(options\\[]) do
    :gen_server.start(Redis.Server, options, [])
  end

  def stop(pid) do
    :gen_server.cast(pid || client, {:stop})
  end

  @spec get(pid, key) :: value
  def get(pid\\nil, key) do
    call_server(pid, { :get, key })
  end

  @spec set(pid, key, value) :: sts_reply
  def set(pid\\nil, key, value) do
    call_server(pid, { :set, key, value }) |> sts_reply
  end

  def del(pid\\nil, key) do
    call_server(pid, { :del, key }) |> int_reply
  end

  def rpush(pid\\nil, key, value) do
    call_server(pid, { :rpush, key, value }) |> int_reply
  end

  def lrange(pid\\nil,key, a, b) do
    call_server(pid, { :lrange, key, a, b }) |> sts_reply
  end

  def zadd(pid\\nil, key, score, value) do
    call_server(pid, { :zadd, key, score, value }) |> int_reply
  end

  def zrem(pid\\nil, key, value) do
    call_server(pid, { :zrem, key, value }) |> int_reply
  end

  def incr(pid\\nil, key) do
    call_server(pid, { :incr, key }) |> int_reply
  end

  def publish(pid\\nil, channel, message) do
    call_server(pid, { :publish, channel, message }) |> int_reply
  end

  def multi(pid\\nil, func) do
    call_server(pid, { :multi })
    func.()
    {:ok, result} = call_server(pid, { :exec })
    Enum.map(result, &map_reply/1)
  end

  # Set functions:

  @spec sadd(pid, key, value) :: int_reply
  def sadd(pid\\nil, key, value) do
    call_server(pid, { :sadd, key, value }) |> int_reply
  end

  @spec smembers(pid, key) :: sts_reply
  def smembers(pid\\nil, key) do
    call_server(pid, { :smembers, key }) |> sts_reply
  end

  @spec scard(pid, key) :: int_reply
  def scard(pid\\nil, key) do
    call_server(pid, { :scard, key }) |> int_reply
  end

  @spec sismember(pid, key, value) :: int_reply
  def sismember(pid\\nil, key, value) do
    call_server(pid, { :sismember, key, value }) |> int_reply
  end

  @spec spop(pid, key) :: sts_reply
  def spop(pid\\nil, key) do
    call_server(pid, { :spop, key }) |> sts_reply
  end

  @spec srandmember(pid, key) :: sts_reply
  def srandmember(pid\\nil, key) do
    call_server(pid, { :srandmember, key }) |> sts_reply
  end

  @spec srem(pid, key, value) :: int_reply
  def srem(pid\\nil, key, value) do
    call_server(pid, { :srem, key, value }) |> int_reply
  end

  # end set functions

  @spec ttl(pid, key) :: int_reply
  def ttl(pid\\nil, key) do
    call_server(pid, {:ttl, key}) |> int_reply
  end

  @spec expire(pid, key, value) :: int_reply
  def expire(pid\\nil, key, value) do
    call_server(pid, {:expire, key, value}) |> int_reply
  end
  
  @spec setex(pid, key, secs, value) :: sts_reply
  def setex(pid \\ nil, key, secs, value) do
    call_server(pid, {:setex, key, secs, value}) |> sts_reply
  end
  
  @spec flushall(pid) :: sts_reply
  def flushall(pid\\nil) do
    call_server(pid, {:flushall}) |> sts_reply
  end

  @spec call_server(pid, tuple|atom) :: value
  defp call_server(pid, args) do
    :gen_server.call(pid || client, args)
  end

  @spec client() :: pid
  defp client do
    Process.whereis(:redis)
  end

  @spec int_reply(binary) :: integer
  defp int_reply(reply), do:
    reply |> binary_to_integer

  @spec sts_reply(binary) :: :ok | binary
  defp sts_reply("OK"), do:
    :ok

  defp sts_reply(reply), do:
    reply

  defp map_reply("OK"), do: :ok
  defp map_reply(reply), do: reply
end
