defmodule Redis.Server do
  use GenServer.Behaviour

  @type client :: pid
  @type key :: binary | atom
  @type value :: binary | atom | integer
  @type sts_reply :: :ok | binary

  @spec init([]) :: {:ok, pid}
  def init([]) do
    :eredis.start_link()
  end

  @spec handle_call({:get, key}, {pid, any}, pid) :: {:reply, value, pid}
  def handle_call({:get, key}, _from, client) do
    res = client |> query ["GET", key]
    { :reply, res, client }
  end

  @spec handle_call({:set, key, value}, {pid, any}, pid) :: {:reply, sts_reply, pid}
  def handle_call({:set, key, value}, _from, client) do
    res = client |> query(["SET", key, value]) |> sts_reply
    { :reply, res, client }
  end

  @spec handle_call({:ttl, key}, {pid, any}, pid) :: {:reply, integer, pid}
  def handle_call({:ttl, key}, _from, client) do
    res = client |> query(["TTL", key]) |> int_reply
    { :reply, res, client }
  end

  @spec handle_call({:flushall, key}, {pid, any}, pid) :: {:reply, sts_reply, pid}
  def handle_call(:flushall, _from, client) do
    res = client |> query(["FLUSHALL"]) |> sts_reply
    { :reply, res, client }
  end


  # private functions
  @spec int_reply(binary) :: integer
  defp int_reply(reply), do:
    reply |> binary_to_integer

  @spec sts_reply(binary) :: :ok | binary
  defp sts_reply("OK"), do:
    :ok

  defp sts_reply(reply), do:
    reply

  @spec query(pid, list) :: binary
  defp query(client, command) when is_pid(client) and is_list(command), do:
    client |> :eredis.q(command) |> elem 1

end

