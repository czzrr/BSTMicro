defmodule Service do
  @moduledoc """
  Documentation for Service.
  """

  @doc """
  Send a request for inserting a value into the binary search tree rooted at node.
  The function returns either {:ok, updated_node} on success or {:err, err_msg} on failure.
  """
  def request_insert(node, value) do
    body = Poison.encode!(%{"value" => value, "data" => node}) # Encode the JSON object we want to send

    # We expect HTTPoison.post() to return a tuple containing :ok and the response if all went well.
    {:ok, response} = HTTPoison.post("localhost:8080/insert", body, [{"content-type", "application/json"}])
    response_map = Poison.decode!(response.body) # Decode body to JSON object
    # Pattern match on the response
    case response_map do
      # Succesful insert
      %{"status" => 200, "data" => node} ->
        updated_node = BSTNode.mapToBSTNode(node) # Transform the map into a BSTNode struct
        {:ok, updated_node} # Return the updated node along with an :ok flag
        
      # Something went wrong
      %{"status" => 402, "data" => err_msg} ->
        {:err, err_msg} # Return an :err flag and the error message
      _ -> {:err, nil} # Remaining cases not considered
    end
  end

  def request_insert!(node, value) do
    case request_insert(node, value) do
      {_, x} -> x
    end
  end
end
