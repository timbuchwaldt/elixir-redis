defmodule Redis do
  # defined basic types
  @type key :: binary | atom
  @type value :: binary | atom | integer
  @type sts_reply :: :ok | binary
  @type int_reply :: integer

  @spec start :: {:ok, pid}
  def start do
    :gen_server.start( {:local,:redis}, Redis.Server, [], [] )
  end

  @spec get(key) :: value
  def get(key) do
    call_server { :get, key }
  end

  @spec set(key, value) :: sts_reply
  def set(key, value) do
    call_server({ :set, key, value }) |> sts_reply
  end

  @spec sadd(key, value) :: sts_reply
  def sadd(key, value) do
    call_server({ :set, key, value }) |> sts_reply
  end

  @spec smembers(key) :: sts_reply
  def smembers(key) do
    call_server({ :smembers, key }) |> sts_reply
  end

  @spec ttl(key) :: int_reply
  def ttl(key) do
    call_server({:ttl, key}) |> int_reply
  end

  @spec expire(key, value) :: int_reply
  def expire(key, value) do
    call_server({:expire, key, value}) |> int_reply
  end

  @spec flushall :: sts_reply
  def flushall do
    call_server({:flushall}) |> sts_reply
  end

  @spec call_server(tuple|atom) :: value
  defp call_server(args) do
    :gen_server.call(client, args)
  end

  @spec client :: pid
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
end
