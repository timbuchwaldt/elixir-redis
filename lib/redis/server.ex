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

  def handle_call({command}, _from, client) do
    cmdstring = String.upcase(to_string(command))
    res = client |> query([cmdstring])
    { :reply, res, client }
  end

  def handle_call({command, key}, _from, client) do
    cmdstring = String.upcase(to_string(command))
    res = client |> query([cmdstring, key])
    { :reply, res, client }
  end

  def handle_call({command, key, value}, _from, client) do
    cmdstring = String.upcase(to_string(command))
    res = client |> query([cmdstring, key, value])
    { :reply, res, client }
  end

  @spec query(pid, list) :: binary
  defp query(client, command) when is_pid(client) and is_list(command), do:
    client |> :eredis.q(command) |> elem 1

end

