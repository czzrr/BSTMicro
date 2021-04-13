defmodule Utils do
  @moduledoc """
  Module for utility functions.
  """
  @spec make_err_resp(String.t) :: String.t
  @doc """
  # Helper function for creating error responses in the format {"status": 402, "data": <error_message>}.
  """
  def make_err_resp(err_msg) do
    response_map = %{"status" => 402, "data" => err_msg} # Pack response
    encoded_err_resp = Poison.encode!(response_map) # Encode response
    encoded_err_resp
  end
end
