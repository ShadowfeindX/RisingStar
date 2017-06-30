defmodule Name do
  # @enforce_keys [:first, :last]
  defstruct last: "Doe", first: "John"
end
defmodule Client do
  # @enforce_keys [:acct, :name]
  defstruct acct: nil, name: %Name{}, balance: 0
end

defmodule RisingStar do
  @moduledoc """
  This is part of an ongoing challenge to
  test programmers software design skills. 
  """

  @doc """
  Start main program

  ## Example

      iex> RisingStar.main
      :ok
  """
  def main(clients \\ %{})
  def main(nil), do: nil
  def main(clients) do
    code = """
    1 - Add Client
    2 - Search Client
    3 - Update Client
    0 - Exit
    """ |> IO.gets |> String.trim |> String.to_integer
    case code do
      0 -> nil
      1 -> clients |> add
      2 -> clients |> search
      3 -> clients |> update
      _ -> clients
    end |> main
  end

  defp to_name(str) do
    [last, first] = str |> String.split(",")
    %Name{first: first, last: last}
  end

  defp get_name do
    """
    Enter client name in (Last,First) format.
    """ |> IO.gets |> String.trim |> to_name
  end

  defp add(clients) do
    name = get_name
    id = clients |> map_size
    client = %Client{acct: id, name: name}
    IO.inspect client
    Map.put_new clients, id, client
  end

  defp filter(nil, _), do: nil
  defp filter({:id, id}, clients), do: [{id, clients[id]}]
  defp filter({:first, first}, clients), do: Enum.filter(clients, fn {_id, %Client{name: name}} -> first == name.first end)
  defp filter({:last, last}, clients), do: Enum.filter(clients, fn {_id, %Client{name: name}} -> last == name.last end)

  defp search(clients) do
    type = """
    1 - Search by Account Number
    2 - Search by First Name
    3 - Search by Last Name
    """ |> IO.gets |> String.trim |> String.to_integer

    info = """
    Enter Client Information
    """ |> IO.gets |> String.trim

    case type do
      1 -> {:id, String.to_integer info}
      2 -> {:first, info}
      3 -> {:last, info}
      _ -> nil
    end |> filter(clients) |> Enum.unzip |> elem(1) |> Enum.each(&IO.inspect/1)

    clients
  end

  defp update(clients) do
    type = """
    1 - Update Balance
    2 - Change Account Name
    """ |> IO.gets |> String.trim |> String.to_integer

    id = """
    Enter account number
    """ |> IO.gets |> String.trim |> String.to_integer

    case type do
      1 -> :balance
      2 -> :name
    end |> update(id, clients)
  end

  defp update(:balance, id, clients) do
    balance = """
    Enter new account balance
    """ |> IO.gets |> String.trim |> String.to_integer
    %{clients | id => %{clients[id] | balance: balance}}
  end

  defp update(:name, id, clients) do
    %{clients | id => %{clients[id] | name: get_name}}
  end
end
