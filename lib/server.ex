defmodule Server do
  @moduledoc """
  The server is responsible for inserting into the parsed BST and encoding the result.
  The router sends parsed JSON to the server's handle function, which returns a response to the router.
  """

  @doc """
  Starts the webserver listening on port 8080.
  """
  def start() do
    Plug.Cowboy.http(Router, [], port: 8080)
  end
  
  @spec handle_insert(map) :: {:ok, String.t} | {:err, String.t}
  @doc """
  Given a parsed JSON object, either send an updated BST or an error back.
  """
  def handle_insert(request_map) do
    case request_map do # Match on the parsed JSON
      %{"value" => value, "data" => node_map} -> # We expect to receive this
        try do # BSTNode.from_map raises an exception if map cannot be transformed to BSTNode struct
          node = BSTNode.from_map(node_map)
          updated_node = BSTNode.insert(node, value)
          response_map = %{"status" => 200, "data" => updated_node} # Pack response
          body = Poison.encode!(response_map) # Encode response
          {:ok, body}
        rescue
          e in RuntimeError ->
          {:err, make_err_resp(e.message)}
        end
      _ -> {:err, make_err_resp("JSON parsed successfully but was in the wrong format")}
    end
  end

  # Helper function for creating error responses
  defp make_err_resp(err_msg) do
    response_map = %{"status" => 402, "data" => err_msg} # Pack response
    encoded_err_resp = Poison.encode!(response_map) # Encode response
    encoded_err_resp
  end

   

  
end
