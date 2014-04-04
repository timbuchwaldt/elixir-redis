defmodule Redis.Server do
  use GenServer.Behaviour

  @type client :: pid
  @type key :: binary | atom
  @type value :: binary | atom | integer
  @type sts_reply :: :ok | binary


  def defaults do
    [host: '127.0.0.1',
      port: 6379,
      db: 0,
      password: '',
      reconnect_sleep: 100]
  end

  def init(options) do
    case options do
      [] -> :eredis.start_link
      _ ->
        options = Dict.merge(defaults, options)

        :eredis.start_link(options[:host],
                           options[:port],
                           options[:db],
                           options[:password],
                           options[:reconnect_sleep])
    end
  end

  def handle_call({:exec}, _from, client) do
    res = :eredis.q(client, ["EXEC"])
    { :reply, res, client }
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

  def handle_call({command, key, field,  value}, _from, client) do
    cmdstring = String.upcase(to_string(command))
    res = client |> query([cmdstring, key, field, value])
    { :reply, res, client }
  end

  def handle_call({command, key, range_start, range_end}, _from, client) do
    cmdstring = String.upcase(to_string(command))
    res = client |> query([cmdstring, key, range_start, range_end])
    { :reply, res, client }
  end

  def handle_cast({:stop}, client) do
    {:stop, :normal, client}
  end

  def terminate(_reason, client) do
    :eredis.stop(client)
    :ok
  end

  @spec query(pid, list) :: binary
  defp query(client, command) when is_pid(client) and is_list(command), do:
    client |> :eredis.q(command) |> elem 1

end
