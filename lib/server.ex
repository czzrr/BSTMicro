defmodule Server do
  @moduledoc """
  The server is responsible for the business logic.
  The router sends parsed JSON to the server's handle functions, which returns responses to the router.
  """

  def start() do
    Plug.Cowboy.http(Router, [], port: 8080)
  end
  
  @spec handle_insert(%{}) :: {:ok, String.t()} | {:err, String.t()}

  @doc """
  Given a parsed JSON object, either send an updated BST or an error back.
  """
  def handle_insert(request_map) do
    case request_map do # Match on the parsed JSON
      %{"value" => value, "data" => node_map} -> # We expect to receive this
        try do # BSTMicro.mapToBSTNode() raises an exception if map cannot be transformed to BSTNode struct
          node = BSTNode.mapToBSTNode(node_map)
          updated_node = BSTNode.insert(node, value)
          response_map = %{"status" => 200, "data" => updated_node} # Pack response
          body = Poison.encode!(response_map) # Encode response
          {:ok, body}
        rescue
          e in RuntimeError ->
          {:err, make_err_resp(e.message)}
        end
      _ -> {:err, make_err_resp("Invalid input")}
    end
  end

  def make_err_resp(err_msg) do
    response_map = %{"status" => 402, "data" => err_msg} # Pack response
    body = Poison.encode!(response_map) # Encode response
    body
  end

   

  
end
