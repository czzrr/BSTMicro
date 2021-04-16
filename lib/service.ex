defmodule Service do
  @moduledoc """
  Module for sending requests for inserting.
  """

  @spec request_insert(BSTNode, integer) :: {:ok, BSTNode} | {:err, String.t}
  @doc """
  Send a request for inserting a value into the binary search tree.
  The function returns either {:ok, updated_node} on success or {:err, err_msg} on failure.
  """
  def request_insert(node, value) do
    body = Poison.encode!(%{"value" => value, "data" => node}) # Encode the data we want to send
    # We expect HTTPoison.post() to return a tuple containing :ok and the response if all went well.
    {:ok, response} = HTTPoison.post("localhost:8080/insert", body, [{"content-type", "application/json"}])

    response_map = Poison.decode!(response.body) # Decode body to JSON object
    # Pattern match on the response

    IO.inspect response_map
    IO.puts ""
    
    case response_map do
      # Successful insert
      %{"status" => 200, "data" => node_map} ->
        {:ok, updated_node} = BSTNode.from_map(node_map) # Transform the map into a BSTNode struct
        updated_node
        
      # Something went wrong
      %{"status" => 402, "data" => err_msg} ->
        err_msg
      _ -> :err
    end
  end
end
