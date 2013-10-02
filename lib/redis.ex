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

  @spec set(key,value) :: sts_reply
  def set(key,value) do
    call_server {:set, key, value}
  end

  @spec ttl(key) :: int_reply
  def ttl(key) do
    call_server {:ttl, key}
  end

  @spec flushall :: sts_reply
  def flushall do
    call_server :flushall
  end

  @spec call_server(tuple|atom) :: value
  defp call_server(args) do
    :gen_server.call(client, args)
  end

  @spec client :: pid
  defp client do
    Process.whereis(:redis)
  end

end